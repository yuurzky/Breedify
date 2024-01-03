import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breedify/display/splash_screen.dart';
import 'package:breedify/display/select_menu.dart';
import 'package:breedify/display/identify_chat.dart';
import 'package:breedify/display/ask_chat.dart';

Future<void> main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
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
        });
  }
}