import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/delivery_order_model.dart';
import '../models/location_update_model.dart';
import 'mock_websocket_stream.dart';

/// Mock data source for loading delivery order data
/// Reads from assets/mock/route_hyd.json
abstract class MockDataSource {
  Future<DeliveryOrderModel> getDeliveryOrder();
  Stream<LocationUpdateModel> getLocationUpdatesStream();
  void stopLocationUpdates();
  void resetTracking();
}

/// Implementation of MockDataSource
class MockDataSourceImpl implements MockDataSource {
  final MockWebSocketStream _webSocketStream;

  MockDataSourceImpl({MockWebSocketStream? webSocketStream})
      : _webSocketStream = webSocketStream ?? MockWebSocketStream();

  @override
  Future<DeliveryOrderModel> getDeliveryOrder() async {
    try {
      // Load mock data from assets
      final String jsonString =
          await rootBundle.loadString('assets/mock/route_hyd.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return DeliveryOrderModel.fromJson(jsonData);
    } catch (e) {
      // Fallback to hardcoded data if asset loading fails
      return _getFallbackDeliveryOrder();
    }
  }

  @override
  Stream<LocationUpdateModel> getLocationUpdatesStream() {
    return _webSocketStream.getStream();
  }

  @override
  void stopLocationUpdates() {
    _webSocketStream.dispose();
  }

  @override
  void resetTracking() {
    _webSocketStream.reset();
  }

  /// Fallback delivery order data (same as route_hyd.json)
  DeliveryOrderModel _getFallbackDeliveryOrder() {
    const jsonData = {
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
        {"lat": 17.437462, "lng": 78.448288, "status": "picked"},
        {"lat": 17.435180, "lng": 78.452510, "status": "en_route"},
        {"lat": 17.432785, "lng": 78.455986, "status": "en_route"},
        {"lat": 17.431122, "lng": 78.458565, "status": "en_route"},
        {"lat": 17.430290, "lng": 78.463020, "status": "en_route"},
        {"lat": 17.429390, "lng": 78.466690, "status": "en_route"},
        {"lat": 17.426620, "lng": 78.469780, "status": "arriving"},
        {"lat": 17.425280, "lng": 78.471740, "status": "arriving"},
        {"lat": 17.424354, "lng": 78.473945, "status": "delivered"}
      ]
    };
    return DeliveryOrderModel.fromJson(jsonData);
  }
}

