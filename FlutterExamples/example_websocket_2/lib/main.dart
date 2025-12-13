import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse(
      'ws://10.0.2.2:8080',
    ), // ws:// (güvenli olmayan) bağlantı kullanıyoruz çünkü sunucumuz SSL desteklemiyor
  ); // stream ile gelen mesajlar, sink ile giden mesajlar kontrol edilir.

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  } //sayfa değiştirme, sayfa yeniden yüklemesinde filan çalışır. kaynakları serbest bırakır, kısmi destructor gibi düşünebilirsin

  @override
  Widget build(BuildContext context) {
    // build her state değişiminde yeniden çalışır
    return MaterialApp(
      home: Scaffold(
        // sayfa iskeleti
        appBar: AppBar(title: Text('WebSocketDenemesi')),

        body: Column(
          // widgetler dikey çiziliyor
          children: [
            SizedBox(height: 15),

            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),

            Expanded(
              // mesaj alanının boşlukta genişlemesini sağlar
              child: StreamBuilder(
                stream: _channel.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return SizedBox();
                  final message = snapshot.data;

                  final data = jsonDecode(message);
                  return Text('${data['user']}: ${data['text']}');
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _sendMessage,
          tooltip: 'Send Message',
          child: const Icon(Icons.send),
        ),
      ),
    );
  }
}
