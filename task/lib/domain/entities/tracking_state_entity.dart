import 'package:equatable/equatable.dart';
import 'delivery_order_entity.dart';
import 'location_update_entity.dart';

/// Tracking state entity containing all tracking information
class TrackingStateEntity extends Equatable {
  final DeliveryOrderEntity order;
  final LocationUpdateEntity? currentLocation;
  final double distanceRemaining;
  final int etaMinutes;
  final int currentRouteIndex;
  final bool isTracking;

  const TrackingStateEntity({
    required this.order,
    this.currentLocation,
    required this.distanceRemaining,
    required this.etaMinutes,
    required this.currentRouteIndex,
    required this.isTracking,
  });

  TrackingStateEntity copyWith({
    DeliveryOrderEntity? order,
    LocationUpdateEntity? currentLocation,
    double? distanceRemaining,
    int? etaMinutes,
    int? currentRouteIndex,
    bool? isTracking,
  }) {
    return TrackingStateEntity(
      order: order ?? this.order,
      currentLocation: currentLocation ?? this.currentLocation,
      distanceRemaining: distanceRemaining ?? this.distanceRemaining,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      currentRouteIndex: currentRouteIndex ?? this.currentRouteIndex,
      isTracking: isTracking ?? this.isTracking,
    );
  }

  @override
  List<Object?> get props => [
        order,
        currentLocation,
        distanceRemaining,
        etaMinutes,
        currentRouteIndex,
        isTracking,
      ];
}

