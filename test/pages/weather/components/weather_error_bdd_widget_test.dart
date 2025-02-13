import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/pages/weather/components/weather_error.dart';

import '../../../widget_test_bed.dart';

void main() {
  Future<void> loadPage(
    WidgetTester tester, {
    String? errorMessage,
    VoidCallback? onPressed,
  }) async {
    await tester.pumpWidget(
      WidgetTestbed().simpleWrap(
        child: WeatherError(
          errorMessage: errorMessage,
          onPressed: onPressed,
        ),
      ),
    );
  }

  group('WeatherError', () {
    testWidgets(
      '''
    GIVEN WeatherError widget
    WHEN it is rendered with default values
    THEN it should display default error message and retry button
    ''',
      (tester) async {
        await loadPage(tester);

        expect(find.text('😒'), findsOneWidget);
        expect(find.text('Something went wrong!'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
        expect(find.byIcon(Icons.refresh), findsOneWidget);
      },
    );

    testWidgets(
      '''
    GIVEN WeatherError widget
    WHEN it is rendered with custom error message
    THEN it should display the custom message
    ''',
      (tester) async {
        const customError = 'Custom error message';
        await loadPage(tester, errorMessage: customError);

        expect(find.text(customError), findsOneWidget);
      },
    );

    testWidgets(
      '''
    GIVEN WeatherError widget with onPressed callback
    WHEN retry button is tapped
    THEN onPressed callback should be triggered
    ''',
      (tester) async {
        var callbackCalled = false;
        await loadPage(
          tester,
          onPressed: () => callbackCalled = true,
        );

        await tester.tap(find.text('Retry'));
        await tester.pump();

        expect(callbackCalled, true);
      },
    );

    testWidgets(
      '''
    GIVEN WeatherError widget
    WHEN it is rendered
    THEN it should have correct styling and layout
    ''',
      (tester) async {
        await loadPage(tester);

        final emojiText = tester.widget<Text>(
          find.text('😒'),
        );
        expect(emojiText.style?.fontSize, 64);

        expect(find.byType(Column), findsOneWidget);

        final sizedBox = tester.widget<SizedBox>(
          find.byWidgetPredicate(
            (widget) => widget is SizedBox && widget.height == 8.0,
          ),
        );
        expect(sizedBox.height, 8);
      },
    );
  });
}
