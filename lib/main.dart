import 'package:flutter/material.dart';
import 'package:breedify/display/splashScreen.dart';
import 'package:breedify/display/selectMenu.dart';
import 'package:breedify/display/identifyChat.dart';
import 'package:breedify/display/askChat.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static PageRouteBuilder slideRightTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Breedify',
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (_) => const SplashScreenPage(),
          '/select': (_) => const SelectMenu(),
          '/identify': (_) => const IdentifyChat(),
          '/ask': (_) => const AskChat(),
          // '/menu': (_) => const MainMenu(),
        });
  }
}