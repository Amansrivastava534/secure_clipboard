import 'package:secure_clipboard_platform_interface/secure_clipboard_platform_interface.dart';
import 'package:secure_clipboard_platform_interface/method_channel_secure_clipboard.dart';

class SecureClipboardAndroid extends MethodChannelSecureClipboard {
  static void registerWith() {
    SecureClipboardPlatform.instance = SecureClipboardAndroid();
  }
}
