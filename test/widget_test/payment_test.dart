import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payment_app/screens/payment_screen.dart';
import 'package:payment_app/services/api_service.dart';

void main() {
  group('Payment Screen Tests', () {
    testWidgets('Payment screen shows amount input', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: PaymentScreen(senderId: '1', receiverId: '2'),
      ));

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Amount'), findsOneWidget);
    });

    testWidgets('Payment screen validates amount', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: PaymentScreen(senderId: '1', receiverId: '2'),
      ));

      // Find and tap the send button
      final sendButton = find.text('Send');
      await tester.tap(sendButton);
      await tester.pump();

      // Should show validation message for empty amount
      expect(find.text('Please enter an amount'), findsOneWidget);
    });
  });
}