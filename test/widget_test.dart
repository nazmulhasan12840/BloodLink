import 'package:flutter_test/flutter_test.dart';
import 'package:bloodlink/main.dart';

void main() {
  testWidgets('BloodLink app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const BloodLinkApp());
    expect(find.text('Welcome to BloodLink'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
