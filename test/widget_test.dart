// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(FKTGo());

    expect(find.text('Ready?'), findsOneWidget);
    expect(find.text('Go'), findsOneWidget);

    // Tap the 'Go' button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Ready?'), findsNothing);
    expect(find.text('Stop'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text('Ready?'), findsOneWidget);
    expect(find.text('Go'), findsOneWidget);
  });
}
