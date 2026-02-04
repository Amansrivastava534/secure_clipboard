import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'method_channel_secure_clipboard.dart';

abstract base class SecureClipboardPlatform extends PlatformInterface {
  SecureClipboardPlatform() : super(token: _token);

  static final Object _token = Object();

  static SecureClipboardPlatform _instance = MethodChannelSecureClipboard();

  static SecureClipboardPlatform get instance => _instance;

  static set instance(SecureClipboardPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> copy(String text, {Duration? autoClearAfter}) {
    throw UnimplementedError('copy() has not been implemented.');
  }

  Future<void> clear() {
    throw UnimplementedError('clear() has not been implemented.');
  }

  Stream<String?> get onClipboardChanged {
    throw UnimplementedError('onClipboardChanged has not been implemented.');
  }
}
