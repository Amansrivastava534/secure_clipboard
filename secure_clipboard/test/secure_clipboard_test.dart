import 'package:flutter_test/flutter_test.dart';
import 'package:secure_clipboard/secure_clipboard.dart';
import 'package:secure_clipboard_platform_interface/secure_clipboard_platform_interface.dart';
import 'package:secure_clipboard_platform_interface/method_channel_secure_clipboard.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSecureClipboardPlatform
    with MockPlatformInterfaceMixin
    implements SecureClipboardPlatform {

  @override
  Future<void> copy(String text, {Duration? autoClearAfter}) => Future.value();

  @override
  Future<void> clear() => Future.value();

  @override
  Stream<String?> get onClipboardChanged => const Stream.empty();
}

void main() {
  final SecureClipboardPlatform initialPlatform = SecureClipboardPlatform.instance;

  test('$MethodChannelSecureClipboard is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSecureClipboard>());
  });

  test('copy', () async {
    MockSecureClipboardPlatform fakePlatform = MockSecureClipboardPlatform();
    SecureClipboardPlatform.instance = fakePlatform;

    // Verify it doesn't throw
    await SecureClipboard.copy('test');
  });

  test('clear', () async {
    MockSecureClipboardPlatform fakePlatform = MockSecureClipboardPlatform();
    SecureClipboardPlatform.instance = fakePlatform;

    // Verify it doesn't throw
    await SecureClipboard.clear();
  });
}
