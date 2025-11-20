// Archivo: lib/language_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Estructura de datos para un país/idioma
class Country {
  final String name;
  final String flagEmoji;
  final Locale locale;

  const Country({
    required this.name,
    required this.flagEmoji,
    required this.locale,
  });
}

// Lista de los 5 países (Se eliminan Alemania, Portugal e Italia)
const List<Country> availableCountries = [
  // 1. Colombia (Original)
  Country(name: 'Colombia', flagEmoji: '🇨🇴', locale: Locale('es', 'CO')),

  // 2. USA (Original)
  Country(name: 'USA', flagEmoji: '🇺🇸', locale: Locale('en', 'US')),

  // 3. France (Original)
  Country(name: 'France', flagEmoji: '🇫🇷', locale: Locale('fr', 'FR')),

  // 4. Japón (Añadido)
  Country(name: 'Japón', flagEmoji: '🇯🇵', locale: Locale('ja', 'JP')),

  // 5. Brasil (Añadido)
  Country(name: 'Brasil', flagEmoji: '🇧🇷', locale: Locale('pt', 'BR')),

  // ALEMANIA, PORTUGAL E ITALIA FUERON ELIMINADOS
];

class LanguageProvider extends ChangeNotifier {
  // El resto de la clase permanece igual
  Country _currentCountry = availableCountries.first;

  Country get currentCountry => _currentCountry;
  Locale get currentLocale => _currentCountry.locale;
  List<Country> get allAvailableCountries => availableCountries; // Getter corregido

  void setCountry(Country newCountry) {
    if (_currentCountry.name != newCountry.name) {
      _currentCountry = newCountry;
      notifyListeners();
    }
  }
}