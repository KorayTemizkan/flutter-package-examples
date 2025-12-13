import 'package:example_navigation_routing/page4.dart';
import 'package:flutter/material.dart';

import 'package:example_navigation_routing/todos.dart';
import 'package:example_navigation_routing/page1.dart';
import 'package:example_navigation_routing/page2.dart';
import 'package:example_navigation_routing/page3.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    // DefaultTabController, TabBar ve TabBarView kullanan Scaffold'u sarmalıdır.
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        

        
        // Scaffold'un 'drawer' özelliğine yan menüyü ekliyoruz.
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(child: Text('Menü Basligi')),

              ListTile(
                title: const Text('Dorduncu'),

                onTap: () {
                  // Önce menüyü kapatıyoruz (isteğe bağlı ama daha temiz bir geçiş sağlar)
                  // Navigator.pop(context);
                  // Sonra yeni sayfayı açıyoruz
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Page4()),
                  );
                },
              ),

              ListTile(
                title: const Text('Besinci'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                title: const Text('Altinci'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),


        // Bütün sayfa için tek bir AppBar.
        appBar: AppBar(
          title: const Text('Ana Sayfa'),
          // AppBar'ın alt kısmına sekmeleri yerleştiriyoruz.
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Birinci'),
              Tab(text: 'İkinci'),
              Tab(text: 'Üçüncü'),
            ],
          ),
        ),
        body: const TabBarView(children: [FirstTab(), SecondTab(), ThirdTab()]),

      ),
    );
  }
}

class FirstTab extends StatefulWidget {
  const FirstTab({super.key});

  @override
  State<FirstTab> createState() => _FirstTabState();
}

class _FirstTabState extends State<FirstTab> {
  final List<Todo> todos = List.generate(
    5,
    (i) => Todo(title: 'Todo $i', description: 'Description $i'),
  );

  Future<void> _navigator(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Page1(todoList: todos)),
    );

    if (!context.mounted) {
      return;
    }
    /*
    context.mounted özelliği, bir State nesnesinin hala widget ağacında (yani ekranda) olup olmadığını bildiren bir boolean (true/false) değeridir.
    yani sen yeni sayfadayken bu sayfa çökerse fonksiyonda çıkar
    */

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            _navigator(context);
          },
          child: const Text('Todo hesaplama ekrani olan Page 1\'ye Git'),
        ),

        Expanded(
          // ListView expanded ile kaplamazsan sınırları aşıyor
          child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(todos[index].title));
            },
          ),
        ),
      ],
    );
  }
}

class SecondTab extends StatelessWidget {
  const SecondTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => const Page2()),
          );
        },
        child: const Text('Page 2\'ye Git'),
      ),
    );
  }
}

class ThirdTab extends StatelessWidget {
  const ThirdTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => const Page3()),
          );
        },
        child: const Text('Page 3\'e Git'),
      ),
    );
  }
}
