import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/notificacion_model.dart';

class NotificacionCard extends StatelessWidget {
  final NotificacionModel notificacion;
  final VoidCallback onTap;

  const NotificacionCard({
    super.key,
    required this.notificacion,
    required this.onTap,
  });

  IconData get _icon {
    switch (notificacion.tipo) {
      case TipoNotificacion.solicitudAprobada:  return Icons.check_circle_outline;
      case TipoNotificacion.documentoPendiente: return Icons.warning_amber_outlined;
      case TipoNotificacion.actualizacion:      return Icons.update_rounded;
      case TipoNotificacion.recordatorio:       return Icons.notifications_outlined;
    }
  }

  Color get _iconColor {
    switch (notificacion.tipo) {
      case TipoNotificacion.solicitudAprobada:  return AppColors.success;
      case TipoNotificacion.documentoPendiente: return AppColors.warning;
      case TipoNotificacion.actualizacion:      return AppColors.info;
      case TipoNotificacion.recordatorio:       return AppColors.gray500;
    }
  }

  Color get _iconBg {
    switch (notificacion.tipo) {
      case TipoNotificacion.solicitudAprobada:  return AppColors.successLight;
      case TipoNotificacion.documentoPendiente: return AppColors.warningLight;
      case TipoNotificacion.actualizacion:      return AppColors.infoLight;
      case TipoNotificacion.recordatorio:       return AppColors.gray100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.s2),
        padding: const EdgeInsets.all(AppSpacing.s3),
        decoration: BoxDecoration(
          color: notificacion.leida ? AppColors.white : AppColors.infoLight.withOpacity(0.4),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: notificacion.leida ? AppColors.gray100 : AppColors.info.withOpacity(0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícono
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: _iconBg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Icon(_icon, color: _iconColor, size: 20),
            ),
            const SizedBox(width: AppSpacing.s3),

            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(notificacion.titulo,
                            style: AppTypography.sm.copyWith(
                              fontWeight: FontWeight.w700,
                              color: notificacion.leida
                                  ? AppColors.gray700
                                  : AppColors.gray900,
                            )),
                      ),
                      if (!notificacion.leida)
                        Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(notificacion.descripcion,
                      style: AppTypography.xs.copyWith(
                          color: AppColors.gray500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: AppSpacing.s1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.gray100,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(notificacion.categoria,
                            style: AppTypography.xs.copyWith(
                                color: AppColors.gray600 ?? AppColors.gray500)),
                      ),
                      Text(notificacion.tiempo,
                          style: AppTypography.xs.copyWith(
                              color: AppColors.gray400)),
                    ],
                  ),
                ],
              ),
            ),

            // Menú
            const Icon(Icons.more_vert,
                color: AppColors.gray400, size: 18),
          ],
        ),
      ),
    );
  }
}