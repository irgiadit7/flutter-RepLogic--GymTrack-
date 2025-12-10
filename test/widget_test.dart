import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:rep_logic/main.dart';

void main() {
  testWidgets('App loads test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: RepLogicApp()));

    expect(find.text('RepLogic'), findsOneWidget); 
  });
}