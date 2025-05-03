import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payment_app/main.dart';

void main() {
  testWidgets('App should render without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Verify that the app renders
    expect(find.text('Payment App'), findsOneWidget);
  });
}