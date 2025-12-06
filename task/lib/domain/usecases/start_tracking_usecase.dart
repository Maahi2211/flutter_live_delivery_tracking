import '../entities/location_update_entity.dart';
import '../repositories/tracking_repository.dart';

/// Use case for starting live tracking
/// Returns a stream of location updates
class StartTrackingUseCase {
  final TrackingRepository repository;

  StartTrackingUseCase(this.repository);

  Stream<LocationUpdateEntity> call() {
    return repository.getLocationUpdatesStream();
  }
}

