import 'package:flutter_test/flutter_test.dart';
import 'package:secure_clipboard_ios/secure_clipboard_ios.dart';
import 'package:secure_clipboard_platform_interface/secure_clipboard_platform_interface.dart';
import 'package:secure_clipboard_platform_interface/method_channel_secure_clipboard.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  test('SecureClipboardIos is a valid instance', () {
    final instance = SecureClipboardIos();
    expect(instance, isInstanceOf<MethodChannelSecureClipboard>());
  });

  test('registerWith', () {
    SecureClipboardIos.registerWith();
    expect(SecureClipboardPlatform.instance, isInstanceOf<SecureClipboardIos>());
  });
}
