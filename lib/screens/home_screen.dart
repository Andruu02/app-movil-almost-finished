import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/personaje_model.dart';
import '../services/personaje_service.dart';
import '../services/partida_service.dart';
import '../widgets/image_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String nombreUsuario = 'Usuario';
  int _puntosTotal = 0;
  bool _cargandoPuntos = true;

  List<PersonajeModel> _personajes = personajesLocales;
  int _personajeIndex = 0;
  PersonajeModel get _personajeActual => _personajes[_personajeIndex];

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
    _cargarPersonajes();
    _cargarPuntos();
  }

  Future<void> _cargarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nombreUsuario = prefs.getString('user_nombre') ?? 'Usuario';
    });
  }

  Future<void> _cargarPersonajes() async {
    final lista = await PersonajeService.obtenerPersonajes();
    if (mounted) setState(() => _personajes = lista);
  }

  Future<void> _cargarPuntos() async {
    final puntos = await PartidaService.obtenerPuntosTotales();
    if (mounted) {
      setState(() {
        _puntosTotal = puntos;
        _cargandoPuntos = false;
      });
    }
  }

  Future<void> _cambiarPersonaje() async {
    setState(() {
      _personajeIndex = (_personajeIndex + 1) % _personajes.length;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('personaje_id', _personajeActual.idPersonaje);
    await prefs.setString('personaje_nombre', _personajeActual.nombre);
    await prefs.setString('personaje_sprite_home', _personajeActual.spriteHome);
    await prefs.setString(
      'personaje_sprite_catcher',
      _personajeActual.spriteCatcher,
    );
    await prefs.setString(
      'personaje_sprite_runner1',
      _personajeActual.spriteRunner1,
    );
    await prefs.setString(
      'personaje_sprite_runner2',
      _personajeActual.spriteRunner2,
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                Image.asset('assets/images/logo.png', height: 100),
                const SizedBox(height: 10),
                Text(
                  'Hola, $nombreUsuario',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // Personaje + flecha
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/${_personajeActual.spriteHome}',
                      height: 420,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 80,
                      child: GestureDetector(
                        onTap: _cambiarPersonaje,
                        child: Image.asset(
                          'assets/images/red_arrow.png',
                          height: 80,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ImageButton(
                      imagePath: 'assets/images/icecream.png',
                      size: 110,
                      onTap: () async {
                        await Navigator.pushNamed(context, '/game1');
                        _cargarPuntos();
                      },
                    ),
                    ImageButton(
                      imagePath: 'assets/images/banana.png',
                      size: 110,
                      onTap: () async {
                        await Navigator.pushNamed(context, '/game2');
                        _cargarPuntos();
                      },
                    ),
                    ImageButton(
                      imagePath: 'assets/images/gift.png',
                      size: 110,
                      onTap: () => Navigator.pushNamed(context, '/promociones'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),

            // Puntos arriba derecha
            Positioned(
              top: 8,
              right: 56,
              child: Row(
                children: [
                  Image.asset('assets/images/coin.png', height: 36),
                  const SizedBox(width: 6),
                  _cargandoPuntos
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          '$_puntosTotal',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),

            // Logout
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: _logout,
                child: Image.asset('assets/images/logout.png', height: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
