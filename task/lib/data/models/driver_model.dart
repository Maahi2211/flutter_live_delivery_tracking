import '../../domain/entities/driver_entity.dart';

/// Data model for Driver - extends entity with JSON serialization
class DriverModel extends DriverEntity {
  const DriverModel({
    required super.id,
    required super.name,
    required super.vehicle,
    required super.phone,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] as String,
      name: json['name'] as String,
      vehicle: json['vehicle'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'vehicle': vehicle,
      'phone': phone,
    };
  }

  factory DriverModel.fromEntity(DriverEntity entity) {
    return DriverModel(
      id: entity.id,
      name: entity.name,
      vehicle: entity.vehicle,
      phone: entity.phone,
    );
  }
}

