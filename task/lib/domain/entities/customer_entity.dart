import 'package:equatable/equatable.dart';

/// Customer entity representing destination information
class CustomerEntity extends Equatable {
  final double lat;
  final double lng;
  final String address;

  const CustomerEntity({
    required this.lat,
    required this.lng,
    required this.address,
  });

  @override
  List<Object?> get props => [lat, lng, address];
}

