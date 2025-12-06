import '../repositories/tracking_repository.dart';

/// Use case for stopping live tracking
class StopTrackingUseCase {
  final TrackingRepository repository;

  StopTrackingUseCase(this.repository);

  void call() {
    repository.stopLocationUpdates();
  }
}

