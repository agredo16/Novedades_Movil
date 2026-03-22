import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novedades_movil/features/shared/resultado_solicitud_dialog.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/solicitud_model.dart';
import '../../../data/models/solicitud_request_model.dart';
import '../../../providers/solicitud_provider.dart';
import '../../../providers/grupo_provider.dart';
import '../widgets/step_indicator.dart';
import '../widgets/tipo_solicitud_grid.dart';
import '../widgets/documentos_uploader.dart';
import '../widgets/grupo_selector.dart';

class NuevaSolicitudScreen extends ConsumerStatefulWidget {
  const NuevaSolicitudScreen({super.key});

  @override
  ConsumerState<NuevaSolicitudScreen> createState() =>
      _NuevaSolicitudScreenState();
}

class _NuevaSolicitudScreenState extends ConsumerState<NuevaSolicitudScreen> {
  final _justificacionController = TextEditingController();

  @override
  void dispose() {
    _justificacionController.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final notifier = ref.read(nuevaSolicitudProvider.notifier);
    final exito    = await notifier.enviarSolicitud();

    if (!mounted) return;

    if (exito) {
      final respuesta = ref.read(nuevaSolicitudProvider).respuesta!;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ExitoSolicitudDialog(
          respuesta: respuesta,
          onIrInicio: () {
            Navigator.pop(context);
            ref.read(nuevaSolicitudProvider.notifier).reset();
            context.go('/home');
          },
        ),
      );
    } else {
      final error = ref.read(nuevaSolicitudProvider).error ??
                    'Error al procesar la solicitud';
      showDialog(
        context: context,
        builder: (_) => ErrorSolicitudDialog(
          mensaje: error,
          onIntentar: () => Navigator.pop(context),
          onCancelar: () {
            Navigator.pop(context);
            context.go('/home');
          },
        ),
      );
    }
  }

  bool _puedeEnviar(NuevaSolicitudState state) {
    if (state.isLoading) return false;
    if (state.tipoSeleccionado == null) return false;
    if (state.justificacion.length < 50) return false;

    if (state.tipoSeleccionado == TipoSolicitud.cambioJornada) {
      if (state.jornadaActual == null || state.jornadaNueva == null) {
        return false;
      }
    }

    if (state.tipoSeleccionado == TipoSolicitud.adicionCurso ||
        state.tipoSeleccionado == TipoSolicitud.cursoDirigido ||
        state.tipoSeleccionado == TipoSolicitud.cambioCurso) {
      if (state.grupoNuevoId == null) return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final state     = ref.watch(nuevaSolicitudProvider);
    final notifier  = ref.read(nuevaSolicitudProvider.notifier);
    final grupoState = ref.watch(grupoProvider);

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

            // ── Step Indicator ───────────────────────
            StepIndicator(totalSteps: 3, currentStep: 0),
            const SizedBox(height: AppSpacing.s4),

            // ── Info banner ──────────────────────────
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
                      'Completa todos los campos marcados para asegurar el procesamiento de tu trámite.',
                      style: AppTypography.xs.copyWith(
                          color: AppColors.info),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.s5),

            // ── Tipo de Solicitud ────────────────────
            Row(children: [
              const Icon(Icons.grid_view_rounded,
                  color: AppColors.primary, size: 18),
              const SizedBox(width: AppSpacing.s2),
              Text('Tipo de Solicitud', style: AppTypography.baseBold),
            ]),
            const SizedBox(height: AppSpacing.s3),
            TipoSolicitudGrid(
              seleccionado: state.tipoSeleccionado,
              onSelect: notifier.seleccionarTipo,
            ),

            const SizedBox(height: AppSpacing.s5),

            // ── Campos dinámicos ─────────────────────
            if (state.tipoSeleccionado != null) ...[
              Row(children: [
                const Icon(Icons.description_outlined,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: AppSpacing.s2),
                Text('Justificación y Detalles',
                    style: AppTypography.baseBold),
              ]),
              const SizedBox(height: AppSpacing.s3),

              // ── Cambio de Jornada ──────────────────
              if (state.tipoSeleccionado == TipoSolicitud.cambioJornada) ...[
                _buildLabel('Jornada Actual *'),
                const SizedBox(height: AppSpacing.s2),
                _buildDropdown(
                  value: state.jornadaActual,
                  hint: 'Selecciona jornada actual',
                  items: const ['manana', 'tarde', 'noche'],
                  labels: const ['Mañana', 'Tarde', 'Noche'],
                  onChanged: notifier.setJornadaActual,
                ),
                const SizedBox(height: AppSpacing.s3),
                _buildLabel('Jornada Nueva *'),
                const SizedBox(height: AppSpacing.s2),
                _buildDropdown(
                  value: state.jornadaNueva,
                  hint: 'Selecciona jornada nueva',
                  items: const ['manana', 'tarde', 'noche'],
                  labels: const ['Mañana', 'Tarde', 'Noche'],
                  onChanged: notifier.setJornadaNueva,
                ),
                const SizedBox(height: AppSpacing.s3),
              ],

              // ── Selector de grupos ─────────────────
              if (state.tipoSeleccionado == TipoSolicitud.adicionCurso ||
                  state.tipoSeleccionado == TipoSolicitud.cursoDirigido ||
                  state.tipoSeleccionado == TipoSolicitud.cambioCurso) ...[
                _buildLabel('Selecciona el Grupo *'),
                const SizedBox(height: AppSpacing.s2),
                GrupoSelector(
                  grupos:              grupoState.grupos,
                  grupoSeleccionadoId: state.grupoNuevoId,
                  isLoading:           grupoState.isLoading,
                  onSelect: (grupo) => notifier.setGrupoNuevoId(grupo.id),
                ),
                const SizedBox(height: AppSpacing.s3),
              ],

              // ── Justificación siempre visible ──────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel('Justificación detallada *'),
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
                  hintText: 'Explica los motivos académicos o laborales...',
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: AppSpacing.s5),

              // ── Documentos solo para Adición ───────
              if (state.tipoSeleccionado == TipoSolicitud.adicionCurso) ...[
                Row(children: [
                  const Icon(Icons.attach_file_rounded,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: AppSpacing.s2),
                  Text('Documentos de Soporte',
                      style: AppTypography.baseBold),
                ]),
                const SizedBox(height: AppSpacing.s1),
                Text('Adjunta archivos PDF o imágenes (máx. 5MB)',
                    style: AppTypography.xs.copyWith(
                        color: AppColors.gray500)),
                const SizedBox(height: AppSpacing.s3),
                DocumentosUploader(
                  archivos: state.archivos,
                  onAgregar: () =>
                      notifier.agregarArchivo('Documento_Soporte.pdf'),
                  onEliminar: notifier.eliminarArchivo,
                ),
                const SizedBox(height: AppSpacing.s5),
              ],
            ],

            // ── Botón Enviar ─────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _puedeEnviar(state) ? _enviar : null,
                child: state.isLoading
                    ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(
                            color: AppColors.white, strokeWidth: 2),
                      )
                    : const Text('Enviar Solicitud'),
              ),
            ),

            const SizedBox(height: AppSpacing.s3),
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

  Widget _buildLabel(String text) => Text(text,
      style: AppTypography.sm.copyWith(fontWeight: FontWeight.w600));

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required List<String> labels,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.gray200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint,
              style: AppTypography.sm.copyWith(
                  color: AppColors.gray400)),
          isExpanded: true,
          items: List.generate(
            items.length,
            (i) => DropdownMenuItem(
              value: items[i],
              child: Text(labels[i], style: AppTypography.sm),
            ),
          ),
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
    );
  }
}