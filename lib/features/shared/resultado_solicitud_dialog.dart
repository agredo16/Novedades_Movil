import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/solicitud_request_model.dart';

// ── Dialog de ÉXITO ──────────────────────────────────
class ExitoSolicitudDialog extends StatefulWidget {
  final SolicitudResponseModel respuesta;
  final VoidCallback onIrInicio;

  const ExitoSolicitudDialog({
    super.key,
    required this.respuesta,
    required this.onIrInicio,
  });

  @override
  State<ExitoSolicitudDialog> createState() => _ExitoSolicitudDialogState();
}

class _ExitoSolicitudDialogState extends State<ExitoSolicitudDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = CurvedAnimation(
        parent: _controller, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(
        parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s5),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: AppColors.success, size: 44),
                  ),
                ),

                const SizedBox(height: AppSpacing.s4),
                Text('¡Solicitud Registrada!',
                    style: AppTypography.xl2.copyWith(fontSize: 20)),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  'Tu trámite quedará en revisión por la secretaría académica.',
                  style: AppTypography.smGray,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.s4),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.s4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.08),
                        AppColors.primary.withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.confirmation_number_outlined,
                              color: AppColors.primary, size: 16),
                          const SizedBox(width: AppSpacing.s1),
                          Text('Número de Radicado',
                              style: AppTypography.xs.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              )),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s1),
                      Text(
                        widget.respuesta.codigoSolicitud,
                        style: AppTypography.xl.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.s3),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.warningLight,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                            color: AppColors.warning.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.schedule_rounded,
                              color: AppColors.warning, size: 14),
                          const SizedBox(width: 4),
                          Text(widget.respuesta.estado,
                              style: AppTypography.xs.copyWith(
                                color: AppColors.warning,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),

                if (widget.respuesta.validaciones.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.s4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.s3),
                    decoration: BoxDecoration(
                      color: AppColors.gray50,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: AppColors.gray100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.verified_outlined,
                                color: AppColors.success, size: 16),
                            const SizedBox(width: AppSpacing.s2),
                            Text('Validaciones completadas',
                                style: AppTypography.sm.copyWith(
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s3),
                        ...widget.respuesta.validaciones.map((v) =>
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppSpacing.s2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 20, height: 20,
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
                                    size: 13,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.s2),
                                Expanded(
                                  child: Text(v.detalle,
                                      style: AppTypography.xs.copyWith(
                                          color: AppColors.gray700)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: AppSpacing.s5),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: widget.onIrInicio,
                    child: const Text('Ir al Inicio'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Dialog de ERROR ──────────────────────────────────
class ErrorSolicitudDialog extends StatelessWidget {
  final String mensaje;
  final VoidCallback onIntentar;
  final VoidCallback onCancelar;
  final String? labelIntentar;   // ← opcional
  final String? labelCancelar;   // ← opcional

  const ErrorSolicitudDialog({
    super.key,
    required this.mensaje,
    required this.onIntentar,
    required this.onCancelar,
    this.labelIntentar,          // ← opcional
    this.labelCancelar,          // ← opcional
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.error_outline_rounded,
                  color: AppColors.error, size: 38),
            ),

            const SizedBox(height: AppSpacing.s4),
            Text('Solicitud No Procesada',
                style: AppTypography.lg.copyWith(
                    color: AppColors.gray900)),
            const SizedBox(height: AppSpacing.s3),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.s3),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                    color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline,
                      color: AppColors.error, size: 16),
                  const SizedBox(width: AppSpacing.s2),
                  Expanded(
                    child: Text(
                      mensaje,
                      style: AppTypography.sm.copyWith(
                          color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.s5),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancelar,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.gray300),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.s3),
                    ),
                    child: Text(
                      labelCancelar ?? 'Cancelar',  // ← usa label o default
                      style: AppTypography.sm.copyWith(
                          color: AppColors.gray600),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onIntentar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.s3),
                    ),
                    child: Text(
                      labelIntentar ?? 'Reintentar',  // ← usa label o default
                      style: AppTypography.sm.copyWith(
                          color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}