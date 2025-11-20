// Archivo: lib/booking_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesario para formatear la fecha/hora
import 'package:xtremepark_flutter/payment_page.dart';
import 'package:xtremepark_flutter/pilot_model.dart'; // Importación del modelo de pilotos

// Definición de colores principales
const Color extremeGreen = Color(0xFF6B9C23);
const double webPadding = 100.0;

// =============================================================================
// I. MODELOS DE DATOS ADICIONALES (para extras)
// =============================================================================

class Addon {
  final String name;
  final String description;
  final double price;
  final IconData icon;

  const Addon({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
  });
}

// Lista de addons disponibles
const List<Addon> availableAddons = [
  // ✅ ÚNICA OPCIÓN REQUERIDA: Cámara 360
  Addon(
    name: 'Cámara 360 (Insta360)',
    description: 'Video inmersivo de alta calidad de tu experiencia con cámara 360.',
    price: 35.00,
    icon: Icons.camera_alt,
  ),
];

// =============================================================================
// II. PÁGINA PRINCIPAL DE RESERVA
// =============================================================================

class BookingPage extends StatefulWidget {
  final String activityTitle;
  final double basePrice; // Asegúrate de pasar el precio real de la actividad

  const BookingPage({super.key, required this.activityTitle, required this.basePrice});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  Pilot? _selectedPilot;
  final Set<Addon> _selectedAddons = {}; // Usamos un Set para addons únicos
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _updatePrice(); // Calcula el precio inicial
  }

  void _updatePrice() {
    setState(() {
      _totalPrice = widget.basePrice; // Siempre comienza con el precio base de la actividad

      // Sumar precios de addons seleccionados
      for (var addon in _selectedAddons) {
        _totalPrice += addon.price;
      }
    });
  }

  // --- Selectores de Fecha y Hora ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)), // Seleccionar hasta 1 año
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: extremeGreen,
            colorScheme: const ColorScheme.light(primary: extremeGreen),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        // Asegura que el formato AM/PM se use si es apropiado para el locale
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: extremeGreen,
            colorScheme: const ColorScheme.light(primary: extremeGreen),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reserva: ${widget.activityTitle}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: extremeGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: webPadding, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Título de la Sección ---
              Text(
                'Completa los detalles de tu reserva',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: extremeGreen),
              ),
              const SizedBox(height: 30),

              // --- 1. SELECCIÓN DE FECHA Y HORA (Calendario) ---
              Text('1. Selecciona Fecha y Hora', style: Theme.of(context).textTheme.headlineSmall),
              const Divider(color: extremeGreen),

              Row(
                children: [
                  // Botón de Fecha
                  Expanded(
                    child: _DateSelectorButton(
                      label: 'Fecha',
                      icon: Icons.calendar_today,
                      value: DateFormat('EEEE, d MMMM yyyy', 'es').format(_selectedDate),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Botón de Hora (Formato AM/PM)
                  Expanded(
                    child: _DateSelectorButton(
                      label: 'Hora',
                      icon: Icons.access_time,
                      value: _selectedTime == null
                          ? 'Seleccionar hora'
                          : _selectedTime!.format(context), // Formato AM/PM automático
                      onPressed: () => _selectTime(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // --- 2. SELECCIÓN DEL PILOTO ---
              Text('2. Elige tu Piloto Certificado', style: Theme.of(context).textTheme.headlineSmall),
              const Divider(color: extremeGreen),

              // Contenedor para las tarjetas de pilotos, centrado y con scroll
              Center( // Centra el ListView horizontalmente si no ocupa todo el ancho
                child: SizedBox(
                  height: 400,
                  child: ListView.builder(
                    shrinkWrap: true, // Ajusta el tamaño al contenido
                    scrollDirection: Axis.horizontal,
                    itemCount: availablePilots.length,
                    itemBuilder: (context, index) {
                      final pilot = availablePilots[index];
                      return PilotCard(
                        pilot: pilot,
                        isSelected: _selectedPilot == pilot,
                        onSelect: (p) {
                          setState(() {
                            _selectedPilot = (_selectedPilot == p) ? null : p;
                            _updatePrice(); // Actualiza el precio (aunque el piloto no tenga recargo, por si se añade en el futuro)
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // --- 3. SELECCIÓN DE CARGOS ADICIONALES ---
              Text('3. Cargos Adicionales', style: Theme.of(context).textTheme.headlineSmall),
              const Divider(color: extremeGreen),

              ListView.builder(
                shrinkWrap: true, // Importante para que ListView funcione dentro de SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(), // Evita scroll interno
                itemCount: availableAddons.length,
                itemBuilder: (context, index) {
                  final addon = availableAddons[index];
                  return AddonSelectionTile(
                    addon: addon,
                    isSelected: _selectedAddons.contains(addon),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          _selectedAddons.add(addon);
                        } else {
                          _selectedAddons.remove(addon);
                        }
                        _updatePrice(); // Recalcula el precio total
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 40),

              // --- 4. RESUMEN DEL PRECIO FINAL ---
              _PriceSummaryCard(
                basePrice: widget.basePrice,
                selectedAddons: _selectedAddons.toList(), // Pasa la lista de addons seleccionados
                totalPrice: _totalPrice,
              ),
              const SizedBox(height: 30),

              // --- Botón Final de Confirmación ---
              Center(
                child: ElevatedButton(
                  onPressed: (_selectedTime != null && _selectedDate != null) ? () {
                    // ✅ NUEVA LÓGICA: Navegar a la pasarela de pago
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          activityTitle: widget.activityTitle,
                          basePrice: widget.basePrice,
                          totalPrice: _totalPrice,
                          selectedDate: _selectedDate,
                          selectedTime: _selectedTime!,
                          selectedPilot: _selectedPilot,
                          selectedAddons: _selectedAddons.toList(),
                        ),
                      ),
                    );
                  } : null, // Desactivado si no hay fecha/hora seleccionada
                  style: ElevatedButton.styleFrom(
                    backgroundColor: extremeGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(300, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('CONFIRMAR RESERVA', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGETS AUXILIARES PARA LA PÁGINA DE RESERVA ---

class _DateSelectorButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final VoidCallback onPressed;

  const _DateSelectorButton({
    required this.label,
    required this.icon,
    required this.value,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: extremeGreen),
          label: Text(
            value,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            side: const BorderSide(color: Colors.grey),
            minimumSize: const Size(double.infinity, 60),
          ),
        ),
      ],
    );
  }
}

class PilotCard extends StatelessWidget {
  final Pilot pilot;
  final bool isSelected;
  final Function(Pilot) onSelect;

  const PilotCard({
    required this.pilot,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(pilot),
      child: Card(
        elevation: isSelected ? 8 : 2,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Espaciado entre tarjetas
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isSelected ? const BorderSide(color: extremeGreen, width: 3) : BorderSide.none,
        ),
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto y nombre del piloto
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: extremeGreen,
                    // 🚨 CORRECCIÓN: Usar AssetImage si la URL está definida
                    backgroundImage: (pilot.imageUrl.isNotEmpty)
                        ? AssetImage(pilot.imageUrl) as ImageProvider<Object>
                        : null, // Si la imagen no existe, backgroundImage es null

                    // Si backgroundImage es null, usamos el child (Icono) como fallback.
                    child: (pilot.imageUrl.isEmpty)
                        ? const Icon(Icons.person, color: Colors.white, size: 30)
                        : null, // Si hay backgroundImage, el child debe ser null
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pilot.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Text('Edad: ${pilot.age}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                  ),
                  Icon(
                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isSelected ? extremeGreen : Colors.grey,
                  ),
                ],
              ),
              const Divider(height: 25),

              // Descripción (Bio)
              Expanded( // Permite que el texto ocupe el espacio restante
                child: Text(
                  pilot.bio,
                  maxLines: 4, // Ajustado para que quepa mejor
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              const Divider(height: 25),

              // Detalles Técnicos
              _PilotDetailRow(
                icon: Icons.security,
                label: 'Certificación',
                value: pilot.certification,
              ),
              _PilotDetailRow(
                icon: Icons.hardware,
                label: 'Equipamiento',
                value: pilot.equipmentBrand,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PilotDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _PilotDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: extremeGreen),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

class AddonSelectionTile extends StatelessWidget {
  final Addon addon;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const AddonSelectionTile({
    required this.addon,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: isSelected ? const BorderSide(color: extremeGreen, width: 2) : BorderSide.none,
      ),
      child: CheckboxListTile(
        title: Row(
          children: [
            Icon(addon.icon, color: extremeGreen),
            const SizedBox(width: 10),
            Text(addon.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(currencyFormatter.format(addon.price), style: const TextStyle(fontWeight: FontWeight.bold, color: extremeGreen)),
          ],
        ),
        subtitle: Text(addon.description),
        value: isSelected,
        onChanged: onChanged,
        activeColor: extremeGreen,
        checkColor: Colors.white,
      ),
    );
  }
}

class _PriceSummaryCard extends StatelessWidget {
  final double basePrice;
  final List<Addon> selectedAddons; // Ahora recibe una lista de addons
  final double totalPrice;

  const _PriceSummaryCard({
    required this.basePrice,
    required this.selectedAddons,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('4. Resumen de Pago', style: Theme.of(context).textTheme.headlineSmall),
            const Divider(),

            _PriceRow(
              label: 'Costo Base de la Actividad:',
              value: currencyFormatter.format(basePrice),
              isTotal: false,
            ),
            // Mostrar cada addon seleccionado
            if (selectedAddons.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text('Cargos Adicionales:', style: Theme.of(context).textTheme.titleMedium),
              ...selectedAddons.map((addon) => _PriceRow(
                label: '  ${addon.name}:',
                value: currencyFormatter.format(addon.price),
                isTotal: false,
                color: Colors.blueGrey,
              )).toList(),
              const Divider(), // Divisor después de los addons
            ],
            const Divider(thickness: 2),
            _PriceRow(
              label: 'Total a Pagar:',
              value: currencyFormatter.format(totalPrice),
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final Color? color;

  const _PriceRow({
    required this.label,
    required this.value,
    required this.isTotal,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
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
}