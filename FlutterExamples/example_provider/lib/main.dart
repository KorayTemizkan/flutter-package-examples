import 'package:example_provider/item_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:example_provider/card_model.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => CardModel(), child: MyApp()));
  // Provider'ın temel amacı, bir veriyi veya bir hizmeti, ona ihtiyaç duyan tüm widget'ların kolayca erişebileceği bir yere koymaktır.
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final cardModel = context.watch<CardModel>();

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 20),
            Text('Toplam fiyat : ${cardModel.totalPrice}'),

            FloatingActionButton(
              onPressed: () {
                cardModel.add(Item(name: 'Koray', price: 5));
              },
              child: const Icon(Icons.abc),
            ),
          ],
        ),
      ),
    );
  }
}
