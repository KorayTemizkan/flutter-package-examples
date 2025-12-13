/*
class Post {
  final int
  userId; // "Final" anahtar kelimesi, değerleri atandıktan sonra değiştirilemeyen değişkenleri bildirmek için kullanılır.
  final int id;
  final String title;
  final String body;

  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    print('1. kontrol');
    return switch (json) {
      // json bir map ise ve userId bir int , id bir int... bu şekilde devam. kontrol ediyor hepsi doğruysa nesnenin değişkenlerine json verilerini atıyor.
      {
        'UserId': int userId,
        'id': int id,
        'title': String title,
        'body': String body,
      } =>
        Post(userId: userId, id: id, title: title, body: body),
      _ => throw FormatException('KONTROL : $json'),
    };
  }
}
*/

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}
