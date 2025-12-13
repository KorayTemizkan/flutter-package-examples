import 'package:flutter/material.dart';
import 'package:example_navigation_routing/todos.dart';

/*
Flutter'da StatefulWidget'lar iki ayrı sınıftan oluşur:

Widget Sınıfı (Senin kodunda Page1):

Bu sınıf, widget'ın kendisidir ve değişmez (immutable)'dır. Yani bir kere oluşturulduktan sonra içindeki özellikler (örneğin senin todoList'in) değişmez.
Görevi, widget'ın yapılandırmasını (konfigürasyonunu) tutmaktır. Page1'in görevi, kendisine verilen todoList'i saklamaktır.
State Sınıfı (Senin kodunda _Page1State):

Bu sınıf, widget'ın değişebilir (mutable) durumunu tutar ve yaşam döngüsünü yönetir. Ekranda gördüğün ve zamanla değişebilen her şey bu sınıf içinde yönetilir.
build metodu bu sınıfın içindedir. Yani arayüzü çizen kod buradadır.
*/

class Page1 extends StatefulWidget {
  final List<Todo> todoList;
  const Page1({super.key, required this.todoList});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 1')),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text('You are currently at page 1'),
          ),

          Text('Geri don'),
          FloatingActionButton(
            onPressed: () {
              Navigator.pop(context, 'Page 1\'den veri geldi!');
            },
            child: const Icon(Icons.arrow_back),
          ),

          /*
          Neden gerekli? ListView gibi kaydırılabilir listeler, ne kadar yer kaplayacaklarını bilmek isterler.
          Onu bir Column içine doğrudan koyarsan, Column dikeyde ne kadar yer vereceğini bilemez ve Flutter 
          "unbounded height" (sınırsız yükseklik) hatası verir. Expanded bu sorunu çözer ve "Sana kalan tüm dikey alanı veriyorum, onu kullan" der.
          */
          Expanded(
            child: ListView.builder(
              itemCount: widget.todoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.todoList[index].title),
                ); // todoList bir üst sınıfın özelliği olduğu için doğruca erişemiyoruz.
              },
            ),
          ),
        ],
      ),
    );
  }
}
