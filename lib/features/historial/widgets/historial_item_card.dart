import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/historial_model.dart';
import '../../shared/solicitud_detalle_sheet.dart';

class HistorialItemCard extends StatelessWidget {
  final HistorialSolicitudModel solicitud;

  const HistorialItemCard({super.key, required this.solicitud});

  Color get _estadoColor {
    switch (solicitud.estadoVisual) {
      case EstadoVisual.aprobado:  return AppColors.success;
      case EstadoVisual.rechazado: return AppColors.error;
      case EstadoVisual.pendiente: return AppColors.warning;
      case EstadoVisual.enProceso: return AppColors.info;
    }
  }

  Color get _estadoBg {
    switch (solicitud.estadoVisual) {
      case EstadoVisual.aprobado:  return AppColors.successLight;
      case EstadoVisual.rechazado: return AppColors.errorLight;
      case EstadoVisual.pendiente: return AppColors.warningLight;
      case EstadoVisual.enProceso: return AppColors.infoLight;
    }
  }

  IconData get _tipoIcon {
    switch (solicitud.tipoSolicitud) {
      case 'ADICION':        return Icons.add_circle_outline_rounded;
      case 'CAMBIO_JORNADA': return Icons.schedule_rounded;
      case 'CAMBIO_CURSO':   return Icons.swap_horiz_rounded;
      case 'CURSO_DIRIGIDO': return Icons.menu_book_rounded;
      default:               return Icons.description_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SolicitudDetalleSheet.show(context, solicitud),  // ← abre modal
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.s3),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.gray100),
          boxShadow: [
            BoxShadow(
              color: AppColors.gray200.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s3),
              child: Row(
                children: [
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Icon(_tipoIcon,
                        color: AppColors.gray600, size: 22),
                  ),
                  const SizedBox(width: AppSpacing.s3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(solicitud.tipoLabel,
                            style: AppTypography.sm.copyWith(
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(solicitud.codigoSolicitud,
                            style: AppTypography.xs.copyWith(
                                color: AppColors.gray500)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _estadoBg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(solicitud.estado,
                            style: AppTypography.xs.copyWith(
                              color: _estadoColor,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      const SizedBox(height: 4),
                      const Icon(Icons.chevron_right,
                          color: AppColors.gray400, size: 18),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.gray100),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s3,
                vertical: AppSpacing.s2,
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 12, color: AppColors.gray400),
                  const SizedBox(width: 4),
                  Text(
                    '${solicitud.createdAt.day} ${_mes(solicitud.createdAt.month)}, ${solicitud.createdAt.year}',
                    style: AppTypography.xs.copyWith(
                        color: AppColors.gray400)),
                  const Spacer(),
                  const Icon(Icons.school_outlined,
                      size: 12, color: AppColors.gray400),
                  const SizedBox(width: 4),
                  Text(solicitud.periodoAcademico,
                      style: AppTypography.xs.copyWith(
                          color: AppColors.gray400)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _mes(int mes) {
    const meses = [
      '', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return meses[mes];
  }
}