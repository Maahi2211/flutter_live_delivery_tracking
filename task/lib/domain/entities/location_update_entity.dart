import 'package:equatable/equatable.dart';

/// Location update entity representing real-time driver location
/// Emitted by the simulated WebSocket stream every 2-3 seconds
class LocationUpdateEntity extends Equatable {
  final double lat;
  final double lng;
  final double speed;
  final double heading;
  final String status;
  final DateTime timestamp;

  const LocationUpdateEntity({
    required this.lat,
    required this.lng,
    required this.speed,
    required this.heading,
    required this.status,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [lat, lng, speed, heading, status, timestamp];
}

