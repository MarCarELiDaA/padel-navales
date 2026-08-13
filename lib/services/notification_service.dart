import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Solicitar permisos en Android 13+
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Inicializar timezone
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Madrid'));

    _initialized = true;
  }

  void _onNotificationTap(NotificationResponse response) {
    // Manejar tap en notificación si es necesario
  }

  Future<void> showReservationConfirmation() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'reservas_channel',
      'Reservas',
      channelDescription: 'Notificaciones de reservas de pádel',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      '🎾 Reserva realizada correctamente',
      'Tu reserva se ha guardado correctamente.',
      platformChannelSpecifics,
    );
  }

  Future<void> scheduleReminder(
    String reservaId,
    String fecha,
    String hora,
  ) async {
    // Parsear fecha y hora
    final parts = fecha.split('/');
    if (parts.length != 3) return;

    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    final timeParts = hora.split(':');
    if (timeParts.length != 2) return;

    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Crear DateTime de la reserva
    final now = DateTime.now();
    final reservationTime = DateTime(year, month, day, hour, minute);

    // Calcular hora del recordatorio (1 hora antes)
    final reminderTime = reservationTime.subtract(const Duration(hours: 1));

    // Verificar si el recordatorio es en el futuro
    if (reminderTime.isBefore(now)) {
      return; // No programar si ya pasó o es muy pronto
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'reservas_channel',
      'Reservas',
      channelDescription: 'Notificaciones de reservas de pádel',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.zonedSchedule(
      reservaId.hashCode, // Usar hash del ID como ID de notificación
      '⏰ Recordatorio de reserva',
      'Tienes una reserva de la pista de pádel dentro de una hora.',
      tz.TZDateTime.from(reminderTime, tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> showCancellationNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'reservas_channel',
      'Reservas',
      channelDescription: 'Notificaciones de reservas de pádel',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      1,
      'Reserva cancelada',
      'Tu reserva ha sido cancelada correctamente.',
      platformChannelSpecifics,
    );
  }

  Future<void> cancelReminder(String reservaId) async {
    await _notificationsPlugin.cancel(reservaId.hashCode);
  }
}
