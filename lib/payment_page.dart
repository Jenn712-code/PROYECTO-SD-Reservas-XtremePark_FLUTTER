// Archivo: lib/payment_page.dart
/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ Importación requerida para InputFormatters
import 'package:intl/intl.dart';
import 'package:xtremepark_flutter/pilot_model.dart';
import 'package:xtremepark_flutter/payment_model.dart';
import 'package:xtremepark_flutter/booking_page.dart'; // Importa la clase Addon

// Definición de colores principales
const Color extremeGreen = Color(0xFF6B9C23);
const double webPadding = 100.0;

// =============================================================================
// I. CLASE PRINCIPAL DE LA PÁGINA DE PAGO
// =============================================================================

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
    this.selectedPilot,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod? _selectedPaymentMethod;
  final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  // ✅ Estado para controlar la validez del formulario seleccionado
  bool _isFormValid = false;

  // Función de callback que los formularios auxiliares llamarán para actualizar el estado
  void _updateFormValidity(bool isValid) {
    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  // Widget para mostrar un detalle de la reserva en el resumen
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

  // Widget para el resumen de detalles de la reserva (columna izquierda)
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

  @override
  Widget build(BuildContext context) {
    // Si no hay un método seleccionado, el formulario no es válido
    if (_selectedPaymentMethod == null) {
      _isFormValid = false;
    }

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
              // --- COLUMNA 1: RESUMEN DE LA RESERVA & MÉTODOS (70% del ancho) ---
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

                    // Lista de Métodos de Pago
                    ...availableMethods.map((method) =>
                        _PaymentMethodTile(
                          method: method,
                          isSelected: _selectedPaymentMethod == method,
                          onSelect: (m) {
                            setState(() {
                              _selectedPaymentMethod = m;
                              _isFormValid = false; // Resetear la validez al cambiar de método
                            });
                          },
                        )
                    ).toList(),

                    const SizedBox(height: 30),

                    // --- 3. FORMULARIO DE PAGO DINÁMICO ---
                    if (_selectedPaymentMethod != null) ...[
                      Text('3. Ingresa Datos de Pago (${_selectedPaymentMethod!.name})', style: Theme.of(context).textTheme.headlineSmall),
                      const Divider(color: extremeGreen),

                      // ✅ Pasamos el callback de validación al formulario
                      _PaymentFormSection(
                        methodName: _selectedPaymentMethod!.name,
                        onValidityChanged: _updateFormValidity,
                      ),
                      const SizedBox(height: 40),
                    ],
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
                            // ✅ El botón SÓLO se habilita si hay método seleccionado Y el formulario es válido
                            onPressed: (_selectedPaymentMethod != null && _isFormValid) ? () {
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
                        if (!_isFormValid)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _selectedPaymentMethod == null
                                  ? 'Selecciona un método de pago.'
                                  : 'Completa los datos de pago para continuar.',
                              style: const TextStyle(color: Colors.red, fontSize: 14),
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
}

// =============================================================================
// II. WIDGETS AUXILIARES PARA DETALLES Y MÉTODOS DE PAGO
// =============================================================================

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

// --- WIDGET AUXILIAR PARA TILE DE MÉTODO DE PAGO ---
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

// =============================================================================
// III. WIDGETS AUXILIARES PARA FORMULARIOS DE PAGO DINÁMICOS CON VALIDACIÓN
// =============================================================================

// --- WIDGET ENRUTADOR DE FORMULARIOS ---
class _PaymentFormSection extends StatelessWidget {
  final String methodName;
  // Callback para notificar la validez del formulario padre
  final ValueChanged<bool> onValidityChanged;

  const _PaymentFormSection({
    required this.methodName,
    required this.onValidityChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Si no hay método, notifica que es inválido
    if (methodName.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onValidityChanged(false);
      });
      return Container();
    }

    switch (methodName) {
      case 'Tarjeta de Crédito / Débito':
        return _CreditCardForm(onValidityChanged: onValidityChanged);
      case 'PayPal':
        return _PayPalForm(onValidityChanged: onValidityChanged);
      case 'Transferencia Bancaria (PSE)':
        return _PSEForm(onValidityChanged: onValidityChanged);
      default:
      // Si no es un método conocido, asume inválido
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onValidityChanged(false);
        });
        return Container();
    }
  }
}

