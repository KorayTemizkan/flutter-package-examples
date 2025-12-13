import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}

Future<File> writeCounter(int counter) async {
  final file = await _localFile;
  return file.writeAsString('$counter');
}

Future<int> readFile() async {
  final file = await _localFile;
  final contents = await file.readAsString();
  return int.parse(contents);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _counter = 0;
  String _path = '';

  @override
  void initState() {
    super.initState();
    
    /*
    Future (Gelecek): Dart'ta, sonucu gelecekte belli olacak bir işlemi başlattığınızda, size anında bir Future objesi verilir. Bu, "sana söz, bu işlem bitince bir sonuç döneceğim" diyen bir sözleşme gibidir. Sizin readFile() fonksiyonunuz, size hemen bir sayı vermez; size gelecekte bir sayı (int) vereceğinin sözünü veren bir Future<int> verir.
    .then() (Sonra): .then() metodu, bu "söz" tutulduğunda ne yapılacağını söylediğiniz yerdir. Kelime anlamı olarak "sonra" demektir.
    */
    
    readFile().then((value) {
      setState(() {
        _counter = value;
      });
    });

    _localPath.then((value) {
      setState(() {
        _path = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<File> incrementCounter() {
      setState(() {
        _counter++;
      });

      print('1. Kontrol');
      print(_counter);

      return writeCounter(_counter);
    }

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 20),
            Text('Sonuc : $_counter : $_path'),
            FloatingActionButton(
              onPressed: () => incrementCounter(),
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
