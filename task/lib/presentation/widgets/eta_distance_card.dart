import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/distance_calculator.dart';

/// Widget displaying ETA and distance information
class ETADistanceCard extends StatelessWidget {
  final int etaMinutes;
  final double distanceKm;

  const ETADistanceCard({
    super.key,
    required this.etaMinutes,
    required this.distanceKm,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoTile(
            icon: Icons.access_time_filled,
            iconColor: AppTheme.primaryColor,
            label: 'ETA',
            value: DistanceCalculator.formatETA(etaMinutes),
          ),
        ),
        Container(
          width: 1,
          height: 50,
          color: Colors.grey.shade300,
        ),
        Expanded(
          child: _InfoTile(
            icon: Icons.route,
            iconColor: AppTheme.accentColor,
            label: 'Distance',
            value: DistanceCalculator.formatDistance(distanceKm),
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

