import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/solicitud_model.dart';
import '../../shared/status_badge.dart';

class HistorialItemCard extends StatelessWidget {
  final SolicitudModel solicitud;

  const HistorialItemCard({super.key, required this.solicitud});

  IconData get _icon {
    switch (solicitud.estado) {
      case EstadoSolicitud.aprobado:   return Icons.swap_horiz_rounded;
      case EstadoSolicitud.rechazado:  return Icons.cancel_outlined;
      case EstadoSolicitud.pendiente:  return Icons.add_circle_outline;
      case EstadoSolicitud.enProceso:  return Icons.hourglass_empty_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s2),
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.gray100),
      ),
      child: Row(
        children: [
          // Ícono
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(_icon, color: AppColors.gray500, size: 20),
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
                        color: AppColors.gray400)),
                const SizedBox(height: AppSpacing.s1),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 11, color: AppColors.gray400),
                    const SizedBox(width: 3),
                    Text(solicitud.tiempo,
                        style: AppTypography.xs.copyWith(
                            color: AppColors.gray400)),
                  ],
                ),
              ],
            ),
          ),

          // Status + flecha
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StatusBadge(estado: solicitud.estado),
              const SizedBox(height: AppSpacing.s2),
              Text('Ver detalle',
                  style: AppTypography.xs.copyWith(
                      color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }
}