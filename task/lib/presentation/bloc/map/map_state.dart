import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

/// Base class for all map states
abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

/// Initial map state
class MapInitial extends MapState {
  const MapInitial();
}

/// Map is loading/initializing
class MapLoading extends MapState {
  const MapLoading();
}

/// Map is ready with all data
class MapReady extends MapState {
  final LatLng driverPosition;
  final double driverHeading;
  final LatLng destination;
  final List<LatLng> fullRoute;
  final List<LatLng> remainingRoute;
  final LatLng cameraCenter;
  final double zoom;

  const MapReady({
    required this.driverPosition,
    required this.driverHeading,
    required this.destination,
    required this.fullRoute,
    required this.remainingRoute,
    required this.cameraCenter,
    required this.zoom,
  });

  MapReady copyWith({
    LatLng? driverPosition,
    double? driverHeading,
    LatLng? destination,
    List<LatLng>? fullRoute,
    List<LatLng>? remainingRoute,
    LatLng? cameraCenter,
    double? zoom,
  }) {
    return MapReady(
      driverPosition: driverPosition ?? this.driverPosition,
      driverHeading: driverHeading ?? this.driverHeading,
      destination: destination ?? this.destination,
      fullRoute: fullRoute ?? this.fullRoute,
      remainingRoute: remainingRoute ?? this.remainingRoute,
      cameraCenter: cameraCenter ?? this.cameraCenter,
      zoom: zoom ?? this.zoom,
    );
  }

  @override
  List<Object?> get props => [
        driverPosition,
        driverHeading,
        destination,
        fullRoute,
        remainingRoute,
        cameraCenter,
        zoom,
      ];
}

/// Map error state
class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}

