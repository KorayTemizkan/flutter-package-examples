import 'dart:io'; // http ve WebSocket sunucusu oluşturmak için
import 'dart:convert'; // JSON encode/decode yapmak için (mesajları json ile gönderip alıcaz)

void main() async {
  final server = await HttpServer.bind(
    InternetAddress.anyIPv4,
    8080,
  ); // TCP port 8080 üzerinde HTTP sunucusu açıyoruz, tüm ip adreslerinden bağlantı kabul ediyoruz
  print('WebSocket sunucusu çalışıyor: ws://localhost:8080');

  final clients =
      <
        WebSocket
      >[]; // bu liste sunucuya bağlanan tüm WebSocket kullanıcılarını tutar.

  await for (HttpRequest req in server) {
    // sunucuya gelen tüm istekleri dinliyoruz
    if (WebSocketTransformer.isUpgradeRequest(req)) {
      // gelen istek websocket isteği ise
      WebSocket socket = await WebSocketTransformer.upgrade(
        req,
      ); // http isteğini websockete çeviriyoruz
      
      clients.add(socket); // kullanıcıyı bağlı kullanıcılar listesine ekliyoruz

      // her kullanıcıya benzersiz bir id veriyoruz
      final userId = DateTime.now().millisecondsSinceEpoch;
      print('Yeni kullanıcı bağlandı: $userId');

      socket.listen(
        (data) {
          print('Mesaj geldi $data');

          for (var client in clients) {
            // tüm bağlı kullanıcılara mesaj gönder (broadcast)
            if (client.readyState == WebSocket.open) {
              client.add(
                jsonEncode({
                  'user': userId.toString(),
                  'text': data,
                  'time': DateTime.now().toIso8601String(),
                }),
              );
            }
          }
        },

        onDone: () {
          print('Kullanici ayrildi: $userId');
          clients.remove(socket);
        },

        onError: (err) {
          print('Hata: $err');
          clients.remove(socket);
        },
      );
    } else {
      req.response
        ..statusCode = HttpStatus
            .forbidden // 403 forbidden
        ..write('WebSocket istemi bekleniyor')
        ..close();
    }
  }
}
