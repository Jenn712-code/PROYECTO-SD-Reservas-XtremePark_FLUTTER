import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importación crucial (RUTA LOCAL ANTIGUA):
import 'home_page.dart';
import 'l10n/app_localizations.dart';

import 'package:xtremepark_flutter/language_provider.dart';
import 'package:xtremepark_flutter/home_page.dart';

import 'language_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      // Configuración de localización OBLIGATORIA
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      locale: langProvider.currentLocale,
      title: 'Xtreme Park - Reservas',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}