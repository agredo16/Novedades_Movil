import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/solicitud_model.dart';

class TipoSolicitudGrid extends StatelessWidget {
  final TipoSolicitud? seleccionado;
  final Function(TipoSolicitud) onSelect;

  const TipoSolicitudGrid({
    super.key,
    required this.seleccionado,
    required this.onSelect,
  });

  static const _tipos = TipoSolicitud.values;

  static IconData _getIcon(TipoSolicitud tipo) {
    switch (tipo) {
      case TipoSolicitud.cambioCurso:   return Icons.swap_horiz_rounded;
      case TipoSolicitud.cambioJornada: return Icons.schedule_rounded;
      case TipoSolicitud.cursoDirigido: return Icons.menu_book_rounded;
      case TipoSolicitud.adicionCurso:  return Icons.add_circle_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.s3,
      mainAxisSpacing: AppSpacing.s3,
      childAspectRatio: 1.3,
      children: _tipos.map((tipo) {
        final isSelected = seleccionado == tipo;
        return GestureDetector(
          onTap: () => onSelect(tipo),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(AppSpacing.s3),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.08)
                  : AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.gray200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.gray100,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Icon(_getIcon(tipo),
                          color: isSelected
                              ? AppColors.white
                              : AppColors.gray500,
                          size: 18),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.primary, size: 18),
                  ],
                ),
                const Spacer(),
                Text(tipo.label,
                    style: AppTypography.sm.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.gray900,
                    )),
                const SizedBox(height: 2),
                Text(tipo.description,
                    style: AppTypography.xs.copyWith(
                        color: AppColors.gray500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}