import Flutter
import UIKit

public class SecureClipboardIosPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  private var clearTimer: Timer?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(name: "secure_clipboard/methods", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "secure_clipboard/events", binaryMessenger: registrar.messenger())
    
    let instance = SecureClipboardIosPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    eventChannel.setStreamHandler(instance)
    
    NotificationCenter.default.addObserver(
        instance,
        selector: #selector(instance.pasteboardChanged),
        name: UIPasteboard.changedNotification,
        object: nil
    )
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "copy":
      if let args = call.arguments as? [String: Any],
         let text = args["text"] as? String {
        let autoClearAfter = args["autoClearAfter"] as? Int
        copyToClipboard(text: text, autoClearAfterMs: autoClearAfter)
        result(nil)
      } else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Text cannot be null", details: nil))
      }
    case "clear":
      clearClipboard()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func copyToClipboard(text: String, autoClearAfterMs: Int?) {
    UIPasteboard.general.string = text
    
    clearTimer?.invalidate()
    if let ms = autoClearAfterMs, ms > 0 {
      let seconds = Double(ms) / 1000.0
      clearTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { [weak self] _ in
        self?.clearClipboard()
      }
    }
  }
  
  private func clearClipboard() {
    UIPasteboard.general.items = []
  }
  
  @objc private func pasteboardChanged() {
    eventSink?(UIPasteboard.general.string)
  }
  
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    return nil
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
    clearTimer?.invalidate()
  }
}
