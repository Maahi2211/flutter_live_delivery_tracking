import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/delivery_order_entity.dart';
import '../../../domain/entities/location_update_entity.dart';
import '../../../domain/usecases/get_delivery_order_usecase.dart';
import '../../../domain/usecases/start_tracking_usecase.dart';
import '../../../domain/usecases/stop_tracking_usecase.dart';
import '../../../domain/usecases/calculate_eta_usecase.dart';
import 'tracking_event.dart';
import 'tracking_state.dart';

/// TrackingBloc - Manages delivery tracking state
/// Handles: StartTracking, UpdateLocation, UpdateStatus, StopTracking
class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final GetDeliveryOrderUseCase getDeliveryOrderUseCase;
  final StartTrackingUseCase startTrackingUseCase;
  final StopTrackingUseCase stopTrackingUseCase;
  final CalculateETAUseCase calculateETAUseCase;

  StreamSubscription<LocationUpdateEntity>? _locationSubscription;
  DeliveryOrderEntity? _currentOrder;
  int _currentRouteIndex = 0;

  TrackingBloc({
    required this.getDeliveryOrderUseCase,
    required this.startTrackingUseCase,
    required this.stopTrackingUseCase,
    required this.calculateETAUseCase,
  }) : super(const TrackingInitial()) {
    on<StartTracking>(_onStartTracking);
    on<UpdateLocation>(_onUpdateLocation);
    on<UpdateStatus>(_onUpdateStatus);
    on<StopTracking>(_onStopTracking);
    on<ResetTracking>(_onResetTracking);
  }

  /// Handle StartTracking event
  Future<void> _onStartTracking(
    StartTracking event,
    Emitter<TrackingState> emit,
  ) async {
    emit(const TrackingLoading());

    try {
      // Get delivery order data
      _currentOrder = await getDeliveryOrderUseCase();
      _currentRouteIndex = 0;

      // Start listening to location updates stream
      _locationSubscription?.cancel();
      _locationSubscription = startTrackingUseCase().listen(
        (location) => add(UpdateLocation(location)),
        onError: (error) => add(const StopTracking()),
        onDone: () {
          // Stream completed - delivery finished
          if (_currentOrder != null) {
            add(const UpdateStatus(AppConstants.statusDelivered));
          }
        },
      );
    } catch (e) {
      emit(TrackingError('Failed to start tracking: ${e.toString()}'));
    }
  }

  /// Handle UpdateLocation event
  void _onUpdateLocation(
    UpdateLocation event,
    Emitter<TrackingState> emit,
  ) {
    if (_currentOrder == null) return;

    final location = event.location;
    _currentRouteIndex++;

    // Calculate distance to destination
    final distanceKm = calculateETAUseCase.calculateDistance(
      location.lat,
      location.lng,
      _currentOrder!.customer.lat,
      _currentOrder!.customer.lng,
    );

    // Calculate ETA
    final etaMinutes = calculateETAUseCase.calculateETA(distanceKm);

    // Check if delivered
    if (location.status == AppConstants.statusDelivered) {
      emit(TrackingCompleted(
        order: _currentOrder!,
        completedAt: DateTime.now(),
      ));
      _locationSubscription?.cancel();
      return;
    }

    emit(TrackingActive(
      order: _currentOrder!,
      currentLocation: location,
      distanceRemaining: distanceKm,
      etaMinutes: etaMinutes,
      currentStatus: location.status,
      currentRouteIndex: _currentRouteIndex,
      lastUpdated: location.timestamp,
    ));
  }

  /// Handle UpdateStatus event
  void _onUpdateStatus(
    UpdateStatus event,
    Emitter<TrackingState> emit,
  ) {
    final currentState = state;

    if (event.status == AppConstants.statusDelivered) {
      if (_currentOrder != null) {
        emit(TrackingCompleted(
          order: _currentOrder!,
          completedAt: DateTime.now(),
        ));
      }
      return;
    }

    if (currentState is TrackingActive) {
      emit(currentState.copyWith(
        currentStatus: event.status,
        lastUpdated: DateTime.now(),
      ));
    }
  }

  /// Handle StopTracking event
  void _onStopTracking(
    StopTracking event,
    Emitter<TrackingState> emit,
  ) {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    stopTrackingUseCase();
    emit(const TrackingInitial());
  }

  /// Handle ResetTracking event (for replay)
  Future<void> _onResetTracking(
    ResetTracking event,
    Emitter<TrackingState> emit,
  ) async {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _currentRouteIndex = 0;
    emit(const TrackingInitial());

    // Auto-restart tracking
    add(const StartTracking());
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    stopTrackingUseCase();
    return super.close();
  }
}

