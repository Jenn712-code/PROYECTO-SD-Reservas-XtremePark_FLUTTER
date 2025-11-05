import 'package:flutter/material.dart';

// Definición de colores principales
const Color extremeGreen = Color(0xFF6B9C23);
const Color darkGreenButton = Color(0xFF007A2B);
const double webPadding = 100.0; // Espaciado horizontal para diseño web

// =============================================================================
// I. MODELO DE DATOS Y DATOS DE MUESTRA
// =============================================================================

// Modelo de datos para una sola actividad
class Activity {
  final String title;
  final String description;
  final String duration;
  final String price;
  final String imagePath;
  final List<String> features;

  const Activity({
    required this.title,
    required this.description,
    required this.duration,
    required this.price,
    required this.imagePath,
    required this.features,
  });
}

// Lista de actividades de muestra (RUTAS CORREGIDAS)
const List<Activity> kActivities = [
  Activity(
    title: 'PARAPENTE',
    description: 'La experiencia cumbre de Xtreme Park. Planea sobre paisajes únicos y disfruta de la libertad del cielo. ¡Tú eliges con quién volar!',
    duration: '15-30 minutos',
    price: 'USD 50.00',
    imagePath: 'assets/images/parapente.jpg', // RUTA CORREGIDA: Asume assets/images/parapente.jpg
    features: [
      'Selecciona a tu Piloto Certificado',
      'Fotografía y video de alta calidad',
      'Vuelos personalizados a tu gusto',
    ],
  ),
  Activity(
    title: 'CANOPY',
    description: 'Siente la velocidad de un pájaro en nuestros circuitos de canopy. Ideal para compartir con amigos o familia.',
    duration: 'Recorrido de 90 minutos',
    price: 'USD 35.00',
    imagePath: 'assets/images/canopy.jpg', // RUTA CORREGIDA: Asume assets/images/canopy.jpg
    features: [
      'Vistas Panorámicas de la Montaña',
      'Equipos certificados',
      'Recorrido de 150 metros',
    ],
  ),
  Activity(
    title: 'CUATRIMOTOS',
    description: 'Conquista senderos y terrenos agrestes a toda velocidad. Rutas diseñadas para todos los niveles.',
    duration: '60 minutos',
    price: 'USD 70.00',
    imagePath: 'assets/images/cuatrimotos.jpg', // RUTA CORREGIDA: Asume assets/images/cuatrimotos.jpg
    features: [
      'Rutas de 30 y 60 Minutos con profesionales',
      'Recorridos por Paisajes Naturales',
      'Instrucción de buen manejo',
    ],
  ),
];

// =============================================================================
// II. PÁGINA PRINCIPAL
// =============================================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _HeaderSection(),
            _ActivitiesSection(),
            _TestimonialsSection(),
            _StatisticsSection(),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// III. WIDGETS DE SECCIÓN
// =============================================================================

// ---------------------- 1. WIDGET DEL ENCABEZADO Y BANNER ----------------------
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: extremeGreen,
      child: const Column(
        children: [
          _TopNavBar(),

          // Banner Principal (Texto grande y logo)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: webPadding, vertical: 50),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ELIGE TU AVENTURA.\nELIGE TU PILOTO.',
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.1),
                      ),
                      SizedBox(height: 15),
                      Text(
                        '¡El parque de atracciones extremas más completo! Vive la adrenalina del parapente, cuatrimotos, canopy, y más.',
                        style: TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                      SizedBox(height: 30),
                      // Fila de botones
                      Row(
                        children: [
                          _ActionButon(text: 'Descubre el parque', isFilled: true),
                          SizedBox(width: 20),
                          _ActionButon(text: 'Experiencias', isFilled: false),
                        ],
                      ),
                    ],
                  ),
                ),
                // LOGO GRANDE (RUTA CORREGIDA)
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/logo_xtremePark.png'), // <-- RUTA CORREGIDA
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------- WIDGETS AUXILIARES DEL ENCABEZADO ----------------------

class _ActionButon extends StatelessWidget {
  final String text;
  final bool isFilled;
  const _ActionButon({required this.text, required this.isFilled});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: isFilled ? darkGreenButton : Colors.transparent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: isFilled ? BorderSide.none : const BorderSide(color: Colors.white, width: 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        elevation: isFilled ? 5 : 0,
      ),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}

