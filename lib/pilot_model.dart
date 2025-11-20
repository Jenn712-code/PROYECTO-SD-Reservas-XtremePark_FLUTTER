// Archivo: lib/pilot_model.dart

class Pilot {
  final String name;
  final int age;
  final String certification;
  final String equipmentBrand;
  final String bio;
  final String imageUrl; // Esta es la ruta del asset local

  const Pilot({
    required this.name,
    required this.age,
    required this.certification,
    required this.equipmentBrand,
    required this.bio,
    required this.imageUrl,
  });
}

// Datos de ejemplo para los pilotos
const List<Pilot> availablePilots = [
  Pilot(
    name: 'Carlos "El Cóndor" Rojas',
    age: 35,
    certification: 'APPI Advanced, P3 USHPA',
    equipmentBrand: 'Ozone, Advance',
    bio: 'Con más de 10 años de experiencia, Carlos es un experto en vuelos térmicos y de larga distancia. Habla inglés y español.',
    // ✅ RUTA DEL ASSET LOCAL
    imageUrl: 'assets/images/carlosPiloto.jpg',
  ),
  Pilot(
    name: 'Sofía "Viento" Gómez',
    age: 28,
    certification: 'APPI Pro-Tandem, P2 USHPA',
    equipmentBrand: 'Niviuk, Dudek',
    bio: 'Especialista en vuelos suaves y panorámicos al atardecer. Es conocida por su paciencia y excelente trato con principiantes.',
    // ✅ RUTA DEL ASSET LOCAL
    imageUrl: 'assets/images/sofiaPiloto.jpg',
  ),
  // Asegúrate de que todas las imágenes que usas aquí estén declaradas en pubspec.yaml
];