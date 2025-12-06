import '../../domain/entities/delivery_order_entity.dart';
import '../../domain/entities/location_update_entity.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../datasources/mock_data_source.dart';

/// Implementation of TrackingRepository
/// Connects domain layer with data sources
class TrackingRepositoryImpl implements TrackingRepository {
  final MockDataSource dataSource;

  TrackingRepositoryImpl({required this.dataSource});

  @override
  Future<DeliveryOrderEntity> getDeliveryOrder() async {
    return await dataSource.getDeliveryOrder();
  }

  @override
  Stream<LocationUpdateEntity> getLocationUpdatesStream() {
    return dataSource.getLocationUpdatesStream();
  }

  @override
  void stopLocationUpdates() {
    dataSource.stopLocationUpdates();
  }

  @override
  void resetTracking() {
    dataSource.resetTracking();
  }
}

