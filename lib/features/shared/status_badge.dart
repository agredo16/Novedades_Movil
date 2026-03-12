import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../data/models/solicitud_model.dart';

class StatusBadge extends StatelessWidget {
  final EstadoSolicitud estado;

  const StatusBadge({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: config['bg'] as Color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        config['label'] as String,
        style: AppTypography.xs.copyWith(
          color: config['color'] as Color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Map<String, dynamic> _getConfig() {
    switch (estado) {
      case EstadoSolicitud.aprobado:
        return {'label': 'Aprobado', 'color': AppColors.success,
            'bg': AppColors.successLight};
      case EstadoSolicitud.rechazado:
        return {'label': 'Rechazado', 'color': AppColors.error,
            'bg': AppColors.errorLight};
      case EstadoSolicitud.enProceso:
        return {'label': 'Procesando', 'color': AppColors.info,
            'bg': AppColors.infoLight};
      case EstadoSolicitud.pendiente:
        return {'label': 'Pendiente', 'color': AppColors.warning,
            'bg': AppColors.warningLight};
    }
  }
}