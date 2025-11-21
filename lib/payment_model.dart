// Archivo: lib/payment_model.dart

import 'package:flutter/material.dart';

class PaymentMethod {
  final String name;
  final String description;
  final IconData icon;

  const PaymentMethod({
    required this.name,
    required this.description,
    required this.icon,
  });
}

// Datos de ejemplo para los métodos de pago
const List<PaymentMethod> availableMethods = [
  PaymentMethod(
    name: 'Tarjeta de Crédito / Débito',
    description: 'Visa, Mastercard, American Express',
    icon: Icons.credit_card,
  ),
  PaymentMethod(
    name: 'PayPal',
    description: 'Paga con tu cuenta de PayPal',
    icon: Icons.paypal, // Icono genérico, necesitarías un paquete para el icono real
  ),
  PaymentMethod(
    name: 'Transferencia Bancaria (PSE)',
    description: 'Pago seguro a través de tu banco local',
    icon: Icons.account_balance,
  ),
];