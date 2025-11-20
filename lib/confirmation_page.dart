// Archivo: lib/confirmation_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Importa los modelos necesarios, asumiendo que están en tu proyecto
import 'package:xtremepark_flutter/pilot_model.dart';
import 'package:xtremepark_flutter/booking_page.dart'; // Para la clase Addon

const Color extremeGreen = Color(0xFF6B9C23);

// =============================================================================
// I. CLASE PRINCIPAL DE LA PÁGINA DE CONFIRMACIÓN
// =============================================================================

class ConfirmationPage extends StatelessWidget { // ✅ CLASE AHORA SIN 'const' EN EL WIDGET
  // Parámetros obligatorios que se reciben después del pago exitoso
  final String activityTitle;
  final double totalPrice;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String paymentMethodName;
  final List<Addon> selectedAddons;
  final Pilot? selectedPilot; // Piloto es opcional

  // Formateador de moneda (NO ES CONSTANTE)
  final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  // ✅ CONSTRUCTOR SIN 'const'
  ConfirmationPage({
    super.key,
    required this.activityTitle,
    required this.totalPrice,
    required this.selectedDate,
    required this.selectedTime,
    required this.paymentMethodName,
    required this.selectedAddons,
    this.selectedPilot,
  });

  // Widget auxiliar para las filas de detalle
  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: extremeGreen, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para el resumen de costos
  Widget _buildSummaryRow(String label, double price, {bool isTotal = false}) {
    final style = TextStyle(
      fontSize: isTotal ? 20 : 16,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      color: isTotal ? extremeGreen : Colors.black87,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(currencyFormatter.format(price), style: style),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Definimos el padding lateral para web/escritorio
    final isLargeScreen = MediaQuery.of(context).size.width > 800;
    final horizontalPadding = isLargeScreen ? 150.0 : 20.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmación de Reserva', style: TextStyle(color: Colors.white)),
        backgroundColor: extremeGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        // Deshabilitamos el botón de regreso para forzar el botón "Volver al Inicio"
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icono de Éxito
                const Icon(
                  Icons.check_circle_outline,
                  color: extremeGreen,
                  size: 100,
                ),
                const SizedBox(height: 20),

                // Título de Confirmación
                const Text(
                  '¡Reserva Confirmada Exitosamente!',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: extremeGreen),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Mensaje
                const Text(
                  'Tu aventura ha sido reservada. Recibirás un correo electrónico con tu comprobante y todos los detalles.',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // --- 1. TARJETA DE DETALLES ---
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Detalles de la Cita',
                            style: Theme.of(context).textTheme.headlineSmall
                        ),
                        const Divider(height: 30),

                        _buildDetailRow(
                          'Actividad',
                          activityTitle,
                          Icons.tour,
                        ),

                        _buildDetailRow(
                          'Fecha y Hora',
                          '${DateFormat('EEEE, d MMMM yyyy', 'es').format(selectedDate)} a las ${selectedTime.format(context)}',
                          Icons.calendar_today,
                        ),

                        if (selectedPilot != null)
                          _buildDetailRow(
                            'Piloto Seleccionado',
                            selectedPilot!.name,
                            Icons.person,
                          ),

                        _buildDetailRow(
                          'Método de Pago',
                          paymentMethodName,
                          Icons.payment,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // --- 2. RESUMEN DE PAGO ---
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Resumen Financiero',
                            style: Theme.of(context).textTheme.headlineSmall
                        ),
                        const Divider(height: 30),

                        // Costos
                        ...selectedAddons.map((addon) =>
                            _buildSummaryRow(addon.name, addon.price)
                        ).toList(),
                        if (selectedAddons.isNotEmpty) const Divider(),

                        _buildSummaryRow('Total Pagado', totalPrice, isTotal: true),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // --- Botón de Volver al Inicio ---
                SizedBox(
                  width: isLargeScreen ? 300 : double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navegar de vuelta a la primera ruta (típicamente home_page)
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: extremeGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('VOLVER AL INICIO', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}