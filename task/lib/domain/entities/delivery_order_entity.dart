import 'package:equatable/equatable.dart';
import 'driver_entity.dart';
import 'customer_entity.dart';
import 'route_point_entity.dart';

/// Delivery order entity containing all order information
class DeliveryOrderEntity extends Equatable {
  final String orderId;
  final DriverEntity driver;
  final CustomerEntity customer;
  final List<RoutePointEntity> route;

  const DeliveryOrderEntity({
    required this.orderId,
    required this.driver,
    required this.customer,
    required this.route,
  });

  @override
  List<Object?> get props => [orderId, driver, customer, route];
}

