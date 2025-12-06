import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'di/injection_container.dart' as di;
import 'presentation/bloc/tracking/tracking_bloc.dart';
import 'presentation/bloc/map/map_bloc.dart';
import 'presentation/screens/tracking_screen.dart';

/// Entry point of the Flutter Live Delivery Tracking Module
/// 
/// Architecture: Clean Architecture (MVVM) + BLoC State Management
/// 
/// This application simulates real-time driver movement on a map
/// with mock WebSocket-like streaming data.
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize dependencies
  await di.initDependencies();

  // Run the app
  runApp(const MyApp());
}

/// Root application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Delivery Tracking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: MultiBlocProvider(
        providers: [
          // TrackingBloc - Handles tracking state
          // Events: StartTracking, UpdateLocation, UpdateStatus, StopTracking
          BlocProvider<TrackingBloc>(
            create: (_) => di.sl<TrackingBloc>(),
          ),
          // MapBloc - Handles map state
          // Handles: Marker animation, Camera movement, Polyline updates
          BlocProvider<MapBloc>(
            create: (_) => di.sl<MapBloc>(),
          ),
        ],
        child: const TrackingScreen(),
      ),
    );
  }
}
