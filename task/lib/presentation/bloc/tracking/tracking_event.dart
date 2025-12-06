import 'package:equatable/equatable.dart';
import '../../../domain/entities/location_update_entity.dart';

/// Base class for all tracking events
abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start tracking
class StartTracking extends TrackingEvent {
  const StartTracking();
}

/// Event to update driver location
class UpdateLocation extends TrackingEvent {
  final LocationUpdateEntity location;

  const UpdateLocation(this.location);

  @override
  List<Object?> get props => [location];
}

/// Event to update delivery status
class UpdateStatus extends TrackingEvent {
  final String status;

  const UpdateStatus(this.status);

  @override
  List<Object?> get props => [status];
}

/// Event to stop tracking
class StopTracking extends TrackingEvent {
  const StopTracking();
}

/// Event to reset tracking (for replay)
class ResetTracking extends TrackingEvent {
  const ResetTracking();
}

