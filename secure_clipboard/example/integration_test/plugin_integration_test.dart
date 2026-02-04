import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:secure_clipboard/secure_clipboard.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('copy and clear test', (WidgetTester tester) async {
    // These calls interact with the host platform. 
    // We just verify they don't throw exception.
    await SecureClipboard.copy('integration test');
    await SecureClipboard.clear();
  });
}
