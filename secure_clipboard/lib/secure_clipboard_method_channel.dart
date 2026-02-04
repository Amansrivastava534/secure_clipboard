import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'secure_clipboard_platform_interface.dart';

/// An implementation of [SecureClipboardPlatform] that uses method channels.
class MethodChannelSecureClipboard extends SecureClipboardPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('secure_clipboard');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
