// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example_sqlite/main.dart';

void main() {
  testWidgets('Displays dog information test', (WidgetTester tester) async {
    // Test için bir köpek nesnesi oluşturun.
    const testDog = Dog(id: 0, name: 'Test Dog', age: 5);

    // Uygulamamızı oluşturun ve bir çerçeve tetikleyin.
    // MyApp widget'ını test ortamı için bir MaterialApp ile sarmamız gerekiyor.
    await tester.pumpWidget(const MaterialApp(home: MyApp(dog: testDog)));

    // "Deneme" metninin bulunduğunu doğrulayın.
    expect(find.text('Deneme'), findsOneWidget);

    // Köpek bilgilerinin toString() formatında ekranda olduğunu doğrulayın.
    expect(find.text(testDog.toString()), findsOneWidget);
  });
}
