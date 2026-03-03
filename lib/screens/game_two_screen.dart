import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../games/runner/runner_game.dart';

class GameTwoScreen extends StatefulWidget {
  const GameTwoScreen({super.key});

  @override
  State<GameTwoScreen> createState() => _GameTwoScreenState();
}

class _GameTwoScreenState extends State<GameTwoScreen> {
  RunnerGame? _game;

  @override
  void initState() {
    super.initState();
    _initGame();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _initGame() async {
    final prefs = await SharedPreferences.getInstance();
    final idPersonaje = prefs.getInt('personaje_id') ?? 1;
    final spriteRunner1 =
        prefs.getString('personaje_sprite_runner1') ?? 'vianne_run1.png';
    final spriteRunner2 =
        prefs.getString('personaje_sprite_runner2') ?? 'vianne_run2.png';

    setState(() {
      _game = RunnerGame(
        idPersonaje: idPersonaje,
        spriteRunner1: spriteRunner1,
        spriteRunner2: spriteRunner2,
      );
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_game == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF87CEEB),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return GameWidget(
      game: _game!,
      overlayBuilderMap: {
        'score': (context, game) {
          final runner = game as RunnerGame;
          return Positioned(
            top: 12,
            right: 16,
            child: ValueListenableBuilder<int>(
              valueListenable: runner.scoreNotifier,
              builder: (_, score, __) => Text(
                '$score',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  shadows: [
                    Shadow(offset: Offset(2, 2), color: Colors.black54),
                  ],
                ),
              ),
            ),
          );
        },
        'backButton': (context, game) {
          return Positioned(
            top: 8,
            left: 8,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset('assets/images/house.png', height: 48),
            ),
          );
        },
        'gameOver': (context, game) {
          final runner = game as RunnerGame;
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFE53935),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset('assets/images/house.png', height: 48),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/emoji_cry.png', height: 120),
                        const SizedBox(width: 48),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'GAME OVER',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ValueListenableBuilder<int>(
                              valueListenable: runner.scoreNotifier,
                              builder: (_, score, __) => Text(
                                '¡Haz alcanzado $score puntos!',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            GestureDetector(
                              onTap: () => _game!.resetGame(),
                              child: Image.asset(
                                'assets/images/retry.png',
                                height: 70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      },
      initialActiveOverlays: const ['score', 'backButton'],
    );
  }
}
