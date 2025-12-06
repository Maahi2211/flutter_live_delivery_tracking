import 'dart:math';

/// Utility class for calculating distances and ETA
class DistanceCalculator {
  DistanceCalculator._();

  /// Calculate distance between two points using Haversine formula
  /// Returns distance in kilometers
  static double calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final double dLat = _toRadians(lat2 - lat1);
    final double dLng = _toRadians(lng2 - lng1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Calculate ETA based on distance and average speed
  /// Returns ETA in minutes
  static int calculateETA(double distanceKm, double averageSpeedKmh) {
    if (averageSpeedKmh <= 0) return 0;
    final double timeHours = distanceKm / averageSpeedKmh;
    return (timeHours * 60).ceil();
  }

  /// Calculate total route distance from current position to destination
  static double calculateRouteDistance(
    double currentLat,
    double currentLng,
    List<Map<String, double>> remainingRoute,
    double destLat,
    double destLng,
  ) {
    double totalDistance = 0;
    double prevLat = currentLat;
    double prevLng = currentLng;

    // Add distance through remaining waypoints
    for (final point in remainingRoute) {
      totalDistance += calculateDistance(
        prevLat,
        prevLng,
        point['lat']!,
        point['lng']!,
      );
      prevLat = point['lat']!;
      prevLng = point['lng']!;
    }

    // Add final segment to destination if not already there
    if (prevLat != destLat || prevLng != destLng) {
      totalDistance += calculateDistance(prevLat, prevLng, destLat, destLng);
    }

    return totalDistance;
  }

  static double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// Format distance for display
  static String formatDistance(double distanceKm) {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).toInt()} m';
    }
    return '${distanceKm.toStringAsFixed(2)} km';
  }

  /// Format ETA for display
  static String formatETA(int minutes) {
    if (minutes < 1) {
      return 'Arriving now';
    } else if (minutes < 60) {
      return '$minutes min';
    } else {
      final int hours = minutes ~/ 60;
      final int mins = minutes % 60;
      return '${hours}h ${mins}m';
    }
  }
}

