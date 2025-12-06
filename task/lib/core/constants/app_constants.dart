/// Application-wide constants
class AppConstants {
  AppConstants._();

  // Stream emission interval (2-3 seconds as per requirement)
  static const Duration streamInterval = Duration(seconds: 2);

  // Map constants
  static const double defaultZoom = 14.0;
  static const double trackingZoom = 16.0;

  // Average speed for ETA calculation (km/h)
  static const double averageSpeedKmh = 25.0;

  // Status constants
  static const String statusPicked = 'picked';
  static const String statusEnRoute = 'en_route';
  static const String statusArriving = 'arriving';
  static const String statusDelivered = 'delivered';
}

