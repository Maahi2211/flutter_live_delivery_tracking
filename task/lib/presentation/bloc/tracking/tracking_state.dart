import 'package:equatable/equatable.dart';
import '../../../domain/entities/delivery_order_entity.dart';
import '../../../domain/entities/location_update_entity.dart';

/// Base class for all tracking states
abstract class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object?> get props => [];
}

/// Initial state before tracking starts
class TrackingInitial extends TrackingState {
  const TrackingInitial();
}

/// Loading state while fetching order data
class TrackingLoading extends TrackingState {
  const TrackingLoading();
}

/// State when tracking is active
class TrackingActive extends TrackingState {
  final DeliveryOrderEntity order;
  final LocationUpdateEntity currentLocation;
  final double distanceRemaining;
  final int etaMinutes;
  final String currentStatus;
  final int currentRouteIndex;
  final DateTime lastUpdated;

  const TrackingActive({
    required this.order,
    required this.currentLocation,
    required this.distanceRemaining,
    required this.etaMinutes,
    required this.currentStatus,
    required this.currentRouteIndex,
    required this.lastUpdated,
  });

  TrackingActive copyWith({
    DeliveryOrderEntity? order,
    LocationUpdateEntity? currentLocation,
    double? distanceRemaining,
    int? etaMinutes,
    String? currentStatus,
    int? currentRouteIndex,
    DateTime? lastUpdated,
  }) {
    return TrackingActive(
      order: order ?? this.order,
      currentLocation: currentLocation ?? this.currentLocation,
      distanceRemaining: distanceRemaining ?? this.distanceRemaining,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      currentStatus: currentStatus ?? this.currentStatus,
      currentRouteIndex: currentRouteIndex ?? this.currentRouteIndex,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        order,
        currentLocation,
        distanceRemaining,
        etaMinutes,
        currentStatus,
        currentRouteIndex,
        lastUpdated,
      ];
}

/// State when delivery is completed
class TrackingCompleted extends TrackingState {
  final DeliveryOrderEntity order;
  final DateTime completedAt;

  const TrackingCompleted({
    required this.order,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [order, completedAt];
}

/// Error state
class TrackingError extends TrackingState {
  final String message;

  const TrackingError(this.message);

  @override
  List<Object?> get props => [message];
}

