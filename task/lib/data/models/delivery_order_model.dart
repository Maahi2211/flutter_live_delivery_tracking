import '../../domain/entities/delivery_order_entity.dart';
import 'driver_model.dart';
import 'customer_model.dart';
import 'route_point_model.dart';

/// Data model for DeliveryOrder - extends entity with JSON serialization
class DeliveryOrderModel extends DeliveryOrderEntity {
  const DeliveryOrderModel({
    required super.orderId,
    required DriverModel driver,
    required CustomerModel customer,
    required List<RoutePointModel> route,
  }) : super(driver: driver, customer: customer, route: route);

  factory DeliveryOrderModel.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderModel(
      orderId: json['orderId'] as String,
      driver: DriverModel.fromJson(json['driver'] as Map<String, dynamic>),
      customer:
          CustomerModel.fromJson(json['customer'] as Map<String, dynamic>),
      route: (json['route'] as List<dynamic>)
          .map((e) => RoutePointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'driver': (driver as DriverModel).toJson(),
      'customer': (customer as CustomerModel).toJson(),
      'route':
          route.map((e) => (e as RoutePointModel).toJson()).toList(),
    };
  }

  factory DeliveryOrderModel.fromEntity(DeliveryOrderEntity entity) {
    return DeliveryOrderModel(
      orderId: entity.orderId,
      driver: DriverModel.fromEntity(entity.driver),
      customer: CustomerModel.fromEntity(entity.customer),
      route:
          entity.route.map((e) => RoutePointModel.fromEntity(e)).toList(),
    );
  }
}

