import 'dart:async';
import 'package:secure_clipboard_platform_interface/secure_clipboard_platform_interface.dart';

/// A secure clipboard manager that provides features like sensitive data marking
/// (Android 13+) and auto-clearing after a specific duration.
class SecureClipboard {
  /// Copies [text] to the clipboard.
  /// 
  /// [autoClearAfter] optionally specifies a duration after which the clipboard 
  /// will be automatically cleared.
  /// 
  /// Security Note:
  /// - On Android 13+, the content is marked with `EXTRA_IS_SENSITIVE` which 
  ///   obfuscates it in the system's clipboard preview UI.
  /// - On iOS, there is no system-level sensitive marking for the clipboard 
  ///   preview, but [autoClearAfter] can be used to minimize exposure.
  static Future<void> copy(String text, {Duration? autoClearAfter}) {
    return SecureClipboardPlatform.instance.copy(text, autoClearAfter: autoClearAfter);
  }

  /// Clears the system clipboard.
  static Future<void> clear() {
    return SecureClipboardPlatform.instance.clear();
  }

  /// A stream that emits clipboard content changes.
  /// 
  /// Note: On iOS, this only fires when the app is in the foreground due to 
  /// OS-level privacy restrictions.
  static Stream<String?> get onClipboardChanged => 
      SecureClipboardPlatform.instance.onClipboardChanged;
}
