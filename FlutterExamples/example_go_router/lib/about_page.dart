import 'package:example_go_router/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 15),
          Text('about_page.dart'),

          ElevatedButton(
            onPressed: () => context.go(AppRoutes.homePage),
            child: const Text('Geri dön'),
          ),
        ],
      ),
    );
  }
}
