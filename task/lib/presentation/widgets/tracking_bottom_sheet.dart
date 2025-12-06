import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/driver_entity.dart';
import 'driver_info_card.dart';
import 'status_indicator.dart';
import 'eta_distance_card.dart';

/// Bottom sheet widget displaying tracking information
/// Shows: Driver name, Vehicle, Delivery status, Live ETA, Distance remaining, Last updated timestamp
class TrackingBottomSheet extends StatelessWidget {
  final DriverEntity driver;
  final String status;
  final int etaMinutes;
  final double distanceKm;
  final DateTime lastUpdated;
  final String destinationAddress;
  final VoidCallback? onReplayPressed;
  final bool showReplayButton;

  const TrackingBottomSheet({
    super.key,
    required this.driver,
    required this.status,
    required this.etaMinutes,
    required this.distanceKm,
    required this.lastUpdated,
    required this.destinationAddress,
    this.onReplayPressed,
    this.showReplayButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status indicator
                Center(child: StatusIndicator(status: status)),
                const SizedBox(height: 20),

                // Driver info
                DriverInfoCard(driver: driver),
                const SizedBox(height: 20),

                // Divider
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 12),

                // ETA and Distance
                ETADistanceCard(
                  etaMinutes: etaMinutes,
                  distanceKm: distanceKm,
                ),
                const SizedBox(height: 12),

                // Divider
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 12),

                // Destination
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.destinationMarkerColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: AppTheme.destinationMarkerColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delivering to',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            destinationAddress,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Last updated timestamp
                Center(
                  child: Text(
                    'Last updated: ${_formatTimestamp(lastUpdated)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),

                // Replay button (shown after delivery)
                if (showReplayButton) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onReplayPressed,
                      icon: const Icon(Icons.replay),
                      label: const Text('Replay Tracking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('hh:mm:ss a').format(timestamp);
  }
}

