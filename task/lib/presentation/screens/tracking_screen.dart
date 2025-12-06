import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_theme.dart';
import '../bloc/tracking/tracking_bloc.dart';
import '../bloc/tracking/tracking_event.dart';
import '../bloc/tracking/tracking_state.dart';
import '../bloc/map/map_bloc.dart';
import '../bloc/map/map_event.dart';
import '../widgets/map_view.dart';
import '../widgets/tracking_bottom_sheet.dart';
import '../widgets/delivery_completed_sheet.dart';

/// Main Tracking Screen
/// Displays map with driver movement and bottom sheet with tracking info
class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  @override
  void initState() {
    super.initState();
    // Start tracking when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrackingBloc>().add(const StartTracking());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TrackingBloc, TrackingState>(
        listener: (context, state) {
          if (state is TrackingActive) {
            // Initialize map on first location update
            if (state.currentRouteIndex == 1) {
              _initializeMap(state);
            } else {
              // Update driver marker on map
              _updateDriverMarker(state);
            }
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Map view (full screen)
              const MapView(),

              // App bar overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildAppBar(context, state),
              ),

              // Bottom sheet
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomSheet(context, state),
              ),

              // Loading overlay
              if (state is TrackingLoading)
                Container(
                  color: Colors.black45,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),

              // Error overlay
              if (state is TrackingError)
                _buildErrorOverlay(context, state),
            ],
          );
        },
      ),
    );
  }

  /// Build custom app bar with order ID
  Widget _buildAppBar(BuildContext context, TrackingState state) {
    String title = 'Live Tracking';
    if (state is TrackingActive) {
      title = 'Order ${state.order.orderId}';
    } else if (state is TrackingCompleted) {
      title = 'Order ${state.order.orderId}';
    }

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                // Back button action (simulated)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Navigation back (demo)'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black45,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => _showFullRoute(),
              icon: const Icon(Icons.fullscreen, color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  /// Build bottom sheet based on tracking state
  Widget _buildBottomSheet(BuildContext context, TrackingState state) {
    if (state is TrackingActive) {
      return TrackingBottomSheet(
        driver: state.order.driver,
        status: state.currentStatus,
        etaMinutes: state.etaMinutes,
        distanceKm: state.distanceRemaining,
        lastUpdated: state.lastUpdated,
        destinationAddress: state.order.customer.address,
      );
    }

    if (state is TrackingCompleted) {
      return DeliveryCompletedSheet(
        order: state.order,
        completedAt: state.completedAt,
        onReplayPressed: () => _replayTracking(),
      );
    }

    // Initial/Loading state - show minimal sheet
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading tracking data...'),
        ],
      ),
    );
  }

  /// Build error overlay
  Widget _buildErrorOverlay(BuildContext context, TrackingError state) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Error',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _replayTracking(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Initialize map with route data
  void _initializeMap(TrackingActive state) {
    final routePoints = state.order.route
        .map((point) => LatLng(point.lat, point.lng))
        .toList();

    final destination = LatLng(
      state.order.customer.lat,
      state.order.customer.lng,
    );

    context.read<MapBloc>().add(InitializeMap(
          routePoints: routePoints,
          destination: destination,
        ));
  }

  /// Update driver marker on map
  void _updateDriverMarker(TrackingActive state) {
    final position = LatLng(
      state.currentLocation.lat,
      state.currentLocation.lng,
    );

    context.read<MapBloc>().add(UpdateDriverMarker(
          position: position,
          heading: state.currentLocation.heading,
        ));
  }

  /// Show full route on map
  void _showFullRoute() {
    context.read<MapBloc>().add(const ShowFullRoute());
  }

  /// Replay tracking from beginning
  void _replayTracking() {
    context.read<MapBloc>().add(const ResetMap());
    context.read<TrackingBloc>().add(const ResetTracking());
  }
}

