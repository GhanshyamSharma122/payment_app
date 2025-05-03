import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payment_app/screens/authentication_screen.dart';

void main() {
  testWidgets('Authentication screen shows login form', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: AuthenticationScreen(),
    ));

    // Verify that login form elements are present
    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextField), findsWidgets);
  });

  testWidgets('Can toggle between login and register', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: AuthenticationScreen(),
    ));

    // Find and tap the register toggle button
    final registerButton = find.text('Register');
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    // Verify registration form is shown
    expect(find.text('Register Account'), findsOneWidget);
  });
}