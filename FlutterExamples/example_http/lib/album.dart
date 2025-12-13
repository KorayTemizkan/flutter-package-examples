class Album {
  final int userId;
  final int id;
  final String title;

  const Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    print('Deneme');
    return switch (json) {
      // Switch desen eşleştirmem yapıyor, gelen userId değeri int türünde mi
      {'userId': int userId, 'id': int id, 'title': String title} => Album(
        userId: userId,
        id: id,
        title: title,
      ),
      _ => throw const FormatException('2. Failed to load Album'),
    };
  }
}
