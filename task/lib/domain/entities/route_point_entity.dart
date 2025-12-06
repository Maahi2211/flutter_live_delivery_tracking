import 'package:equatable/equatable.dart';

/// Route point entity representing a single point in the delivery route
class RoutePointEntity extends Equatable {
  final double lat;
  final double lng;
  final String status;

  const RoutePointEntity({
    required this.lat,
    required this.lng,
    required this.status,
  });

  @override
  List<Object?> get props => [lat, lng, status];
}

