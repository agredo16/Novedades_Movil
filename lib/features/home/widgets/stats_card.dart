import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class StatsCard extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  final bool hasError;

  const StatsCard({
    super.key,
    required this.count,
    required this.label,
    required this.color,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s3,
          horizontal: AppSpacing.s2,
        ),
        decoration: BoxDecoration(
          color: hasError ? AppColors.errorLight : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: hasError ? AppColors.error.withOpacity(0.3)
                : AppColors.gray100,
          ),
        ),
        child: Column(
          children: [
            hasError
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel_outlined,
                          color: AppColors.error, size: 16),
                      const SizedBox(width: 4),
                      Text('$count',
                          style: AppTypography.lg.copyWith(
                              color: AppColors.error)),
                    ],
                  )
                : Text('$count', style: AppTypography.lg.copyWith(
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: AppTypography.xs.copyWith(color: AppColors.gray500),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}