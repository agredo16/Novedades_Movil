import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/grupo_model.dart';

class GrupoSelector extends StatelessWidget {
  final List<GrupoModel> grupos;
  final int? grupoSeleccionadoId;
  final Function(GrupoModel) onSelect;
  final bool isLoading;

  const GrupoSelector({
    super.key,
    required this.grupos,
    required this.grupoSeleccionadoId,
    required this.onSelect,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: AppColors.gray200),
        ),
        child: const Center(
          child: SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.primary),
          ),
        ),
      );
    }

    if (grupos.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.s3),
        decoration: BoxDecoration(
          color: AppColors.warningLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
              color: AppColors.warning.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_outlined,
                color: AppColors.warning, size: 16),
            const SizedBox(width: AppSpacing.s2),
            Text('No hay grupos disponibles',
                style: AppTypography.sm.copyWith(
                    color: AppColors.warning)),
          ],
        ),
      );
    }

    return Column(
      children: grupos.map((grupo) {
        final isSelected = grupoSeleccionadoId == grupo.id;
        return GestureDetector(
          onTap: grupo.tieneCupos ? () => onSelect(grupo) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: AppSpacing.s2),
            padding: const EdgeInsets.all(AppSpacing.s3),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.08)
                  : grupo.tieneCupos
                      ? AppColors.white
                      : AppColors.gray50,
              borderRadius:
                  BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.gray200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Ícono
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.gray100,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(Icons.class_outlined,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.gray500,
                      size: 20),
                ),
                const SizedBox(width: AppSpacing.s3),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(grupo.nombreCurso,
                          style: AppTypography.sm.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.gray900,
                          )),
                      const SizedBox(height: 2),
                      Text(
                        '${grupo.codigoGrupo} · ${grupo.jornadaLabel} · ${grupo.diaSemana}',
                        style: AppTypography.xs.copyWith(
                            color: AppColors.gray500),
                      ),
                      Text(
                        '${grupo._formatHora(grupo.horaInicio)} - ${grupo._formatHora(grupo.horaFin)} · ${grupo.docente}',
                        style: AppTypography.xs.copyWith(
                            color: AppColors.gray500),
                      ),
                    ],
                  ),
                ),

                // Cupos
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.primary, size: 20),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: grupo.tieneCupos
                            ? AppColors.successLight
                            : AppColors.errorLight,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        grupo.tieneCupos
                            ? '${grupo.cuposDisponibles} cupos'
                            : 'Sin cupos',
                        style: AppTypography.xs.copyWith(
                          color: grupo.tieneCupos
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Extensión privada para acceder a _formatHora desde el widget
extension on GrupoModel {
  String _formatHora(String hora) {
    try {
      final partes = hora.split(':');
      int h = int.parse(partes[0]);
      final m = partes[1];
      final ampm = h >= 12 ? 'PM' : 'AM';
      if (h > 12) h -= 12;
      if (h == 0) h = 12;
      return '$h:$m $ampm';
    } catch (_) {
      return hora;
    }
  }
}