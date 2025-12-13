import 'package:example_go_router/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 15),
          Text('home_page.dart'),

          ElevatedButton(onPressed: () => context.go(AppRoutes.aboutPage),
          child: const Text('Detay sayfasina git!'),
          ),
        ],
      ),
    );
  }
}