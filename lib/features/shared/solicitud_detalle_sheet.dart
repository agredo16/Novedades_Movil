import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/historial_model.dart';

class SolicitudDetalleSheet extends StatelessWidget {
  final HistorialSolicitudModel solicitud;

  const SolicitudDetalleSheet({
    super.key,
    required this.solicitud,
  });

  // Función estática para mostrar el sheet
  static void show(
      BuildContext context, HistorialSolicitudModel solicitud) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SolicitudDetalleSheet(solicitud: solicitud),
    );
  }

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

  IconData get _estadoIcon {
    switch (solicitud.estadoVisual) {
      case EstadoVisual.aprobado:  return Icons.check_circle_rounded;
      case EstadoVisual.rechazado: return Icons.cancel_rounded;
      case EstadoVisual.pendiente: return Icons.schedule_rounded;
      case EstadoVisual.enProceso: return Icons.hourglass_empty_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fecha = DateFormat('dd MMM yyyy · hh:mm a', 'es')
        .format(solicitud.createdAt);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ── Handle ───────────────────────────────
            const SizedBox(height: AppSpacing.s3),
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray200,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s4),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Header ────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(solicitud.tipoLabel,
                                style: AppTypography.xl.copyWith(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(solicitud.codigoSolicitud,
                                style: AppTypography.sm.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      // Badge estado
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _estadoBg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: [
                            Icon(_estadoIcon,
                                color: _estadoColor, size: 14),
                            const SizedBox(width: 4),
                            Text(solicitud.estado,
                                style: AppTypography.xs.copyWith(
                                  color: _estadoColor,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.s4),
                  Divider(color: AppColors.gray100),
                  const SizedBox(height: AppSpacing.s4),

                  // ── Info general ──────────────────
                  _buildSeccion('Información General'),
                  const SizedBox(height: AppSpacing.s3),
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    'Fecha de registro',
                    fecha,
                  ),
                  _buildInfoRow(
                    Icons.school_outlined,
                    'Periodo académico',
                    solicitud.periodoAcademico,
                  ),

                  const SizedBox(height: AppSpacing.s4),

                  // ── Justificación ─────────────────
                  _buildSeccion('Justificación'),
                  const SizedBox(height: AppSpacing.s3),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.s3),
                    decoration: BoxDecoration(
                      color: AppColors.gray50,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: AppColors.gray100),
                    ),
                    child: Text(
                      solicitud.justificacion,
                      style: AppTypography.sm.copyWith(
                          color: AppColors.gray700),
                    ),
                  ),

                  // ── Validaciones ──────────────────
                  if (solicitud.validaciones.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.s4),
                    _buildSeccion('Validaciones Realizadas'),
                    const SizedBox(height: AppSpacing.s3),
                    ...solicitud.validaciones.map((v) => Padding(
                      padding: const EdgeInsets.only(
                          bottom: AppSpacing.s2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 22, height: 22,
                            decoration: BoxDecoration(
                              color: v.resultado
                                  ? AppColors.successLight
                                  : AppColors.errorLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              v.resultado
                                  ? Icons.check_rounded
                                  : Icons.close_rounded,
                              color: v.resultado
                                  ? AppColors.success
                                  : AppColors.error,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s2),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(v.detalle,
                                    style: AppTypography.sm.copyWith(
                                        color: AppColors.gray700)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],

                  const SizedBox(height: AppSpacing.s5),

                  // ── Botón cerrar ──────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.s5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccion(String titulo) {
    return Row(
      children: [
        Container(
          width: 3, height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: AppSpacing.s2),
        Text(titulo,
            style: AppTypography.base.copyWith(
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s3),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.gray400),
          const SizedBox(width: AppSpacing.s3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTypography.xs.copyWith(
                      color: AppColors.gray400)),
              Text(value,
                  style: AppTypography.sm.copyWith(
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}