class _TopNavBar extends StatelessWidget {
  const _TopNavBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: webPadding, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LOGO PEQUEÑO (RUTA CORREGIDA)
          const Image(
            image: AssetImage('assets/logo_xtremePark.png'), // <-- RUTA CORREGIDA
            height: 35,
            fit: BoxFit.contain,
          ),

          // Botones y enlaces (derecha)
          const Row(
            children: [
              Text('Portal Pilotos', style: TextStyle(color: Colors.white)),
              SizedBox(width: 20),
              Text('Contáctanos', style: TextStyle(color: Colors.white)),
              SizedBox(width: 40),

              _StyledButton(text: 'Crear cuenta', backgroundColor: Colors.white, textColor: Colors.black),
              SizedBox(width: 10),
              _StyledButton(text: 'Iniciar sesión', backgroundColor: Colors.black, textColor: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}

class _StyledButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const _StyledButton({required this.text, required this.backgroundColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
    );
  }
}

// ---------------------- 2. WIDGET DE ACTIVIDADES ----------------------
class _ActivitiesSection extends StatelessWidget {
  const _ActivitiesSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: webPadding),
      child: Column(
        children: [
          const Text(
            'NUESTRAS ACTIVIDADES',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          // Flechas de navegación (Placeholder)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios)),
            ],
          ),
          const SizedBox(height: 10),

          // Las 3 tarjetas de actividad
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: kActivities.map((activity) {
              return Expanded(
                child: _ActivityCard(activity: activity), // Pasamos el objeto Activity
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Tarjeta de Actividad Detallada
class _ActivityCard extends StatelessWidget {
  final Activity activity;
  const _ActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Imagen de la actividad
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image(
              image: AssetImage(activity.imagePath),
              fit: BoxFit.cover,
              height: 180,
              width: double.infinity,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Título (PARAPENTE)
                Text(
                  activity.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Divider(height: 15),

                // 3. Descripción y Duración
                Text(
                  activity.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 16, color: extremeGreen),
                    const SizedBox(width: 5),
                    Text(activity.duration, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                  ],
                ),

                const SizedBox(height: 15),

                // 4. Lista de Características (Features)
                ...activity.features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: extremeGreen),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(feature, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                      ),
                    ],
                  ),
                )).toList(),

                const SizedBox(height: 20),

                // 5. Botón de Reserva con Precio
                ElevatedButton(
                  onPressed: () {
                    // TODO: Lógica para ir a la página de detalles de la actividad y reserva
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: extremeGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Text('Reserva (${activity.price})'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------- 3. WIDGET DE TESTIMONIOS ----------------------
class _TestimonialsSection extends StatelessWidget {
  const _TestimonialsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: webPadding),
      child: Column(
        children: [
          const Text(
            'LO QUE DICEN NUESTROS AVENTUREROS',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Expanded(child: _TestimonialCard(name: 'Javier Solís')),
              SizedBox(width: 30),
              Expanded(child: _TestimonialCard(name: 'Sofía García')),
            ],
          ),
        ],
      ),
    );
  }
}

// Tarjeta de Testimonio
class _TestimonialCard extends StatelessWidget {
  final String name;
  const _TestimonialCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person_pin, color: extremeGreen),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
            const Text('Piloto de Parapente', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const Divider(),
            const Text(
                '“La mejor decisión fue elegir a mi piloto! Fue una experiencia segura y súper personalizada. Se nota la profesionalidad y la pasión de todo el equipo de Xtreme Park.”',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54)
            ),
            const SizedBox(height: 10),
            const Text('*****', style: TextStyle(color: Colors.amber)),
          ],
        ),
      ),
    );
  }
}


// ---------------------- 4. WIDGET DE ESTADÍSTICAS (Footer Negro) ----------------------
class _StatisticsSection extends StatelessWidget {
  const _StatisticsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: webPadding),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(value: '1K+', label: 'Aventureros Felices'),
          _StatItem(value: '5+', label: 'Actividades Extremas'),
          _StatItem(value: '100%', label: 'Seguridad Garantizada'),
          _StatItem(value: '24/7', label: 'Atención'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: extremeGreen, fontSize: 36, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
      ],
    );
  }
}