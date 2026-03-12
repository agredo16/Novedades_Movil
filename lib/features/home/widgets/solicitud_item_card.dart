import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/solicitud_model.dart';
import '../../shared/status_badge.dart';

class SolicitudItemCard extends StatelessWidget {
  final SolicitudModel solicitud;
  final bool isHighlighted;

  const SolicitudItemCard({
    super.key,
    required this.solicitud,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s2),
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isHighlighted
              ? AppColors.primary.withOpacity(0.4)
              : AppColors.gray100,
          width: isHighlighted ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Ícono
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(Icons.description_outlined,
                color: AppColors.gray500, size: 18),
          ),
          const SizedBox(width: AppSpacing.s3),

          // Contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(solicitud.titulo,
                    style: AppTypography.sm.copyWith(
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(solicitud.subtitulo,
                    style: AppTypography.xs.copyWith(
                        color: AppColors.gray500)),
                const SizedBox(height: AppSpacing.s1),
                StatusBadge(estado: solicitud.estado),
              ],
            ),
          ),

          // Tiempo y flecha
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(solicitud.tiempo,
                  style: AppTypography.xs.copyWith(
                      color: AppColors.gray400)),
              const SizedBox(height: AppSpacing.s2),
              const Icon(Icons.chevron_right,
                  color: AppColors.gray400, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}