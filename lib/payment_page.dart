// Archivo: lib/payment_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xtremepark_flutter/pilot_model.dart';
import 'package:xtremepark_flutter/payment_model.dart'; // <--- Importación del modelo de pago
import 'package:xtremepark_flutter/booking_page.dart'; // Importación de Addon

// Definición de colores principales (repetida por seguridad)
const Color extremeGreen = Color(0xFF6B9C23);
const double webPadding = 100.0;

class PaymentPage extends StatefulWidget {
  // Datos de la reserva recibidos desde BookingPage
  final String activityTitle;
  final double basePrice;
  final double totalPrice;
  final Pilot? selectedPilot;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final List<Addon> selectedAddons;

  const PaymentPage({
    super.key,
    required this.activityTitle,
    required this.basePrice,
    required this.totalPrice,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedAddons,
    this.selectedPilot, // Piloto es opcional
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod? _selectedPaymentMethod;
  final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  // Widget para mostrar un detalle de la reserva
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false, Color? color}) {
    final style = TextStyle(
      fontSize: isTotal ? 20 : 16,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      color: color ?? (isTotal ? extremeGreen : Colors.black87),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pasarela de Pago', style: TextStyle(color: Colors.white)),
        backgroundColor: extremeGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: webPadding, vertical: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- COLUMNA 1: RESUMEN DE LA RESERVA (70% del ancho) ---
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revisa y Confirma tu Reserva',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: extremeGreen),
                    ),
                    const SizedBox(height: 30),

                    // --- 1. DETALLES DE LA RESERVA ---
                    _buildDetailsCard(context),
                    const SizedBox(height: 40),

                    // --- 2. SELECCIÓN DEL MÉTODO DE PAGO ---
                    Text('2. Elige tu Método de Pago', style: Theme.of(context).textTheme.headlineSmall),
                    const Divider(color: extremeGreen),

                    ...availableMethods.map((method) =>
                        _PaymentMethodTile(
                          method: method,
                          isSelected: _selectedPaymentMethod == method,
                          onSelect: (m) {
                            setState(() {
                              _selectedPaymentMethod = m;
                            });
                          },
                        )
                    ).toList(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),

              const SizedBox(width: 40),

              // --- COLUMNA 2: RESUMEN DEL PAGO (30% del ancho) ---
              Expanded(
                flex: 3,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Resumen de Pago', style: Theme.of(context).textTheme.headlineSmall),
                        const Divider(),

                        _buildSummaryRow('Costo Base:', currencyFormatter.format(widget.basePrice)),

                        // Detalles de Addons
                        if (widget.selectedAddons.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text('Cargos Adicionales:', style: Theme.of(context).textTheme.titleMedium),
                          ...widget.selectedAddons.map((addon) =>
                              _buildSummaryRow('  ${addon.name}:', currencyFormatter.format(addon.price), color: Colors.blueGrey)
                          ).toList(),
                        ],

                        const Divider(thickness: 2),

                        _buildSummaryRow('Total a Pagar:', currencyFormatter.format(widget.totalPrice), isTotal: true),

                        const SizedBox(height: 30),

                        // --- Botón de Confirmación Final ---
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _selectedPaymentMethod != null ? () {
                              // Lógica de simulación de pago exitoso
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('¡Pago de \$${widget.totalPrice.toStringAsFixed(2)} y Reserva Confirmada! Método: ${_selectedPaymentMethod!.name}')),
                              );
                              // Navegar a una página de confirmación o de vuelta al inicio
                              Navigator.popUntil(context, (route) => route.isFirst);
                            } : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: extremeGreen,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('PAGAR Y CONFIRMAR', style: TextStyle(fontSize: 18)),
                          ),
                        ),

                        // Mensaje de advertencia
                        if (_selectedPaymentMethod == null)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Selecciona un método de pago para continuar.',
                              style: TextStyle(color: Colors.red, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para el resumen de detalles de la reserva
  Card _buildDetailsCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalles de tu Reserva', style: Theme.of(context).textTheme.headlineSmall),
            const Divider(),

            _DetailRow(
                icon: Icons.tour,
                label: 'Actividad:',
                value: widget.activityTitle
            ),
            _DetailRow(
                icon: Icons.calendar_today,
                label: 'Fecha:',
                value: DateFormat('EEEE, d MMMM yyyy', 'es').format(widget.selectedDate)
            ),
            _DetailRow(
                icon: Icons.access_time,
                label: 'Hora:',
                value: widget.selectedTime.format(context)
            ),
            if (widget.selectedPilot != null)
              _DetailRow(
                  icon: Icons.person,
                  label: 'Piloto Selecto:',
                  value: widget.selectedPilot!.name
              ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET AUXILIAR PARA MÉTODO DE PAGO ---
class _PaymentMethodTile extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final Function(PaymentMethod) onSelect;

  const _PaymentMethodTile({
    required this.method,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: isSelected ? const BorderSide(color: extremeGreen, width: 2) : BorderSide.none,
      ),
      child: ListTile(
        leading: Icon(method.icon, color: isSelected ? extremeGreen : Colors.grey),
        title: Text(method.name, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        subtitle: Text(method.description),
        trailing: isSelected ? const Icon(Icons.check_circle, color: extremeGreen) : null,
        onTap: () => onSelect(method),
      ),
    );
  }
}

// --- WIDGET AUXILIAR PARA FILA DE DETALLE ---
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: extremeGreen),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}