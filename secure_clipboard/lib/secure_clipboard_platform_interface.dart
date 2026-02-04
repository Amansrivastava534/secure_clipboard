import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'secure_clipboard_method_channel.dart';

abstract class SecureClipboardPlatform extends PlatformInterface {
  /// Constructs a SecureClipboardPlatform.
  SecureClipboardPlatform() : super(token: _token);

  static final Object _token = Object();

  static SecureClipboardPlatform _instance = MethodChannelSecureClipboard();

  /// The default instance of [SecureClipboardPlatform] to use.
  ///
  /// Defaults to [MethodChannelSecureClipboard].
  static SecureClipboardPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SecureClipboardPlatform] when
  /// they register themselves.
  static set instance(SecureClipboardPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
