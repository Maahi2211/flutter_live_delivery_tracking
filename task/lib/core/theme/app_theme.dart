import 'package:flutter/material.dart';

/// Application theme configuration
class AppTheme {
  AppTheme._();

  // Primary colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF03A9F4);
  static const Color accentColor = Color(0xFF00BCD4);

  // Status colors
  static const Color pickedColor = Color(0xFF9C27B0);
  static const Color enRouteColor = Color(0xFF2196F3);
  static const Color arrivingColor = Color(0xFFFF9800);
  static const Color deliveredColor = Color(0xFF4CAF50);

  // Background colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Colors.white;

  // Map colors
  static const Color routeColor = Color(0xFF2196F3);
  static const Color driverMarkerColor = Color(0xFF4CAF50);
  static const Color destinationMarkerColor = Color(0xFFF44336);

  /// Get color based on delivery status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'picked':
        return pickedColor;
      case 'en_route':
        return enRouteColor;
      case 'arriving':
        return arrivingColor;
      case 'delivered':
        return deliveredColor;
      default:
        return primaryColor;
    }
  }

  /// Get status display text
  static String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'picked':
        return 'Order Picked Up';
      case 'en_route':
        return 'On The Way';
      case 'arriving':
        return 'Almost There';
      case 'delivered':
        return 'Delivered';
      default:
        return 'Unknown';
    }
  }

  /// Get status icon
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'picked':
        return Icons.inventory_2;
      case 'en_route':
        return Icons.delivery_dining;
      case 'arriving':
        return Icons.near_me;
      case 'delivered':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: const CardThemeData(
        color: cardColor,
        elevation: 2,
        margin: EdgeInsets.all(8),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textLight,
        elevation: 0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
    );
  }
}

