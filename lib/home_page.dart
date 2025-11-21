import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/l10n/app_localizations.dart';
import 'language_provider.dart';
import 'package:xtremepark_flutter/booking_page.dart';

// Definición de colores principales
const Color extremeGreen = Color(0xFF6B9C23);
const Color darkGreenButton = Color(0xFF007A2B);
const double webPadding = 100.0; // Espaciado horizontal para diseño web

// =============================================================================
// I. MODELO DE DATOS Y DATOS DE MUESTRA (No se traducen aquí, solo se usan variables)
// NOTA: Los campos 'description', 'duration', 'price' deberían venir de una API
// o ser traducidos, pero para simplificar, usamos valores fijos.
// =============================================================================

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

// Lista de actividades de muestra (Las rutas están corregidas)
const List<Activity> kActivities = [
  Activity(
    title: 'PARAPENTE',
    description: 'La experiencia cumbre de Xtreme Park. Planea sobre paisajes únicos y disfruta de la libertad del cielo. ¡Tú eliges con quién volar!',
    duration: '15-30 minutos',
    price: 'USD 50.00',
    imagePath: 'assets/images/parapente.jpg',
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
    imagePath: 'assets/images/canopy.jpg',
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
    imagePath: 'assets/images/cuatrimotos.jpg',
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
    // 2. Obtener la instancia de AppLocalizations aquí
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _HeaderSection(l10n: l10n),
            _ActivitiesSection(l10n: l10n),
            _TestimonialsSection(l10n: l10n),
            _StatisticsSection(l10n: l10n),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// III. WIDGETS DE SECCIÓN (Pasamos la instancia l10n)
// =============================================================================

// ---------------------- 1. WIDGET DEL ENCABEZADO Y BANNER ----------------------
class _HeaderSection extends StatelessWidget {
  final AppLocalizations l10n;
  const _HeaderSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: extremeGreen,
      child: Column( // Quitar 'const' para usar l10n
        children: [
          _TopNavBar(l10n: l10n),

          // Banner Principal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: webPadding, vertical: 50),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITULO TRADUCIDO
                      Text(
                        l10n.headerTitle,
                        style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.1),
                      ),
                      const SizedBox(height: 15),
                      // SUBTITULO TRADUCIDO
                      Text(
                        l10n.headerSubtitle,
                        style: const TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                      const SizedBox(height: 30),
                      // Fila de botones TRADUCIDOS
                      Row(
                        children: [
                          _ActionButon(text: l10n.discoverParkButton, isFilled: true),
                          const SizedBox(width: 20),
                          _ActionButon(text: l10n.experiencesButton, isFilled: false),
                        ],
                      ),
                    ],
                  ),
                ),
                // LOGO GRANDE
                const Expanded(
                  flex: 2,
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/images/logo_xtremePark.png'),
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
  final AppLocalizations l10n;
  const _TopNavBar({required this.l10n});

  @override
  Widget build(BuildContext context) {
    // Escuchamos el LanguageProvider para el selector de país
    final langProvider = Provider.of<LanguageProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: webPadding, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LOGO PEQUEÑO
          const Image(
            image: AssetImage('assets/images/logo_xtremePark.png'),
            height: 35,
            fit: BoxFit.contain,
          ),

          // Botones y enlaces TRADUCIDOS
          Row( // Quitar 'const' para usar l10n
            children: [
              _CountrySelector(langProvider: langProvider),
              const SizedBox(width: 20),
              Text(l10n.portalPilotsLink, style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 20),
              Text(l10n.contactUsLink, style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 40),

              _StyledButton(text: l10n.createAccountButton, backgroundColor: Colors.white, textColor: Colors.black),
              const SizedBox(width: 10),
              _StyledButton(text: l10n.loginButton, backgroundColor: Colors.black, textColor: Colors.white),
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

class _CountrySelector extends StatelessWidget {
  final LanguageProvider langProvider;

  const _CountrySelector({required this.langProvider});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Country>(
      value: langProvider.currentCountry,
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
      underline: Container(),

      onChanged: (Country? newValue) {
        if (newValue != null) {
          langProvider.setCountry(newValue);
        }
      },

      items: availableCountries.map<DropdownMenuItem<Country>>((Country country) {
        return DropdownMenuItem<Country>(
          value: country,
          child: Row(
            children: [
              Text(country.flagEmoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                  country.name,
                  style: const TextStyle(color: Colors.black, fontSize: 14)
              ),
            ],
          ),
        );
      }).toList(),

      dropdownColor: extremeGreen,
    );
  }
}


// ---------------------- 2. WIDGET DE ACTIVIDADES ----------------------
class _ActivitiesSection extends StatelessWidget {
  final AppLocalizations l10n;
  const _ActivitiesSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: webPadding),
      child: Column(
        children: [
          // TITULO TRADUCIDO
          Text(
            l10n.activitiesTitle,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                child: _ActivityCard(activity: activity, l10n: l10n), // Pasamos l10n
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
  final AppLocalizations l10n;
  const _ActivityCard({required this.activity, required this.l10n});

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

                // 3. Descripción y Duración (Usan datos fijos, no se traducen)
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

                // 4. Lista de Características (Usan datos fijos, no se traducen)
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

                // 5. Botón de Reserva TRADUCIDO
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(
                          activityTitle: activity.title,
                          // ✅ CORRECCIÓN: Parsear el precio para pasarlo como double
                          basePrice: double.parse(activity.price.replaceAll('USD ', '')),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: extremeGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Text('${l10n.reserveButton} (${activity.price})'),
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
  final AppLocalizations l10n;
  const _TestimonialsSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: webPadding),
      child: Column(
        children: [
          // TITULO TRADUCIDO
          Text(
            l10n.testimonialsTitle,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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

// Tarjeta de Testimonio (El contenido interno no se traduce aquí, solo el marco)
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
  final AppLocalizations l10n;
  const _StatisticsSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: webPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(value: '1K+', label: l10n.happyAdventurersStat),
          _StatItem(value: '5+', label: l10n.extremeActivitiesStat),
          _StatItem(value: '100%', label: l10n.securityStat),
          _StatItem(value: '24/7', label: l10n.attentionStat),
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