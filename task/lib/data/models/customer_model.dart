import '../../domain/entities/customer_entity.dart';

/// Data model for Customer - extends entity with JSON serialization
class CustomerModel extends CustomerEntity {
  const CustomerModel({
    required super.lat,
    required super.lng,
    required super.address,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'address': address,
    };
  }

  factory CustomerModel.fromEntity(CustomerEntity entity) {
    return CustomerModel(
      lat: entity.lat,
      lng: entity.lng,
      address: entity.address,
    );
  }
}

