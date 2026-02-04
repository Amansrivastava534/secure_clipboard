import 'dart:io';
import 'package:flutter/material.dart';
import 'package:secure_clipboard/secure_clipboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const SecureClipboardHome(),
    );
  }
}

class SecureClipboardHome extends StatefulWidget {
  const SecureClipboardHome({super.key});

  @override
  State<SecureClipboardHome> createState() => _SecureClipboardHomeState();
}

class _SecureClipboardHomeState extends State<SecureClipboardHome> {
  final _textController = TextEditingController();
  int _autoClearSeconds = 5;
  bool _localOnly = false;
  String? _lastClipboardContent;
  String? _retrievedData;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _startListening();
    _checkClipboard();
  }

  void _startListening() {
    SecureClipboard.onClipboardChanged.listen((content) {
      if (mounted) {
        setState(() {
          _lastClipboardContent = content;
        });
        _checkClipboard();
      }
    });
  }

  Future<void> _checkClipboard() async {
    final hasText = await SecureClipboard.hasText();
    setState(() {
      _hasText = hasText;
    });
  }

  Future<void> _getData() async {
    final data = await SecureClipboard.getData();
    setState(() {
      _retrievedData = data;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Retrieved: ${data ?? "(Empty)"}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Clipboard Example'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Copy to Clipboard',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: 'Text to copy',
                        border: OutlineInputBorder(),
                        hintText: 'Enter sensitive data...',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Auto-clear after:'),
                        Expanded(
                          child: Slider(
                            value: _autoClearSeconds.toDouble(),
                            min: 0,
                            max: 30,
                            divisions: 30,
                            label: '${_autoClearSeconds}s',
                            onChanged: (value) {
                              setState(() {
                                _autoClearSeconds = value.toInt();
                              });
                            },
                          ),
                        ),
                        Text('${_autoClearSeconds}s'),
                      ],
                    ),
                    if (Platform.isIOS)
                      SwitchListTile(
                        title: const Text('Local Only (iOS)'),
                        subtitle: const Text('Prevent Universal Clipboard sync'),
                        value: _localOnly,
                        onChanged: (value) {
                          setState(() {
                            _localOnly = value;
                          });
                        },
                      ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        SecureClipboard.copy(
                          _textController.text,
                          autoClearAfter: _autoClearSeconds > 0
                              ? Duration(seconds: _autoClearSeconds)
                              : null,
                          localOnly: _localOnly,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Copied${_localOnly ? ' (local-only)' : ''}${_autoClearSeconds > 0 ? ' - will clear in ${_autoClearSeconds}s' : ''}',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.content_copy),
                      label: const Text('Copy to Secure Clipboard'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Clipboard Actions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Clipboard Actions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _getData,
                            icon: const Icon(Icons.download),
                            label: const Text('Get Data'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              SecureClipboard.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Clipboard cleared')),
                              );
                              _checkClipboard();
                            },
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          _hasText ? Icons.check_circle : Icons.cancel,
                          color: _hasText ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _hasText ? 'Clipboard has text' : 'Clipboard is empty',
                          style: TextStyle(
                            color: _hasText ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Retrieved Data
            if (_retrievedData != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Retrieved Data:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _retrievedData!,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Stream Listener
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Last Clipboard Content (Stream):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _lastClipboardContent ?? '(Empty)',
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Info
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Security Features',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Platform.isAndroid
                          ? '• Android 13+: Content is marked as sensitive\n'
                              '• Auto-clear: Clipboard clears after timeout\n'
                              '• hasText(): Check without reading content'
                          : '• Local-only: Prevents iCloud sync\n'
                              '• Auto-clear: Clipboard clears after timeout\n'
                              '• hasText(): Check without reading content\n'
                              '• Stream: Foreground detection only',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
