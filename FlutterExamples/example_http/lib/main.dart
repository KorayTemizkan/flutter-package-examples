import 'dart:io';

import 'package:example_http/album.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<Album> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/4'),
    // Add a User-Agent header to mimic a browser request.
    headers: {
      HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
    }, // Sebep, ağınızda bulunan bir proxy sunucusu veya güvenlik duvarının (firewall) bu başlığı zorunlu kılmasıdır.
  ); // Çözüm, jsonplaceholder'ın bir "api token" istemesi değildi. Çözüm, ağınızdaki proxy sunucusunu, isteğinizin "güvenli" olduğuna ikna etmekti. Authorization başlığını ekleyerek proxy'nin güvenlik filtresini aşmış oldunuz.

  if (response.statusCode == 200) {
    return Album.fromJson(json.decode(response.body) as Map<String, dynamic>);
  } else {
    // Hata durumunda status code'u yazdır.
    throw Exception(
      '1. Failed to load album. Status code: ${response.statusCode}, Status reason: ${response.reasonPhrase}',
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album>
  futureAlbum; // late değişkenin gecikmeli başlatılacağını belirtir(initstate içinde), // Future ise asenkron olacağını belirtir (benzer mantık)

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 20),
            FutureBuilder(
              // BUİLD METODUNA ÇALIŞ
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.title);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