// --- FORMULARIO DE TARJETA DE CRÉDITO / DÉBITO (USA GlobalKey y restricción de dígitos) ---
class _CreditCardForm extends StatefulWidget {
  final ValueChanged<bool> onValidityChanged;

  const _CreditCardForm({required this.onValidityChanged});

  @override
  State<_CreditCardForm> createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<_CreditCardForm> {
  final _formKey = GlobalKey<FormState>();

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    widget.onValidityChanged(isValid);
  }

  @override
  void initState() {
    super.initState();
    widget.onValidityChanged(false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _validateForm,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Número de Tarjeta',
                    hintText: 'xxxx xxxx xxxx xxxx',
                    prefixIcon: Icon(Icons.credit_card),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  // ✅ Restricción de entrada: solo dígitos y máximo 16 caracteres
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
                  validator: (value) => (value == null || value.length < 16) ? 'Ingresa 16 dígitos' : null,
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 150,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  // ✅ Restricción de entrada: solo dígitos y máximo 4 caracteres
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  validator: (value) => (value == null || value.length < 3) ? '3 o 4 dígitos' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nombre en la Tarjeta',
                    hintText: 'JOHN DOE',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Requerido' : null,
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 150,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Vencimiento',
                    hintText: 'MM/AA',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                  // ✅ Restricción de entrada: solo dígitos y máximo 4 caracteres
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  validator: (value) => (value == null || value.length < 4) ? 'Formato MM/AA' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- FORMULARIO DE PAYPAL (USA TextEditingController) ---
class _PayPalForm extends StatefulWidget {
  final ValueChanged<bool> onValidityChanged;

  const _PayPalForm({required this.onValidityChanged});

  @override
  State<_PayPalForm> createState() => _PayPalFormState();
}

class _PayPalFormState extends State<_PayPalForm> {
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.onValidityChanged(false);
    _emailController.addListener(_validateForm);
  }

  void _validateForm() {
    // Simple check: el campo no está vacío y contiene un '@'
    final isValid = _emailController.text.isNotEmpty && _emailController.text.contains('@');
    widget.onValidityChanged(isValid);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateForm);
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Serás redirigido a PayPal para completar tu pago.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Asegúrate de tener tus credenciales a mano. La ventana de redirección se abrirá al hacer clic en "PAGAR Y CONFIRMAR".'),
            const SizedBox(height: 10),
            // Input de Correo
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico de PayPal',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }
}

// --- FORMULARIO DE TRANSFERENCIA BANCARIA (PSE) (USA DropdownButtonFormField) ---
class _PSEForm extends StatefulWidget {
  final ValueChanged<bool> onValidityChanged;

  const _PSEForm({required this.onValidityChanged});

  @override
  State<_PSEForm> createState() => _PSEFormState();
}

class _PSEFormState extends State<_PSEForm> {
  String? _selectedBank;

  // Lista de bancos simulados
  final List<String> banks = const [
    'BANCOLOMBIA', 'DAVIPLATA', 'NEQUI', 'MOVII',
    'BBVA', 'BANCO DE BOGOTÁ', 'AV VILLAS', 'OCCIDENTE',
  ];

  @override
  void initState() {
    super.initState();
    widget.onValidityChanged(false); // Inicialmente inválido
  }

  void _validateForm(String? newValue) {
    setState(() {
      _selectedBank = newValue;
    });
    // Válido si se selecciona un banco
    widget.onValidityChanged(newValue != null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selecciona tu banco para la transferencia PSE:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Banco',
            border: OutlineInputBorder(),
          ),
          hint: const Text('Elige una entidad bancaria'),
          value: _selectedBank, // Usar el estado
          items: banks.map((String bank) {
            return DropdownMenuItem<String>(
              value: bank,
              child: Text(bank),
            );
          }).toList(),
          onChanged: _validateForm, // Usar la función de validación
          validator: (value) => value == null ? 'Debes seleccionar un banco' : null,
        ),
        const SizedBox(height: 20),
        const Text('Serás redirigido a la página de tu banco para finalizar la transacción al confirmar el pago.', style: TextStyle(color: Colors.black54)),
      ],
    );
  }
}

 */
// Archivo: lib/payment_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Requerido para InputFormatters (restricción de dígitos)
import 'package:intl/intl.dart';

// Asegúrate de que estas rutas sean correctas en tu proyecto
import 'package:xtremepark_flutter/pilot_model.dart';
import 'package:xtremepark_flutter/payment_model.dart';
import 'package:xtremepark_flutter/booking_page.dart'; // Para la clase Addon
import 'package:xtremepark_flutter/confirmation_page.dart'; // ✅ Importación de la página de confirmación

