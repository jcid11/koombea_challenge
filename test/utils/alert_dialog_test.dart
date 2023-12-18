import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koombea_test/utils/alert_dialog.dart';

void main() {
  testWidgets('Test loadingDialog', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () async {
                await loadingDialog(context);
              },
              child: const Text('Show Loading Dialog'),
            );
          },
        ),
      ),
    );

    // Tap the button to show the loading dialog.
    await tester.tap(find.text('Show Loading Dialog'));
    await tester.pump();

    // Verify that the loading dialog is displayed.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Test failDialog', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () async {
                await failDialog(context);
              },
              child: const Text('Show Fail Dialog'),
            );
          },
        ),
      ),
    );

    // Tap the button to show the fail dialog.
    await tester.tap(find.text('Show Fail Dialog'));
    await tester.pump();

    // Verify that the fail dialog is displayed.
    expect(find.text('it failed'), findsOneWidget);
  });
}
