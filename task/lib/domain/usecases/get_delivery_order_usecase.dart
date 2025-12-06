import '../entities/delivery_order_entity.dart';
import '../repositories/tracking_repository.dart';

/// Use case for getting delivery order information
class GetDeliveryOrderUseCase {
  final TrackingRepository repository;

  GetDeliveryOrderUseCase(this.repository);

  Future<DeliveryOrderEntity> call() async {
    return await repository.getDeliveryOrder();
  }
}

