# Flutter Live Delivery Tracking Module

A Flutter application that simulates real-time driver movement on a map for live delivery tracking. Built with **Clean Architecture (MVVM)** and **BLoC State Management**.

## 📋 Assignment Overview

This project is an Interview Assignment for **Qurinom Solutions Pvt. Ltd.** that demonstrates:
- Clean Architecture patterns (MVVM)
- BLoC state management
- Map integration (OpenStreetMap)
- UI/UX quality
- Code structure and clarity
- Real-time scenario simulation

## 🎬 Demo

The application simulates a delivery tracking experience in Hyderabad, India:
- Driver starts from pickup location
- Real-time movement along predefined route
- Status updates (picked → en_route → arriving → delivered)
- Live ETA and distance calculations
- Smooth marker animations on map

## 🏗️ Architecture

### Clean Architecture + MVVM

```
lib/
├── core/                          # Core utilities and constants
│   ├── constants/
│   │   └── app_constants.dart     # App-wide constants
│   ├── theme/
│   │   └── app_theme.dart         # Theme configuration
│   └── utils/
│       └── distance_calculator.dart # Distance & ETA calculations
│
├── data/                          # Data Layer
│   ├── datasources/
│   │   ├── mock_data_source.dart  # Mock data loading
│   │   └── mock_websocket_stream.dart # Simulated WebSocket stream
│   ├── models/
│   │   ├── customer_model.dart
│   │   ├── delivery_order_model.dart
│   │   ├── driver_model.dart
│   │   ├── location_update_model.dart
│   │   └── route_point_model.dart
│   └── repositories/
│       └── tracking_repository_impl.dart # Repository implementation
│
├── domain/                        # Domain Layer (Business Logic)
│   ├── entities/
│   │   ├── customer_entity.dart
│   │   ├── delivery_order_entity.dart
│   │   ├── driver_entity.dart
│   │   ├── location_update_entity.dart
│   │   ├── route_point_entity.dart
│   │   └── tracking_state_entity.dart
│   ├── repositories/
│   │   └── tracking_repository.dart # Abstract repository
│   └── usecases/
│       ├── calculate_eta_usecase.dart
│       ├── get_delivery_order_usecase.dart
│       ├── start_tracking_usecase.dart
│       └── stop_tracking_usecase.dart
│
├── presentation/                  # Presentation Layer (UI)
│   ├── bloc/
│   │   ├── map/
│   │   │   ├── map_bloc.dart      # Map state management
│   │   │   ├── map_event.dart
│   │   │   └── map_state.dart
│   │   └── tracking/
│   │       ├── tracking_bloc.dart # Tracking state management
│   │       ├── tracking_event.dart
│   │       └── tracking_state.dart
│   ├── screens/
│   │   └── tracking_screen.dart   # Main tracking screen
│   └── widgets/
│       ├── delivery_completed_sheet.dart
│       ├── driver_info_card.dart
│       ├── eta_distance_card.dart
│       ├── map_view.dart
│       ├── status_indicator.dart
│       └── tracking_bottom_sheet.dart
│
├── di/
│   └── injection_container.dart   # Dependency injection setup
│
└── main.dart                      # App entry point

assets/
└── mock/
    └── route_hyd.json             # Mock route data (Hyderabad)
```

### Architecture Layers Explained

#### 1. Domain Layer (Business Logic)
- **Entities**: Core business objects (Driver, Customer, DeliveryOrder, etc.)
- **Repositories**: Abstract contracts for data operations
- **Use Cases**: Single-purpose business logic units

#### 2. Data Layer
- **Models**: Data transfer objects with JSON serialization
- **Data Sources**: Mock implementations for simulated data
- **Repository Implementations**: Concrete implementations of domain contracts

#### 3. Presentation Layer (MVVM)
- **BLoCs**: State management using flutter_bloc
- **Screens**: Main UI screens (Views in MVVM)
- **Widgets**: Reusable UI components

## 🔧 State Management - BLoC

### TrackingBloc
Manages delivery tracking state.

**Events:**
- `StartTracking` - Initiates tracking session
- `UpdateLocation` - Updates driver's current location
- `UpdateStatus` - Updates delivery status
- `StopTracking` - Stops tracking session
- `ResetTracking` - Resets for replay

**States:**
- `TrackingInitial` - Before tracking starts
- `TrackingLoading` - Loading order data
- `TrackingActive` - Active tracking with real-time updates
- `TrackingCompleted` - Delivery completed
- `TrackingError` - Error state

### MapBloc
Manages map-related state.

