import '../../core/constants/app_constants.dart';
import '../../core/utils/distance_calculator.dart';

/// Use case for calculating ETA and distance
class CalculateETAUseCase {
  CalculateETAUseCase();

  /// Calculate distance between two points in kilometers
  double calculateDistance(
    double currentLat,
    double currentLng,
    double destLat,
    double destLng,
  ) {
    return DistanceCalculator.calculateDistance(
      currentLat,
      currentLng,
      destLat,
      destLng,
    );
  }

  /// Calculate ETA in minutes based on distance
  int calculateETA(double distanceKm) {
    return DistanceCalculator.calculateETA(
      distanceKm,
      AppConstants.averageSpeedKmh,
    );
  }

  /// Get formatted distance string
  String getFormattedDistance(double distanceKm) {
    return DistanceCalculator.formatDistance(distanceKm);
  }

  /// Get formatted ETA string
  String getFormattedETA(int minutes) {
    return DistanceCalculator.formatETA(minutes);
  }
}

