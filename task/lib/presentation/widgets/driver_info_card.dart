import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/driver_entity.dart';

/// Widget displaying driver information
class DriverInfoCard extends StatelessWidget {
  final DriverEntity driver;

  const DriverInfoCard({
    super.key,
    required this.driver,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Driver avatar
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primaryColor,
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.person,
            color: AppTheme.primaryColor,
            size: 32,
          ),
        ),
        const SizedBox(width: 16),
        // Driver details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                driver.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.two_wheeler,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    driver.vehicle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Call button
        Container(
          decoration: BoxDecoration(
            color: AppTheme.deliveredColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              // Phone call functionality (simulated)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling ${driver.phone}...'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(
              Icons.phone,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

