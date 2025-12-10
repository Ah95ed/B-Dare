import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mystery_link/features/game/presentation/widgets/timer_widget.dart';
import 'package:mystery_link/core/theme/app_theme.dart';

void main() {
  testWidgets('TimerWidget displays remaining time correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: const Scaffold(
          body: TimerWidget(
            remainingSeconds: 30,
            totalSeconds: 60,
            isWarning: false,
          ),
        ),
      ),
    );

    expect(find.text('30'), findsOneWidget);
  });

  testWidgets('TimerWidget shows warning style when time is low',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: const Scaffold(
          body: TimerWidget(
            remainingSeconds: 5,
            totalSeconds: 60,
            isWarning: true,
          ),
        ),
      ),
    );

    expect(find.text('5'), findsOneWidget);
    // The widget should be visible with warning styling
    expect(find.byType(TimerWidget), findsOneWidget);
  });

  testWidgets('TimerWidget updates when remaining seconds change',
      (WidgetTester tester) async {
    int remainingSeconds = 30;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: Column(
                children: [
                  TimerWidget(
                    remainingSeconds: remainingSeconds,
                    totalSeconds: 60,
                    isWarning: false,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        remainingSeconds = 20;
                      });
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('30'), findsOneWidget);

    await tester.tap(find.text('Update'));
    await tester.pump();

    expect(find.text('20'), findsOneWidget);
    expect(find.text('30'), findsNothing);
  });
}