// Definición de colores principales
const Color extremeGreen = Color(0xFF6B9C23);
const double webPadding = 100.0;

// =============================================================================
// I. CLASE PRINCIPAL DE LA PÁGINA DE PAGO
// =============================================================================

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
    this.selectedPilot,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod? _selectedPaymentMethod;
  final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  // Estado para controlar la validez del formulario seleccionado
  bool _isFormValid = false;

  // Función de callback que los formularios auxiliares llamarán para actualizar el estado
  void _updateFormValidity(bool isValid) {
    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  // Widget para mostrar un detalle de la reserva en el resumen
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

  // Widget para el resumen de detalles de la reserva (columna izquierda)
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

  @override
  Widget build(BuildContext context) {
    // Si no hay un método seleccionado, el formulario no es válido
    if (_selectedPaymentMethod == null) {
      _isFormValid = false;
    }

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
              // --- COLUMNA 1: RESUMEN DE LA RESERVA & MÉTODOS (70% del ancho) ---
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

                    // Lista de Métodos de Pago
                    ...availableMethods.map((method) =>
                        _PaymentMethodTile(
                          method: method,
                          isSelected: _selectedPaymentMethod == method,
                          onSelect: (m) {
                            setState(() {
                              _selectedPaymentMethod = m;
                              _isFormValid = false; // Resetear la validez al cambiar de método
                            });
                          },
                        )
                    ).toList(),

                    const SizedBox(height: 30),

                    // --- 3. FORMULARIO DE PAGO DINÁMICO ---
                    if (_selectedPaymentMethod != null) ...[
                      Text('3. Ingresa Datos de Pago (${_selectedPaymentMethod!.name})', style: Theme.of(context).textTheme.headlineSmall),
                      const Divider(color: extremeGreen),

                      _PaymentFormSection(
                        methodName: _selectedPaymentMethod!.name,
                        onValidityChanged: _updateFormValidity,
                      ),
                      const SizedBox(height: 40),
                    ],
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
                            // ✅ El botón SÓLO se habilita si hay método seleccionado Y el formulario es válido
                            onPressed: (_selectedPaymentMethod != null && _isFormValid) ? () {

                              // ✅ Navegación a la página de confirmación
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConfirmationPage(
                                    activityTitle: widget.activityTitle,
                                    totalPrice: widget.totalPrice,
                                    selectedDate: widget.selectedDate,
                                    selectedTime: widget.selectedTime,
                                    paymentMethodName: _selectedPaymentMethod!.name,
                                    selectedAddons: widget.selectedAddons,
                                    selectedPilot: widget.selectedPilot,
                                  ),
                                ),
                              );

                              // Mensaje de éxito (opcional, ya que se redirige)
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Pago de \$${widget.totalPrice.toStringAsFixed(2)} y Reserva Confirmada. Redirigiendo...')),
                              );

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
                        if (!_isFormValid)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _selectedPaymentMethod == null
                                  ? 'Selecciona un método de pago.'
                                  : 'Completa los datos de pago para continuar.',
                              style: const TextStyle(color: Colors.red, fontSize: 14),
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
}

// =============================================================================
// II. WIDGETS AUXILIARES PARA DETALLES Y MÉTODOS DE PAGO
// =============================================================================

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

// --- WIDGET AUXILIAR PARA TILE DE MÉTODO DE PAGO ---
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

// =============================================================================
// III. WIDGETS AUXILIARES PARA FORMULARIOS DE PAGO DINÁMICOS CON VALIDACIÓN
// =============================================================================

// --- WIDGET ENRUTADOR DE FORMULARIOS ---
class _PaymentFormSection extends StatelessWidget {
  final String methodName;
  final ValueChanged<bool> onValidityChanged;

  const _PaymentFormSection({
    required this.methodName,
    required this.onValidityChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (methodName.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onValidityChanged(false);
      });
      return Container();
    }

    switch (methodName) {
      case 'Tarjeta de Crédito / Débito':
        return _CreditCardForm(onValidityChanged: onValidityChanged);
      case 'PayPal':
        return _PayPalForm(onValidityChanged: onValidityChanged);
      case 'Transferencia Bancaria (PSE)':
        return _PSEForm(onValidityChanged: onValidityChanged);
      default:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onValidityChanged(false);
        });
        return Container();
    }
  }
}

