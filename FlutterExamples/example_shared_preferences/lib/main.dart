/* Ne İşe Yarar?
Uygulama kapatılıp açılsa bile kaybolmamasını istediğiniz küçük ve basit verileri saklamak için idealdir.

Örnek Kullanım Alanları:

Kullanıcının tema tercihi (koyu mod / açık mod).
Uygulamanın dil seçimi (Türkçe / İngilizce).
Bir karşılama ekranının tekrar gösterilip gösterilmeyeceğini tutan bir bayrak (true/false).
Kullanıcının en son ulaştığı seviye veya skor gibi basit bir sayı.
Oturumun açık kalması için gereken basit bir "token" bilgisi.

Desteklediği Veri Tipleri
Sadece basit (primitive) veri tiplerini saklayabilirsiniz:

int (tam sayılar)
double (ondalıklı sayılar)
bool (true/false)
String (metin)
List<String> (metin listeleri)
*/


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _counter = 0;

  Future<void> _readData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
    });
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 20),
            Text('Deneme'),

            Text('Sayac degeri : ${_counter}'),

            FloatingActionButton(
              onPressed: () => _loadData(),
              child: const Icon(Icons.abc),
            ),
          ],
        ),
      ),
    );
  }
}
