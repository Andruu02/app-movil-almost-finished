class PersonajeModel {
  final int idPersonaje;
  final String nombre;
  final String? descripcion;
  final String spriteHome;
  final String spriteCatcher;
  final String spriteRunner1;
  final String spriteRunner2;

  const PersonajeModel({
    required this.idPersonaje,
    required this.nombre,
    this.descripcion,
    required this.spriteHome,
    required this.spriteCatcher,
    required this.spriteRunner1,
    required this.spriteRunner2,
  });

  factory PersonajeModel.fromJson(Map<String, dynamic> json) {
    final nombre = json['nombre'].toString().toLowerCase();
    return PersonajeModel(
      idPersonaje: int.parse(json['id_personaje'].toString()),
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      spriteHome: '${nombre}_home.png',
      spriteCatcher: '${nombre}_catch.png',
      spriteRunner1: '${nombre}_run1.png',
      spriteRunner2: '${nombre}_run2.png',
    );
  }
}

const List<PersonajeModel> personajesLocales = [
  PersonajeModel(
    idPersonaje: 1,
    nombre: 'Vianne',
    descripcion: 'Personaje principal',
    spriteHome: 'vianne_home.png',
    spriteCatcher: 'vianne_catcher.png',
    spriteRunner1: 'vianne_run1.png',
    spriteRunner2: 'vianne_run1.png',
  ),
  PersonajeModel(
    idPersonaje: 2,
    nombre: 'Andy',
    descripcion: 'Segundo personaje',
    spriteHome: 'andy_home.png',
    spriteCatcher: 'andy_catcher.png',
    spriteRunner1: 'andy_run1.png',
    spriteRunner2: 'andy_run1.png',
  ),
];
