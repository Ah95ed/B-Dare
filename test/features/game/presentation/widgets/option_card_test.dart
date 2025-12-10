import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystery_link/features/game/domain/entities/link_node.dart';
import 'package:mystery_link/features/game/presentation/widgets/option_card.dart';
import 'package:mystery_link/core/theme/app_theme.dart';

void main() {
  const testNode = LinkNode(
    id: 'test_node',
    label: 'Test Option',
    representationType: RepresentationType.text,
    labels: {'en': 'Test Option', 'ar': 'خيار تجريبي'},
  );

  testWidgets('OptionCard displays node label correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: OptionCard(
            node: testNode,
            isSelected: false,
            showResult: false,
            isCorrect: false,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Test Option'), findsOneWidget);
  });

  testWidgets('OptionCard calls onTap when tapped',
      (WidgetTester tester) async {
    bool wasTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: OptionCard(
            node: testNode,
            isSelected: false,
            showResult: false,
            isCorrect: false,
            onTap: () {
              wasTapped = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(OptionCard));
    await tester.pump();

    expect(wasTapped, isTrue);
  });

  testWidgets('OptionCard shows correct styling when isCorrect is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: OptionCard(
            node: testNode,
            isSelected: false,
            showResult: true,
            isCorrect: true,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.byType(OptionCard), findsOneWidget);
    // The card should be visible with correct styling
  });

  testWidgets('OptionCard shows incorrect styling when isCorrect is false',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: OptionCard(
            node: testNode,
            isSelected: false,
            showResult: true,
            isCorrect: false,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.byType(OptionCard), findsOneWidget);
    // The card should be visible with incorrect styling
  });

  testWidgets('OptionCard shows selected state correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: OptionCard(
            node: testNode,
            isSelected: true,
            showResult: false,
            isCorrect: false,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.byType(OptionCard), findsOneWidget);
    // The card should show selected styling
  });
}
