import '../../domain/entities/location_update_entity.dart';

/// Data model for LocationUpdate - extends entity with JSON serialization
/// Used for simulated WebSocket stream data
class LocationUpdateModel extends LocationUpdateEntity {
  const LocationUpdateModel({
    required super.lat,
    required super.lng,
    required super.speed,
    required super.heading,
    required super.status,
    required super.timestamp,
  });

  factory LocationUpdateModel.fromJson(Map<String, dynamic> json) {
    return LocationUpdateModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      heading: (json['heading'] as num).toDouble(),
      status: json['status'] as String,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'speed': speed,
      'heading': heading,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory LocationUpdateModel.fromEntity(LocationUpdateEntity entity) {
    return LocationUpdateModel(
      lat: entity.lat,
      lng: entity.lng,
      speed: entity.speed,
      heading: entity.heading,
      status: entity.status,
      timestamp: entity.timestamp,
    );
  }

  /// Create from simulated stream data (without timestamp)
  factory LocationUpdateModel.fromStreamData(Map<String, dynamic> json) {
    return LocationUpdateModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      heading: (json['heading'] as num).toDouble(),
      status: json['status'] as String,
      timestamp: DateTime.now(),
    );
  }
}

