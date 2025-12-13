// D:\flutter\projects\example_sqlite>flutter pub add sqflite path
// Yukarıda gördüğün kodu cmd ile çalıştırırsan gerekli paketler projene eklenir.

import 'package:flutter/material.dart'; // Flutter'ın temel kütüphanesi
import 'package:path/path.dart'; // Dosya ve dizin yollarını yönetmek için, dosya yolunu güvenli ve platforma uygun şekilde birleştirmek için kullanılır.
import 'package:sqflite/sqflite.dart'; // SQLite veritabanı işlemleri için
import 'dart:async'; // Asenkron programlama için
// Bu kütüphaneler ile SQLite veritabanı işlemlerini gerçekleştireceğiz.

class Dog {
  final int id;
  final String name;
  final int age;

  const Dog({required this.id, required this.name, required this.age});

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }
  // Bir nesneyi sözlük haline getirdik, böylece nesnelerimiz veritabına eklenebilir formata döndü.

  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
  // İleride yazdırmak istediğimizde kolay olsun diye toString metodunu yazdık.
}

// Dog sınıfı, veritabanındaki köpek verilerini temsil eder.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(
      await getDatabasesPath(),
      'doggie_database.db',
    ), // Veritabanımı nereye kaydedeceğimi belirtiyorum. Windows \, Linux / kullanır. Bunu engellemek için path paketini kullanıyorum.

    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      );
    }, //Veritabanı yaratma komutu

    version:
        1, // Veritabanı sürümü. Sürüm değiştiğinde onUpgrade fonksiyonu tetiklenir.
  );

  Future<void> insertDog(Dog dog) async {
    final db = await database;

    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } // Ekleme fonksiyonu yazılıyor, insert tablo adı ve verileri alıyor.

  var dog1 = Dog(id: 0, name: 'kara', age: 1);
  await insertDog(dog1);

  Future<List<Dog>> dogs() async {
    final db = await database;

    final List<Map<String, Object?>> dogMaps = await db.query('dogs');

    return [
      for (final {'id': id as int, 'name': name as String, 'age': age as int}
          in dogMaps)
        Dog(id: id, name: name, age: age),
    ];
  }

  print(await dogs());

  Future<void> updateDog(Dog dog) async {
    final db = await database;

    await db.update('dogs', dog.toMap(), where: 'id = ?', whereArgs: [dog.id]);
  }

  dog1 = Dog(id: dog1.id, name: dog1.name, age: dog1.age + 7);
  //await updateDog(dog1);

  Future<void> deleteDog(int id) async {
    final db = await database;

    await db.delete('dogs', where: 'id = ?', whereArgs: [id]);
  }
  //await deleteDog(dog1.id);

  runApp(MaterialApp(home: MyApp(dog: dog1)));
}

class MyApp extends StatelessWidget {
  final Dog dog;

  const MyApp({required this.dog, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text('Deneme'), Text(dog.toString())],
        ),
      ),
    );
  }
}


// MyApp sınıfı, uygulamanın kök widget'ını temsil eder.
// StatelessWidget'tan türetilmiştir, yani durumu (state) yoktur.
// build() metodu, widget'ın nasıl görüneceğini tanımlar.
// Şu anda sadece bir Placeholder widget'ı döndürüyor, bu da boş bir alan gösterir.


/*

Map<String, String> telefonRehberi = {
  'Ali': '555-1234',
  'Ayşe': '555-5678',
};
'Ali' → anahtar (key)

'555-1234' → değer (value)

Telefon numarasını almak istersek:

dart
Kodu kopyala
print(telefonRehberi['Ali']); // 555-1234
Yani Map = küçük bir etiketli kutular koleksiyonu gibi.

*/