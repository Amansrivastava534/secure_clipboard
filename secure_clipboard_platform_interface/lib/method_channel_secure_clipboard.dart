import 'package:flutter/services.dart';
import 'secure_clipboard_platform_interface.dart';

base class MethodChannelSecureClipboard extends SecureClipboardPlatform {
  static const MethodChannel _methodChannel = MethodChannel('secure_clipboard/methods');
  static const EventChannel _eventChannel = EventChannel('secure_clipboard/events');

  @override
  Future<void> copy(String text, {Duration? autoClearAfter, bool localOnly = false}) async {
    await _methodChannel.invokeMethod('copy', {
      'text': text,
      'autoClearAfter': autoClearAfter?.inMilliseconds,
      'localOnly': localOnly,
    });
  }

  @override
  Future<void> clear() async {
    await _methodChannel.invokeMethod('clear');
  }

  @override
  Future<bool> hasText() async {
    final bool? hasText = await _methodChannel.invokeMethod<bool>('hasText');
    return hasText ?? false;
  }

  @override
  Future<String?> getData() async {
    return await _methodChannel.invokeMethod<String>('getData');
  }

  @override
  Stream<String?> get onClipboardChanged {
    return _eventChannel.receiveBroadcastStream().map((event) => event as String?);
  }
}
