import 'package:flutter/services.dart';
import 'secure_clipboard_platform_interface.dart';

base class MethodChannelSecureClipboard extends SecureClipboardPlatform {
  static const MethodChannel _methodChannel = MethodChannel('secure_clipboard/methods');
  static const EventChannel _eventChannel = EventChannel('secure_clipboard/events');

  @override
  Future<void> copy(String text, {Duration? autoClearAfter}) async {
    await _methodChannel.invokeMethod('copy', {
      'text': text,
      'autoClearAfter': autoClearAfter?.inMilliseconds,
    });
  }

  @override
  Future<void> clear() async {
    await _methodChannel.invokeMethod('clear');
  }

  @override
  Stream<String?> get onClipboardChanged {
    return _eventChannel.receiveBroadcastStream().map((event) => event as String?);
  }
}
