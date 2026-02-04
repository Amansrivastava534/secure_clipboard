package com.example.secure_clipboard_android

import android.content.ClipData
import android.content.ClipDescription
import android.content.ClipboardManager
import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class SecureClipboardAndroidPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
  private lateinit var methodChannel : MethodChannel
  private lateinit var eventChannel : EventChannel
  private lateinit var clipboardManager: ClipboardManager
  private var context: Context? = null
  private var eventSink: EventChannel.EventSink? = null
  private val handler = Handler(Looper.getMainLooper())
  private var clearRunnable: Runnable? = null

  private val clipChangedListener = ClipboardManager.OnPrimaryClipChangedListener {
    val text = getClipboardText()
    eventSink?.success(text)
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    clipboardManager = context?.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
    
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "secure_clipboard/methods")
    methodChannel.setMethodCallHandler(this)

    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "secure_clipboard/events")
    eventChannel.setStreamHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "copy" -> {
        val text = call.argument<String>("text")
        val autoClearAfter = call.argument<Int>("autoClearAfter")
        if (text != null) {
          copyToClipboard(text, autoClearAfter)
          result.success(null)
        } else {
          result.error("INVALID_ARGUMENT", "Text cannot be null", null)
        }
      }
      "clear" -> {
        clearClipboard()
        result.success(null)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun copyToClipboard(text: String, autoClearAfter: Int?) {
    val clip = ClipData.newPlainText("secure_data", text)
    
    // Mark as sensitive for Android 13+
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        val description = clip.description
        val extras = description.extras ?: android.os.PersistableBundle()
        extras.putBoolean(ClipDescription.EXTRA_IS_SENSITIVE, true)
        description.extras = extras
    }

    clipboardManager.setPrimaryClip(clip)

    // Handle auto-clear
    clearRunnable?.let { handler.removeCallbacks(it) }
    if (autoClearAfter != null && autoClearAfter > 0) {
      clearRunnable = Runnable { clearClipboard() }
      handler.postDelayed(clearRunnable!!, autoClearAfter.toLong())
    }
  }

  private fun clearClipboard() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
      clipboardManager.clearPrimaryClip()
    } else {
      clipboardManager.setPrimaryClip(ClipData.newPlainText("", ""))
    }
  }

  private fun getClipboardText(): String? {
    val clip = clipboardManager.primaryClip
    if (clip != null && clip.itemCount > 0) {
      return clip.getItemAt(0).text?.toString()
    }
    return null
  }

  override fun onDetachedFromEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
    clearRunnable?.let { handler.removeCallbacks(it) }
    context = null
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
    clipboardManager.addPrimaryClipChangedListener(clipChangedListener)
  }

  override fun onCancel(arguments: Any?) {
    clipboardManager.removePrimaryClipChangedListener(clipChangedListener)
    eventSink = null
  }
}
