import 'package:flutter/material.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 2')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text('You are currently at page 2'),
          ),

          FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.ac_unit),
          ),
        ],
      ),
    );
  }
}
