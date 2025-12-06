import '../../domain/entities/route_point_entity.dart';

/// Data model for RoutePoint - extends entity with JSON serialization
class RoutePointModel extends RoutePointEntity {
  const RoutePointModel({
    required super.lat,
    required super.lng,
    required super.status,
  });

  factory RoutePointModel.fromJson(Map<String, dynamic> json) {
    return RoutePointModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'status': status,
    };
  }

  factory RoutePointModel.fromEntity(RoutePointEntity entity) {
    return RoutePointModel(
      lat: entity.lat,
      lng: entity.lng,
      status: entity.status,
    );
  }
}

