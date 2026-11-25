import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/main.dart';

void main() {
  testWidgets('English language and navigation work',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, Farmer! 🌱'), findsOneWidget);

    await tester.tap(find.text('Market'));
    await tester.pumpAndSettle();

    expect(find.text('Market'), findsWidgets);
  });

  testWidgets('Hindi language selection works',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('हिंदी'));
    await tester.pumpAndSettle();

    expect(find.text('नमस्ते किसान! 🌱'), findsOneWidget);
  });
}