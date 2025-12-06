import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_theme.dart';
import '../bloc/map/map_bloc.dart';
import '../bloc/map/map_state.dart';

/// Map widget displaying the delivery route and markers
class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  AnimationController? _animationController;
  LatLng? _previousPosition;
  bool _isMapReady = false;

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  /// Animate camera to new position (only if map is ready)
  void _animateToPosition(LatLng position, double zoom) {
    if (!_isMapReady) return;

    try {
      _animationController?.dispose();
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      );

      final startPosition = _mapController.camera.center;
      final startZoom = _mapController.camera.zoom;

      final latTween = Tween<double>(
        begin: startPosition.latitude,
        end: position.latitude,
      );
      final lngTween = Tween<double>(
        begin: startPosition.longitude,
        end: position.longitude,
      );
      final zoomTween = Tween<double>(begin: startZoom, end: zoom);

      _animationController!.addListener(() {
        if (_isMapReady) {
          final lat = latTween.evaluate(_animationController!);
          final lng = lngTween.evaluate(_animationController!);
          final z = zoomTween.evaluate(_animationController!);
          _mapController.move(LatLng(lat, lng), z);
        }
      });

      _animationController!.forward();
    } catch (e) {
      // Fallback: move without animation
      debugPrint('Animation error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      listener: (context, state) {
        if (state is MapReady && _isMapReady) {
          // Animate camera when driver position changes
          if (_previousPosition != state.driverPosition) {
            _animateToPosition(state.cameraCenter, state.zoom);
            _previousPosition = state.driverPosition;
          }
        }
      },
      builder: (context, state) {
        if (state is MapLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MapError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(state.message),
              ],
            ),
          );
        }

        if (state is MapReady) {
          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: state.cameraCenter,
              initialZoom: state.zoom,
              minZoom: 10,
              maxZoom: 18,
              onMapReady: () {
                setState(() {
                  _isMapReady = true;
                });
              },
            ),
            children: [
              // OpenStreetMap tile layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.task',
              ),

              // Route polyline (full route - faded)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: state.fullRoute,
                    strokeWidth: 4,
                    color: AppTheme.routeColor.withOpacity(0.3),
                  ),
                ],
              ),

              // Remaining route polyline (highlighted)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: state.remainingRoute,
                    strokeWidth: 5,
                    color: AppTheme.routeColor,
                  ),
                ],
              ),

              // Markers layer
              MarkerLayer(
                markers: [
                  // Driver marker (animated)
                  Marker(
                    point: state.driverPosition,
                    width: 50,
                    height: 50,
                    child: _DriverMarker(heading: state.driverHeading),
                  ),

                  // Destination marker
                  Marker(
                    point: state.destination,
                    width: 50,
                    height: 50,
                    child: const _DestinationMarker(),
                  ),
                ],
              ),
            ],
          );
        }

        // Initial state - show placeholder
        return Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Loading map...'),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Animated driver marker widget
class _DriverMarker extends StatelessWidget {
  final double heading;

  const _DriverMarker({required this.heading});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: heading * 3.14159 / 180, // Convert to radians
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.driverMarkerColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppTheme.driverMarkerColor.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.delivery_dining,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}

/// Destination marker widget
class _DestinationMarker extends StatelessWidget {
  const _DestinationMarker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.destinationMarkerColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppTheme.destinationMarkerColor.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.location_on,
            color: Colors.white,
            size: 20,
          ),
        ),
        Container(
          width: 3,
          height: 8,
          color: AppTheme.destinationMarkerColor,
        ),
      ],
    );
  }
}
