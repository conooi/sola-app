import 'package:flutter_test/flutter_test.dart';
import 'package:sola/main.dart';

void main() {
  testWidgets('SolaApp mounts successfully and displays brand name', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SolaApp());

    // Verify that our brand name is displayed.
    expect(find.text('Sola'), findsOneWidget);
    expect(find.text('You are safe here.'), findsOneWidget);
  });
}
