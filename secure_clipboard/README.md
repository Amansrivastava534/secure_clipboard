# secure_clipboard

A federated Flutter plugin for secure clipboard management. It provides features to protect sensitive data on the clipboard and automatically clear it after a specified duration.

## Features

- **Sensitive Data Marking (Android 13+)**: Automatically marks copied content as sensitive, which instructs the system to obfuscate or hide the content in the clipboard preview UI.
- **Auto-Clear**: Automatically clears the clipboard after a configurable `Duration`.
- **Manual Clear**: Easily clear the system clipboard programmatically.
- **Clipboard Observer**: A stream to listen for clipboard content changes (foreground only on iOS).
- **Federated Architecture**: Modular design separating platform-specific implementations.

## Installation

Add `secure_clipboard` to your `pubspec.yaml`:

```yaml
dependencies:
  secure_clipboard:
    path: path/to/secure_clipboard
```

## Usage

### Copying to Clipboard

Copy text with an optional auto-clear timer:

```dart
import 'package:secure_clipboard/secure_clipboard.dart';

// Copy normally (marks as sensitive on Android 13+)
await SecureClipboard.copy("my-secret-password");

// Copy with auto-clear after 30 seconds
await SecureClipboard.copy(
  "temporary-token",
  autoClearAfter: Duration(seconds: 30),
);
```

### Clearing the Clipboard

```dart
await SecureClipboard.clear();
```

### Observing Clipboard Changes

```dart
SecureClipboard.onClipboardChanged.listen((String? content) {
  print("Clipboard changed to: $content");
});
```

## Security Considerations

### Android
On Android 13 (API 33) and above, the plugin uses `ClipDescription.EXTRA_IS_SENSITIVE`. This prevents the copied text from appearing in the system's clipboard confirmation overlay, protecting against "shoulder surfing".

### iOS
iOS does not currently provide a way to mask the clipboard preview globally. To mitigate exposure, it is highly recommended to use the `autoClearAfter` feature for sensitive data to ensure it doesn't persist on the clipboard longer than necessary.

### General
Always remember that clipboard data is generally accessible to other apps on the system while it resides there. This plugin helps minimize the **visual exposure** and **persistence** of sensitive data.

## Platform Support

| Feature | Android | iOS |
|---|:---:|:---:|
| Copy/Clear | ✅ | ✅ |
| Change Listener | ✅ | ✅ (Foreground) |
| Sensitive Marking | ✅ (API 33+) | ❌ (N/A) |
| Auto-Clear | ✅ | ✅ |
