import 'package:equatable/equatable.dart';

/// Driver entity representing driver information
class DriverEntity extends Equatable {
  final String id;
  final String name;
  final String vehicle;
  final String phone;

  const DriverEntity({
    required this.id,
    required this.name,
    required this.vehicle,
    required this.phone,
  });

  @override
  List<Object?> get props => [id, name, vehicle, phone];
}

