import 'dart:convert';
import 'dart:io';

import 'package:example_dio/post.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

Dio createDio() {
  return Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      // connectTimeout: Duration(milliseconds: 5000),
      // receiveTimeout: Duration(milliseconds: 3000),
      headers: {HttpHeaders.authorizationHeader: 'Basic your_api_token_here'},
    ),
  );
}

late Future<List<Post>> posts;
Future<List<Post>> fetchPosts() async {
  Dio dio = createDio();
  Response response = await dio.get('/posts');
  //posts = (response.data as List).map((e) => Post.fromJson(e)).toList();

  return compute(
    parsePosts,
    jsonEncode(response.data),
  ); // HTTP'nin aksine burada önce encode etmen gerekli
  // HTTP'de response.body String verir, dio'da ise response.data String, Map, List, List<int> vs
}

List<Post> parsePosts(String responseBody) {
  final parsed = (jsonDecode(responseBody) as List<Object?>)
      .cast<Map<String, Object?>>();

  return parsed.map<Post>(Post.fromJson).toList();
}

Future<void> customRequest() async {
  Dio dio = createDio();
  Response response = await dio.get('/posts');
  print(response.data[0]);
  print(response.data[1]);
  print(response.data[20]);
}

/* En saf post isteği
  Future<void> getPosts() async {
    Dio dio = Dio();
    Response response = await dio.get(
      'https://jsonplaceholder.typicode.com/posts',
    );
    return print(response.data);
  }
  */

Future<void> getPosts() async {
  Dio dio = Dio();
  Response response = await dio.get(
    'https://jsonplaceholder.typicode.com/posts',
    options: Options(
      headers: {
        HttpHeaders.authorizationHeader:
            'Basic your_api_token_here', // bu olmazsa error 403 alırsın
      },
    ),
  );
  return print(response.data);
}

Future<void> createPost() async {
  Dio dio = Dio();
  Response response = await dio.post(
    'https://jsonplaceholder.typicode.com/posts',
    data: {
      'userid': 11,
      'id': 1,
      'title': 'Flutter Dio',
      'body': 'Dio paketi ile POST istegi denemesi',
    },
  );
  return print(response.data); // debug konsoluna json formatında yazdırıyor.
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    posts = fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 20),

            Text('Deneme'),

            FloatingActionButton(
              onPressed: () async => await getPosts(),
              child: Icon(Icons.access_alarm),
            ),

            FloatingActionButton(
              onPressed: () async => await createPost(),
              child: Icon(Icons.abc_outlined),
            ),

            FloatingActionButton(
              onPressed: () async => await customRequest(),
              child: Icon(Icons.accessible_forward_outlined),
            ),
            
            Divider(thickness: 1),
  
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: posts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final postsList = snapshot.data![index];

                        return ListTile(
                          title: Text(postsList.title),
                          subtitle: Text(postsList.body),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('ERROR : ${snapshot.error}'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
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
