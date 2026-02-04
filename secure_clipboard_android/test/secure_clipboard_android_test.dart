import 'package:flutter_test/flutter_test.dart';
import 'package:secure_clipboard_android/secure_clipboard_android.dart';
import 'package:secure_clipboard_platform_interface/secure_clipboard_platform_interface.dart';
import 'package:secure_clipboard_platform_interface/method_channel_secure_clipboard.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  test('SecureClipboardAndroid is a valid instance', () {
    final instance = SecureClipboardAndroid();
    expect(instance, isInstanceOf<MethodChannelSecureClipboard>());
  });

  test('registerWith', () {
    SecureClipboardAndroid.registerWith();
    expect(SecureClipboardPlatform.instance, isInstanceOf<SecureClipboardAndroid>());
  });
}
