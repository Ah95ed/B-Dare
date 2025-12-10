// Basic smoke test for the app
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystery_link/main.dart';

void main() {
  testWidgets('App initializes and shows home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the app loads without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
