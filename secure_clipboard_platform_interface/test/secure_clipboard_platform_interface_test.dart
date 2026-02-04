import 'package:flutter_test/flutter_test.dart';
import 'package:secure_clipboard_platform_interface/secure_clipboard_platform_interface.dart';
import 'package:secure_clipboard_platform_interface/method_channel_secure_clipboard.dart';

class MockSecureClipboardPlatform extends SecureClipboardPlatform {
  @override
  Future<void> copy(String text, {Duration? autoClearAfter}) => Future.value();

  @override
  Future<void> clear() => Future.value();

  @override
  Stream<String?> get onClipboardChanged => const Stream.empty();
}

void main() {
  test('Default instance is MethodChannelSecureClipboard', () {
    expect(SecureClipboardPlatform.instance, isInstanceOf<MethodChannelSecureClipboard>());
  });

  test('Instance can be set', () {
    final mock = MockSecureClipboardPlatform();
    SecureClipboardPlatform.instance = mock;
    expect(SecureClipboardPlatform.instance, mock);
  });
}
