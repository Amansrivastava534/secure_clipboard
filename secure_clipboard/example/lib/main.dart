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
  String? _lastClipboardContent;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    SecureClipboard.onClipboardChanged.listen((content) {
      if (mounted) {
        setState(() {
          _lastClipboardContent = content;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Clipboard Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Text to copy',
                border: OutlineInputBorder(),
              ),
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
            ElevatedButton(
              onPressed: () {
                SecureClipboard.copy(
                  _textController.text,
                  autoClearAfter: _autoClearSeconds > 0 
                      ? Duration(seconds: _autoClearSeconds) 
                      : null,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
              },
              child: const Text('Copy to Secure Clipboard'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                SecureClipboard.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Clipboard cleared')),
                );
              },
              child: const Text('Clear Clipboard'),
            ),
            const Divider(height: 32),
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
            const SizedBox(height: 16),
            const Text(
              'Note: On Android 13+, copying will trigger a masked preview. On iOS, change detection only works in foreground.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
