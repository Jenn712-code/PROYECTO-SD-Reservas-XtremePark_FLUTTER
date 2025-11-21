import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xtremepark_flutter/config/api_config.dart';
import 'notification.dart';

class NotificationService {

  static Future<bool> createNotification(NotificationModel notification) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/notificaciones/crear");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(notification.toJson()),
    );

    if (response.statusCode == 200) {
      // Notificación creada exitosamente
      return true;
    } else if (response.statusCode == 409) {
      // Conflicto: ya existe una notificación para esa fecha y hora
      throw Exception('Ya existe una notificación para esa fecha y hora.');
    } else {
      // Otro error
      throw Exception('Error al crear notificación: ${response.body}');
    }
  }
}
