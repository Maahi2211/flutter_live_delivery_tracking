import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

/// Base class for all map events
abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize map with route data
class InitializeMap extends MapEvent {
  final List<LatLng> routePoints;
  final LatLng destination;

  const InitializeMap({
    required this.routePoints,
    required this.destination,
  });

  @override
  List<Object?> get props => [routePoints, destination];
}

/// Event to update driver marker position (with animation)
class UpdateDriverMarker extends MapEvent {
  final LatLng position;
  final double heading;

  const UpdateDriverMarker({
    required this.position,
    required this.heading,
  });

  @override
  List<Object?> get props => [position, heading];
}

/// Event to move camera to follow driver
class MoveCameraToDriver extends MapEvent {
  final LatLng position;
  final double? zoom;

  const MoveCameraToDriver({
    required this.position,
    this.zoom,
  });

  @override
  List<Object?> get props => [position, zoom];
}

/// Event to update polyline (showing remaining route)
class UpdatePolyline extends MapEvent {
  final List<LatLng> points;

  const UpdatePolyline(this.points);

  @override
  List<Object?> get props => [points];
}

/// Event to show full route on map
class ShowFullRoute extends MapEvent {
  const ShowFullRoute();
}

/// Event to reset map state
class ResetMap extends MapEvent {
  const ResetMap();
}

