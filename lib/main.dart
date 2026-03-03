import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/game_one_screen.dart';
import 'screens/game_two_screen.dart';
import 'screens/promociones_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const HappyJumpingApp());
}

class HappyJumpingApp extends StatelessWidget {
  const HappyJumpingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Happy & Jumping',
      initialRoute: '/',
      routes: {
        '/':            (context) => const LoginScreen(),
        '/home':        (context) => const HomeScreen(),
        '/game1':       (context) => const GameOneScreen(),
        '/game2':       (context) => const GameTwoScreen(),
        '/promociones': (context) => const PromocionesScreen(),
      },
    );
  }
}
