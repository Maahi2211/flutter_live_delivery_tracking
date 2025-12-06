import 'dart:async';
import '../../core/constants/app_constants.dart';
import '../models/location_update_model.dart';

/// Mock WebSocket-like Stream that simulates real-time driver location updates
/// Emits data every 2-3 seconds as per assignment requirement
class MockWebSocketStream {
  StreamController<LocationUpdateModel>? _controller;
  Timer? _timer;
  int _currentIndex = 0;
  bool _isRunning = false;

  /// Simulated WebSocket Stream Data (Hyderabad Route)
  /// As specified in the assignment requirements
  static const List<Map<String, dynamic>> _streamData = [
    {
      "lat": 17.437462,
      "lng": 78.448288,
      "speed": 20.2,
      "heading": 90,
      "status": "picked"
    },
    {
      "lat": 17.435180,
      "lng": 78.452510,
      "speed": 25.1,
      "heading": 100,
      "status": "en_route"
    },
    {
      "lat": 17.432785,
      "lng": 78.455986,
      "speed": 27.0,
      "heading": 110,
      "status": "en_route"
    },
    {
      "lat": 17.431122,
      "lng": 78.458565,
      "speed": 29.5,
      "heading": 115,
      "status": "en_route"
    },
    {
      "lat": 17.430290,
      "lng": 78.463020,
      "speed": 31.0,
      "heading": 120,
      "status": "en_route"
    },
    {
      "lat": 17.429390,
      "lng": 78.466690,
      "speed": 26.8,
      "heading": 130,
      "status": "en_route"
    },
    {
      "lat": 17.426620,
      "lng": 78.469780,
      "speed": 18.4,
      "heading": 140,
      "status": "arriving"
    },
    {
      "lat": 17.425280,
      "lng": 78.471740,
      "speed": 15.2,
      "heading": 150,
      "status": "arriving"
    },
    {
      "lat": 17.424354,
      "lng": 78.473945,
      "speed": 0.0,
      "heading": 160,
      "status": "delivered"
    },
  ];

  /// Get the simulated location updates stream
  /// Emits location updates every 2-3 seconds
  Stream<LocationUpdateModel> getStream() {
    // Clean up any existing stream first
    _stop();
    _controller?.close();
    
    // Reset index for fresh start
    _currentIndex = 0;
    _isRunning = false;
    
    // Create new controller
    _controller = StreamController<LocationUpdateModel>.broadcast();
    
    // Start emitting
    _start();
    
    return _controller!.stream;
  }

  /// Start emitting location updates
  void _start() {
    if (_isRunning) return;
    _isRunning = true;

    // Emit first location after a short delay to let UI initialize
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_isRunning) {
        _emitLocation();
        
        // Then emit every 2-3 seconds
        _timer = Timer.periodic(AppConstants.streamInterval, (_) {
          _emitLocation();
        });
      }
    });
  }

  /// Emit current location and move to next
  void _emitLocation() {
    if (_controller == null || _controller!.isClosed || !_isRunning) return;

    if (_currentIndex < _streamData.length) {
      final data = _streamData[_currentIndex];

      // Apply status simulation logic as per assignment
      final status = _getSimulatedStatus(_currentIndex);

      final locationUpdate = LocationUpdateModel.fromStreamData({
        ...data,
        'status': status,
      });

      _controller!.add(locationUpdate);
      _currentIndex++;

      // Stop after delivering (last point)
      if (_currentIndex >= _streamData.length) {
        // Don't close the controller, just stop the timer
        _timer?.cancel();
        _timer = null;
        _isRunning = false;
      }
    }
  }

  /// Status Simulation Logic as per assignment requirement
  /// if (index == 0) status = "picked";
  /// else if (index < 5) status = "en_route";
  /// else if (index < 8) status = "arriving";
  /// else status = "delivered";
  String _getSimulatedStatus(int index) {
    if (index == 0) {
      return AppConstants.statusPicked;
    } else if (index < 5) {
      return AppConstants.statusEnRoute;
    } else if (index < 8) {
      return AppConstants.statusArriving;
    } else {
      return AppConstants.statusDelivered;
    }
  }

  /// Stop the stream
  void _stop() {
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
  }

  /// Close and clean up resources
  void dispose() {
    _stop();
    _controller?.close();
    _controller = null;
  }

  /// Reset to initial state for replay
  void reset() {
    _stop();
    _controller?.close();
    _controller = null;
    _currentIndex = 0;
  }

  /// Check if stream is currently running
  bool get isRunning => _isRunning;

  /// Get current progress (0.0 to 1.0)
  double get progress =>
      _streamData.isEmpty ? 0 : _currentIndex / _streamData.length;

  /// Get total number of waypoints
  int get totalWaypoints => _streamData.length;

  /// Get current waypoint index
  int get currentIndex => _currentIndex;
}
