class NotificationModel {
  final String email;
  final String fecha; // YYYY-MM-DD
  final String hora; // HH:mm
  final String piloto;
  final String cargosAdicionales;
  final String totalPagar;
  final String actividad;
  final String metodoPago;

  NotificationModel({
    required this.email,
    required this.fecha,
    required this.hora,
    required this.piloto,
    required this.cargosAdicionales,
    required this.totalPagar,
    required this.actividad,
    required this.metodoPago,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'fecha': fecha,
    'hora': hora,
    'piloto': piloto,
    'cargosAdicionales': cargosAdicionales,
    'totalPagar': totalPagar,
    'actividad': actividad,
    'metodoPago': metodoPago,
  };
}
