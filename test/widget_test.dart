// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:contatos/main.dart';

void main() {
  testWidgets('Agenda widget smoke test', (WidgetTester tester) async {
    // Build just the Agenda widget and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Agenda(),
      ),
    );

    // Verify that our agenda shows the main header elements.
    expect(find.text('NOME:'), findsOneWidget);
    expect(find.text('TELEFONE:'), findsOneWidget);
    expect(find.text('EMAIL:'), findsOneWidget);
    expect(find.text('ENDEREÇO:'), findsOneWidget);
    expect(find.text('REMOVER:'), findsOneWidget);
  });
}
