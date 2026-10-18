// This is a basic Flutter widget test for SvaraPrana.

import 'package:flutter_test/flutter_test.dart';

import 'package:svaraprana/main.dart';

void main() {
  testWidgets('SvaraPranaApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SvaraPranaApp());

    // Verify that our main app widget is mounted.
    expect(find.byType(SvaraPranaApp), findsOneWidget);
  });
}

