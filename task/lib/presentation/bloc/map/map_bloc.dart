import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_constants.dart';
import 'map_event.dart';
import 'map_state.dart';

/// MapBloc - Manages map-related state
/// Handles: Marker animation, Camera movement, Polyline updates
class MapBloc extends Bloc<MapEvent, MapState> {
  List<LatLng> _fullRoute = [];
  LatLng? _destination;
  int _currentRouteIndex = 0;

  MapBloc() : super(const MapInitial()) {
    on<InitializeMap>(_onInitializeMap);
    on<UpdateDriverMarker>(_onUpdateDriverMarker);
    on<MoveCameraToDriver>(_onMoveCameraToDriver);
    on<UpdatePolyline>(_onUpdatePolyline);
    on<ShowFullRoute>(_onShowFullRoute);
    on<ResetMap>(_onResetMap);
  }

  /// Handle InitializeMap event
  void _onInitializeMap(
    InitializeMap event,
    Emitter<MapState> emit,
  ) {
    emit(const MapLoading());

    _fullRoute = event.routePoints;
    _destination = event.destination;
    _currentRouteIndex = 0;

    if (_fullRoute.isEmpty) {
      emit(const MapError('No route data available'));
      return;
    }

    final initialPosition = _fullRoute.first;

    emit(MapReady(
      driverPosition: initialPosition,
      driverHeading: 0,
      destination: _destination!,
      fullRoute: _fullRoute,
      remainingRoute: _fullRoute,
      cameraCenter: initialPosition,
      zoom: AppConstants.defaultZoom,
    ));
  }

  /// Handle UpdateDriverMarker event (with animation data)
  void _onUpdateDriverMarker(
    UpdateDriverMarker event,
    Emitter<MapState> emit,
  ) {
    final currentState = state;
    if (currentState is! MapReady) return;

    _currentRouteIndex++;

    // Calculate remaining route from current position
    final remainingRoute = _getRemainingRoute(event.position);

    emit(currentState.copyWith(
      driverPosition: event.position,
      driverHeading: event.heading,
      remainingRoute: remainingRoute,
      cameraCenter: event.position,
      zoom: AppConstants.trackingZoom,
    ));
  }

  /// Handle MoveCameraToDriver event
  void _onMoveCameraToDriver(
    MoveCameraToDriver event,
    Emitter<MapState> emit,
  ) {
    final currentState = state;
    if (currentState is! MapReady) return;

    emit(currentState.copyWith(
      cameraCenter: event.position,
      zoom: event.zoom ?? currentState.zoom,
    ));
  }

  /// Handle UpdatePolyline event
  void _onUpdatePolyline(
    UpdatePolyline event,
    Emitter<MapState> emit,
  ) {
    final currentState = state;
    if (currentState is! MapReady) return;

    emit(currentState.copyWith(
      remainingRoute: event.points,
    ));
  }

  /// Handle ShowFullRoute event
  void _onShowFullRoute(
    ShowFullRoute event,
    Emitter<MapState> emit,
  ) {
    final currentState = state;
    if (currentState is! MapReady) return;

    // Calculate center of route
    final center = _calculateRouteCenter(_fullRoute);

    emit(currentState.copyWith(
      cameraCenter: center,
      zoom: AppConstants.defaultZoom,
    ));
  }

  /// Handle ResetMap event
  void _onResetMap(
    ResetMap event,
    Emitter<MapState> emit,
  ) {
    _currentRouteIndex = 0;
    
    if (_fullRoute.isNotEmpty && _destination != null) {
      emit(MapReady(
        driverPosition: _fullRoute.first,
        driverHeading: 0,
        destination: _destination!,
        fullRoute: _fullRoute,
        remainingRoute: _fullRoute,
        cameraCenter: _fullRoute.first,
        zoom: AppConstants.defaultZoom,
      ));
    } else {
      emit(const MapInitial());
    }
  }

  /// Get remaining route from current position to destination
  List<LatLng> _getRemainingRoute(LatLng currentPosition) {
    if (_fullRoute.isEmpty || _destination == null) return [];

    // Find the closest point in the route to current position
    int closestIndex = 0;
    double minDistance = double.infinity;

    for (int i = 0; i < _fullRoute.length; i++) {
      final distance = _calculateDistance(currentPosition, _fullRoute[i]);
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }

    // Return remaining points from closest point to destination
    final remaining = <LatLng>[currentPosition];
    remaining.addAll(_fullRoute.sublist(closestIndex + 1));

    // Ensure destination is included
    if (remaining.isEmpty || remaining.last != _destination) {
      remaining.add(_destination!);
    }

    return remaining;
  }

  /// Calculate center point of route
  LatLng _calculateRouteCenter(List<LatLng> route) {
    if (route.isEmpty) return const LatLng(17.430, 78.460);

    double sumLat = 0;
    double sumLng = 0;

    for (final point in route) {
      sumLat += point.latitude;
      sumLng += point.longitude;
    }

    return LatLng(sumLat / route.length, sumLng / route.length);
  }

  /// Calculate distance between two points (simple Euclidean for comparison)
  double _calculateDistance(LatLng p1, LatLng p2) {
    final dLat = p1.latitude - p2.latitude;
    final dLng = p1.longitude - p2.longitude;
    return dLat * dLat + dLng * dLng;
  }
}