**Events:**
- `InitializeMap` - Initialize map with route data
- `UpdateDriverMarker` - Update driver marker position (with animation)
- `MoveCameraToDriver` - Move camera to follow driver
- `UpdatePolyline` - Update route polyline
- `ShowFullRoute` - Show entire route on map
- `ResetMap` - Reset map state

**States:**
- `MapInitial` - Initial state
- `MapLoading` - Map is loading
- `MapReady` - Map ready with all markers and polylines
- `MapError` - Error state

## 📍 Simulated Live Tracking

### Mock WebSocket Stream
The application simulates real-time tracking using a mock WebSocket-like stream that emits driver location updates every **2-3 seconds**.

```dart
// Stream data emitted every 2-3 seconds
{
  "lat": 17.437462,
  "lng": 78.448288,
  "speed": 20.2,
  "heading": 90,
  "status": "picked"
}
```

### Status Simulation Logic
```dart
if (index == 0) status = "picked";
else if (index < 5) status = "en_route";
else if (index < 8) status = "arriving";
else status = "delivered";
```

## 🗺️ Map Integration

Using **flutter_map** with **OpenStreetMap** for map integration:
- Driver live moving marker with rotation (heading)
- Destination marker
- Route polyline (full route + remaining route)
- Smooth camera animation following driver
- Dynamic zoom levels

## 📱 Features

### Tracking Screen
- ✅ OpenStreetMap integration
- ✅ Driver live moving marker
- ✅ User/destination marker
- ✅ Route polyline
- ✅ Dynamic ETA and distance
- ✅ Auto-updating UI

### Bottom Sheet
- ✅ Driver name
- ✅ Vehicle information
- ✅ Delivery status (with animation)
- ✅ Live ETA
- ✅ Distance remaining
- ✅ Last updated timestamp

### Additional Features
- ✅ Status color coding
- ✅ Pulsing animation for active status
- ✅ Delivery completion celebration screen
- ✅ Replay tracking functionality
- ✅ Phone call button (simulated)

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (3.6.0 or higher)
- Dart SDK (3.6.0 or higher)
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd task
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Running on Different Platforms

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
flutter run -d ios
```

**Web:**
```bash
flutter run -d chrome
```

## 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.6      # BLoC state management
  bloc: ^8.1.4              # BLoC core
  flutter_map: ^6.1.0       # OpenStreetMap integration
  latlong2: ^0.9.1          # Coordinate handling
  equatable: ^2.0.5         # Value equality
  get_it: ^7.7.0            # Dependency injection
  intl: ^0.19.0             # Date/time formatting
```

## 🗂️ Mock Data

### Route Data (Hyderabad)
Location: `assets/mock/route_hyd.json`

```json
{
  "orderId": "ORD123456",
  "driver": {
    "id": "DR001",
    "name": "Ravi Kumar",
    "vehicle": "Honda Activa",
    "phone": "+91 9999999999"
  },
  "customer": {
    "lat": 17.424354,
    "lng": 78.473945,
    "address": "Near Necklace Road, Hyderabad"
  },
  "route": [
    { "lat": 17.437462, "lng": 78.448288, "status": "picked" },
    { "lat": 17.435180, "lng": 78.452510, "status": "en_route" },
    // ... more waypoints
    { "lat": 17.424354, "lng": 78.473945, "status": "delivered" }
  ]
}
```

## 📐 ETA & Distance Calculation

The app uses the **Haversine formula** for accurate distance calculation between coordinates:

```dart
static double calculateDistance(lat1, lng1, lat2, lng2) {
  const earthRadius = 6371; // km
  final dLat = toRadians(lat2 - lat1);
  final dLng = toRadians(lng2 - lng1);
  final a = sin(dLat/2)² + cos(lat1) * cos(lat2) * sin(dLng/2)²;
  final c = 2 * atan2(sqrt(a), sqrt(1-a));
  return earthRadius * c;
}
```

ETA is calculated based on average speed (25 km/h default).

## 🎨 Theme & Styling

- **Primary Color**: Blue (#2196F3)
- **Status Colors**:
  - Picked: Purple (#9C27B0)
  - En Route: Blue (#2196F3)
  - Arriving: Orange (#FF9800)
  - Delivered: Green (#4CAF50)
- **Material Design 3** with custom theme

## 🧪 Testing

Run tests:
```bash
flutter test
```

## 📝 Code Quality

- Follows Clean Architecture principles
- SOLID principles applied
- Comprehensive documentation
- Type-safe Dart code
- Proper error handling

## 📄 License

This project is created as an interview assignment for Qurinom Solutions Pvt. Ltd.

---

**Built with ❤️ using Flutter**
