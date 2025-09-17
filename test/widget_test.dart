// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:act4/main.dart';

void main() {
  testWidgets('Emoji drawing app loads', (WidgetTester tester) async {

    await tester.pumpWidget(const EmojiDrawingApp());

    expect(find.text('Interactive Emoji Drawing (ACT4)'), findsOneWidget);

    expect(find.text('Emoji:'), findsOneWidget);
    expect(find.text('Party Face'), findsOneWidget);
  });
}
