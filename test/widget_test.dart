// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:study_planner/main.dart';

void main() {
  testWidgets('App starts and renders elements', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    setup();
    // await tester.pumpWidget(MyApp());

    // Verify that there are five input fields
    // expect(find.bySemanticsLabel('Uni'), findsOneWidget);
    // expect(find.bySemanticsLabel('Studiengang'), findsOneWidget);
    //  expect(find.bySemanticsLabel('Credits Hauptstudium'), findsOneWidget);
    //  expect(find.bySemanticsLabel('Credits Auflagen etc.'), findsOneWidget);
    // expect(find.bySemanticsLabel('Ziel Semesteranzahl'), findsOneWidget);
    // expect(find.bySemanticsLabel('Weiter'), findsOneWidget);

    // Tap the button
    // await tester.tap(find.bySemanticsLabel('Weiter'));
    //  await tester.pump();

    // Verify that our counter has incremented.
    // expect(find.text('Uni'), findsOneWidget);
  });
}
