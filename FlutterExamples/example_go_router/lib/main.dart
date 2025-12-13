import 'package:example_go_router/about_page.dart';
import 'package:example_go_router/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final routerKey =
    GlobalKey<
      NavigatorState
    >(); // // Tüm uygulama geçişleri için tek bir navigator anahtarı oluşturuyoruz

class AppRoutes {
  AppRoutes._(); // Bu sınıfın örneği oluşturulmasın diye
  static const String homePage = '/';
  static const String aboutPage = '/about_page';
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GoRouter router = GoRouter(
    navigatorKey: routerKey,
    initialLocation: AppRoutes.homePage,
    routes: [
      GoRoute(
        path: AppRoutes.homePage,
        builder: (context, state) => const HomePage(),
      ),

      GoRoute(
        //path: '/about', yukarıdaki sınıfı yapmasak böyle yapacaktık
        path: AppRoutes.aboutPage,
        builder: (context, state) => const AboutPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
