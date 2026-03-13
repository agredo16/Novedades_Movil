import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class DocumentosUploader extends StatelessWidget {
  final List<String> archivos;
  final VoidCallback onAgregar;
  final Function(String) onEliminar;

  const DocumentosUploader({
    super.key,
    required this.archivos,
    required this.onAgregar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onAgregar,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                  color: AppColors.gray200,
                  style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                const Icon(Icons.cloud_upload_outlined,
                    color: AppColors.gray400, size: 36),
                const SizedBox(height: AppSpacing.s2),
                Text('Seleccionar archivos',
                    style: AppTypography.sm.copyWith(
                        color: AppColors.gray500)),
                const SizedBox(height: AppSpacing.s1),
                Text('o arrastra y suelta aquí',
                    style: AppTypography.xs.copyWith(
                        color: AppColors.gray400)),
                const SizedBox(height: AppSpacing.s3),
                OutlinedButton(
                  onPressed: onAgregar,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                  ),
                  child: Text('Explorar Archivos',
                      style: AppTypography.smPrimary),
                ),
              ],
            ),
          ),
        ),

        // Archivos agregados
        if (archivos.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s3),
          ...archivos.map((archivo) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.s2),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: AppSpacing.s2,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: AppColors.gray200),
            ),
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf,
                    color: AppColors.error, size: 20),
                const SizedBox(width: AppSpacing.s2),
                Expanded(
                  child: Text(archivo,
                      style: AppTypography.sm,
                      overflow: TextOverflow.ellipsis),
                ),
                Text('1.2 MB',
                    style: AppTypography.xs.copyWith(
                        color: AppColors.gray400)),
                const SizedBox(width: AppSpacing.s2),
                GestureDetector(
                  onTap: () => onEliminar(archivo),
                  child: const Icon(Icons.close,
                      color: AppColors.gray400, size: 18),
                ),
              ],
            ),
          )),
        ],
      ],
    );
  }
}