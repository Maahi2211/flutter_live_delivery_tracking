import 'package:get_it/get_it.dart';
import '../data/datasources/mock_data_source.dart';
import '../data/datasources/mock_websocket_stream.dart';
import '../data/repositories/tracking_repository_impl.dart';
import '../domain/repositories/tracking_repository.dart';
import '../domain/usecases/get_delivery_order_usecase.dart';
import '../domain/usecases/start_tracking_usecase.dart';
import '../domain/usecases/stop_tracking_usecase.dart';
import '../domain/usecases/calculate_eta_usecase.dart';
import '../presentation/bloc/tracking/tracking_bloc.dart';
import '../presentation/bloc/map/map_bloc.dart';

/// Service Locator instance
final GetIt sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initDependencies() async {
  // ==================== Data Sources ====================
  // Mock WebSocket Stream (Singleton - maintains stream state)
  sl.registerLazySingleton<MockWebSocketStream>(
    () => MockWebSocketStream(),
  );

  // Mock Data Source
  sl.registerLazySingleton<MockDataSource>(
    () => MockDataSourceImpl(webSocketStream: sl()),
  );

  // ==================== Repositories ====================
  sl.registerLazySingleton<TrackingRepository>(
    () => TrackingRepositoryImpl(dataSource: sl()),
  );

  // ==================== Use Cases ====================
  sl.registerLazySingleton<GetDeliveryOrderUseCase>(
    () => GetDeliveryOrderUseCase(sl()),
  );

  sl.registerLazySingleton<StartTrackingUseCase>(
    () => StartTrackingUseCase(sl()),
  );

  sl.registerLazySingleton<StopTrackingUseCase>(
    () => StopTrackingUseCase(sl()),
  );

  sl.registerLazySingleton<CalculateETAUseCase>(
    () => CalculateETAUseCase(),
  );

  // ==================== BLoCs ====================
  // TrackingBloc - Factory (new instance for each request)
  sl.registerFactory<TrackingBloc>(
    () => TrackingBloc(
      getDeliveryOrderUseCase: sl(),
      startTrackingUseCase: sl(),
      stopTrackingUseCase: sl(),
      calculateETAUseCase: sl(),
    ),
  );

  // MapBloc - Factory
  sl.registerFactory<MapBloc>(
    () => MapBloc(),
  );
}

/// Reset dependencies (for replay functionality)
Future<void> resetDependencies() async {
  // Reset the WebSocket stream for replay
  if (sl.isRegistered<MockWebSocketStream>()) {
    sl<MockWebSocketStream>().reset();
  }
}

