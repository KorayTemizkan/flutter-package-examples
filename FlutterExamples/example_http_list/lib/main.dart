import 'dart:io';
import 'package:example_http/album.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


Future<List<Album>> fetchAlbums() async {
  final url = 'https://jsonplaceholder.typicode.com/albums';
  final response = await http.get(
    Uri.parse(url),
    // Add a User-Agent header to mimic a browser request.
    headers: {
      HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
    }, // Sebep, ağınızda bulunan bir proxy sunucusu veya güvenlik duvarının (firewall) bu başlığı zorunlu kılmasıdır.
  ); // Çözüm, jsonplaceholder'ın bir "api token" istemesi değildi. Çözüm, ağınızdaki proxy sunucusunu, isteğinizin "güvenli" olduğuna ikna etmekti. Authorization başlığını ekleyerek proxy'nin güvenlik filtresini aşmış oldunuz.

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    List<Album> albumList = body
        .map((dynamic item) => Album.fromJson(item))
        .toList();
    return albumList;
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
  late Future<List<Album>>
  albumList; // late değişkenin gecikmeli başlatılacağını belirtir(initstate içinde), // Future ise asenkron olacağını belirtir (benzer mantık)

  @override
  void initState() {
    super.initState();
    albumList = fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              // FutureBuilder'ı en basit haliyle şöyle düşünebilirsiniz: Sonucunun ne zaman geleceği belli olmayan bir işlemi beklerken ekranda ne göstereceğinizi yöneten bir widget'tır.
              child: FutureBuilder<List<Album>>(
                future: albumList,

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,

                      itemBuilder: (context, index) {
                        final album = snapshot.data![index];

                        return ListTile(
                          title: Text(album.title),
                          subtitle: Text("${album.id}"),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Hata kodu: ${snapshot.error}');
                  } else {
                    return Text('Veri bulunamadi');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