// --- FORMULARIO DE TARJETA DE CRÉDITO / DÉBITO (USA GlobalKey y restricción de dígitos) ---
class _CreditCardForm extends StatefulWidget {
  final ValueChanged<bool> onValidityChanged;

  const _CreditCardForm({required this.onValidityChanged});

  @override
  State<_CreditCardForm> createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<_CreditCardForm> {
  final _formKey = GlobalKey<FormState>();

  void _validateForm() {
    // Esto fuerza la ejecución de todos los validators y actualiza la validez
    final isValid = _formKey.currentState?.validate() ?? false;
    widget.onValidityChanged(isValid);
  }

  @override
  void initState() {
    super.initState();
    widget.onValidityChanged(false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _validateForm,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Número de Tarjeta',
                    hintText: 'xxxx xxxx xxxx xxxx',
                    prefixIcon: Icon(Icons.credit_card),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  // ✅ Restricción de entrada: solo dígitos y máximo 16 caracteres
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
                  validator: (value) => (value == null || value.length < 16) ? 'Ingresa 16 dígitos' : null,
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 150,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  // ✅ Restricción de entrada: solo dígitos y máximo 4 caracteres
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  validator: (value) => (value == null || value.length < 3) ? '3 o 4 dígitos' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nombre en la Tarjeta',
                    hintText: 'JOHN DOE',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Requerido' : null,
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 150,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Vencimiento',
                    hintText: 'MM/AA',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                  // ✅ Restricción de entrada: solo dígitos y máximo 4 caracteres
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  validator: (value) => (value == null || value.length < 4) ? 'Formato MM/AA' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- FORMULARIO DE PAYPAL (USA TextEditingController) ---
class _PayPalForm extends StatefulWidget {
  final ValueChanged<bool> onValidityChanged;

  const _PayPalForm({required this.onValidityChanged});

  @override
  State<_PayPalForm> createState() => _PayPalFormState();
}

class _PayPalFormState extends State<_PayPalForm> {
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.onValidityChanged(false);
    _emailController.addListener(_validateForm);
  }

  void _validateForm() {
    // Simple check: el campo no está vacío y contiene un '@'
    final isValid = _emailController.text.isNotEmpty && _emailController.text.contains('@');
    widget.onValidityChanged(isValid);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateForm);
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Serás redirigido a PayPal para completar tu pago.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Asegúrate de tener tus credenciales a mano. La ventana de redirección se abrirá al hacer clic en "PAGAR Y CONFIRMAR".'),
            const SizedBox(height: 10),
            // Input de Correo
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico de PayPal',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }
}

// --- FORMULARIO DE TRANSFERENCIA BANCARIA (PSE) (USA DropdownButtonFormField) ---
class _PSEForm extends StatefulWidget {
  final ValueChanged<bool> onValidityChanged;

  const _PSEForm({required this.onValidityChanged});

  @override
  State<_PSEForm> createState() => _PSEFormState();
}

class _PSEFormState extends State<_PSEForm> {
  String? _selectedBank;

  // Lista de bancos simulados
  final List<String> banks = const [
    'BANCOLOMBIA', 'DAVIPLATA', 'NEQUI', 'MOVII',
    'BBVA', 'BANCO DE BOGOTÁ', 'AV VILLAS', 'OCCIDENTE',
  ];

  @override
  void initState() {
    super.initState();
    widget.onValidityChanged(false); // Inicialmente inválido
  }

  void _validateForm(String? newValue) {
    setState(() {
      _selectedBank = newValue;
    });
    // Válido si se selecciona un banco
    widget.onValidityChanged(newValue != null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selecciona tu banco para la transferencia PSE:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Banco',
            border: OutlineInputBorder(),
          ),
          hint: const Text('Elige una entidad bancaria'),
          value: _selectedBank, // Usar el estado
          items: banks.map((String bank) {
            return DropdownMenuItem<String>(
              value: bank,
              child: Text(bank),
            );
          }).toList(),
          onChanged: _validateForm, // Usar la función de validación
          validator: (value) => value == null ? 'Debes seleccionar un banco' : null,
        ),
        const SizedBox(height: 20),
        const Text('Serás redirigido a la página de tu banco para finalizar la transacción al confirmar el pago.', style: TextStyle(color: Colors.black54)),
      ],
    );
  }
}