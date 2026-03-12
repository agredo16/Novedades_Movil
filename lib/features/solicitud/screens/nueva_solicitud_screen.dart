import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/solicitud_provider.dart';
import '../widgets/step_indicator.dart';
import '../widgets/tipo_solicitud_grid.dart';
import '../widgets/documentos_uploader.dart';

class NuevaSolicitudScreen extends ConsumerStatefulWidget {
  const NuevaSolicitudScreen({super.key});

  @override
  ConsumerState<NuevaSolicitudScreen> createState() =>
      _NuevaSolicitudScreenState();
}

class _NuevaSolicitudScreenState
    extends ConsumerState<NuevaSolicitudScreen> {
  final _asuntoController = TextEditingController();
  final _justificacionController = TextEditingController();

  @override
  void dispose() {
    _asuntoController.dispose();
    _justificacionController.dispose();
    super.dispose();
  }

  void _enviar() {
    ref.read(nuevaSolicitudProvider.notifier).reset();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: const Icon(Icons.check_rounded,
                  color: AppColors.success, size: 32),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text('¡Solicitud Enviada!',
                style: AppTypography.lg),
            const SizedBox(height: AppSpacing.s2),
            Text('Tu solicitud ha sido enviada exitosamente.',
                style: AppTypography.smGray,
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/home');
              },
              child: const Text('Ir al Inicio'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(nuevaSolicitudProvider);
    final notifier = ref.read(nuevaSolicitudProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.gray700, size: 20),
          onPressed: () => context.go('/home'),
        ),
        title: Text('Nueva Solicitud', style: AppTypography.lg),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Step Indicator ───────────────────────────
            StepIndicator(totalSteps: 3, currentStep: 0),
            const SizedBox(height: AppSpacing.s4),

            // ── Info banner ──────────────────────────────
            Container(
              padding: const EdgeInsets.all(AppSpacing.s3),
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(
                    color: AppColors.info.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppColors.info, size: 16),
                  const SizedBox(width: AppSpacing.s2),
                  Expanded(
                    child: Text(
                      'Completa todos los campos marcados para asegurar el procesamiento de tu trámite académico.',
                      style: AppTypography.xs.copyWith(
                          color: AppColors.info),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.s5),

            // ── Tipo de Solicitud ────────────────────────
            Row(
              children: [
                const Icon(Icons.grid_view_rounded,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: AppSpacing.s2),
                Text('Tipo de Solicitud', style: AppTypography.baseBold),
              ],
            ),
            const SizedBox(height: AppSpacing.s3),
            TipoSolicitudGrid(
              seleccionado: state.tipoSeleccionado,
              onSelect: notifier.seleccionarTipo,
            ),

            const SizedBox(height: AppSpacing.s5),

            // ── Justificación ────────────────────────────
            Row(
              children: [
                const Icon(Icons.description_outlined,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: AppSpacing.s2),
                Text('Justificación y Detalles',
                    style: AppTypography.baseBold),
              ],
            ),
            const SizedBox(height: AppSpacing.s3),

            // Asunto
            Text('Asunto de la solicitud *',
                style: AppTypography.sm.copyWith(
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.s2),
            TextField(
              controller: _asuntoController,
              onChanged: notifier.setAsunto,
              decoration: const InputDecoration(
                hintText: 'Ej: Cambio de sección Cálculo I',
              ),
            ),

            const SizedBox(height: AppSpacing.s3),

            // Justificación
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Justificación detallada *',
                    style: AppTypography.sm.copyWith(
                        fontWeight: FontWeight.w600)),
                Text('Mín. 50 caracteres',
                    style: AppTypography.xs.copyWith(
                        color: AppColors.gray400)),
              ],
            ),
            const SizedBox(height: AppSpacing.s2),
            TextField(
              controller: _justificacionController,
              onChanged: notifier.setJustificacion,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Explica los motivos académicos o laborales para tu solicitud...',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: AppSpacing.s5),

            // ── Documentos ───────────────────────────────
            Row(
              children: [
                const Icon(Icons.attach_file_rounded,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: AppSpacing.s2),
                Text('Documentos de Soporte',
                    style: AppTypography.baseBold),
              ],
            ),
            const SizedBox(height: AppSpacing.s1),
            Text('Adjunta archivos en formato PDF o imágenes (máx. 5MB)',
                style: AppTypography.xs.copyWith(
                    color: AppColors.gray500)),
            const SizedBox(height: AppSpacing.s3),
            DocumentosUploader(
              archivos: state.archivos,
              onAgregar: () => notifier.agregarArchivo(
                  'Certificado_Laboral.pdf'),
              onEliminar: notifier.eliminarArchivo,
            ),

            const SizedBox(height: AppSpacing.s6),

            // ── Botón Enviar ─────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: state.tipoSeleccionado != null ? _enviar : null,
                child: const Text('Enviar Solicitud'),
              ),
            ),

            const SizedBox(height: AppSpacing.s3),

            // ── Cancelar ─────────────────────────────────
            Center(
              child: TextButton(
                onPressed: () => context.go('/home'),
                child: Text('Cancelar y Volver',
                    style: AppTypography.sm.copyWith(
                        color: AppColors.gray500)),
              ),
            ),

            const SizedBox(height: AppSpacing.s6),
          ],
        ),
      ),
    );
  }
}