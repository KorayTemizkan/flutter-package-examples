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
      'wss://ws.postman-echo.com/raw',
    ), //WSS, SSL'li WebSocket protokolü, bu bağlantı app boyunca tek sefer kurulur
  ); // stream ile gelen mesajlar, sink ile giden mesajlar kontrol edilir.

  void _sendMessage() {
    print('kontrol');
    if (_controller.text.isNotEmpty) {
      print('kontrol');

      _channel.sink.add(_controller.text);
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
                  return Text(snapshot.hasData ? '${snapshot.data}' : '');
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
