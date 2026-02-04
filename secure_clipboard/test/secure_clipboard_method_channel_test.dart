import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_clipboard_platform_interface/method_channel_secure_clipboard.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelSecureClipboard platform = MethodChannelSecureClipboard();
  const MethodChannel channel = MethodChannel('secure_clipboard/methods');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('copy', () async {
    await platform.copy('test');
  });

  test('clear', () async {
    await platform.clear();
  });
}
