import '../entities/delivery_order_entity.dart';
import '../entities/location_update_entity.dart';

/// Abstract repository for tracking operations
/// Defines the contract for data layer implementation
abstract class TrackingRepository {
  /// Get delivery order data from mock source
  Future<DeliveryOrderEntity> getDeliveryOrder();

  /// Get simulated location updates stream (WebSocket-like)
  /// Emits location updates every 2-3 seconds
  Stream<LocationUpdateEntity> getLocationUpdatesStream();

  /// Stop the location updates stream
  void stopLocationUpdates();

  /// Reset tracking to initial state
  void resetTracking();
}

