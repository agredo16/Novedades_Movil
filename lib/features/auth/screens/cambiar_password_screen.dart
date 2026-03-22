import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/auth_provider.dart';
import '../../shared/resultado_solicitud_dialog.dart';

class CambiarPasswordScreen extends ConsumerStatefulWidget {
  const CambiarPasswordScreen({super.key});

  @override
  ConsumerState<CambiarPasswordScreen> createState() =>
      _CambiarPasswordScreenState();
}

class _CambiarPasswordScreenState
    extends ConsumerState<CambiarPasswordScreen> {
  final _actualController = TextEditingController();
  final _nuevaController  = TextEditingController();
  final _confirmarController = TextEditingController();
  bool _obscureActual    = true;
  bool _obscureNueva     = true;
  bool _obscureConfirmar = true;

  @override
  void dispose() {
    _actualController.dispose();
    _nuevaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  Future<void> _cambiar() async {
    if (_actualController.text.isEmpty ||
        _nuevaController.text.isEmpty ||
        _confirmarController.text.isEmpty) {
      _mostrarError('Por favor completa todos los campos');
      return;
    }

    if (_nuevaController.text != _confirmarController.text) {
      _mostrarError('Las contraseñas nuevas no coinciden');
      return;
    }

    if (_nuevaController.text.length < 8) {
      _mostrarError('La contraseña nueva debe tener mínimo 8 caracteres');
      return;
    }

    final exito = await ref.read(authProvider.notifier).cambiarPassword(
      passwordActual: _actualController.text.trim(),
      passwordNueva:  _nuevaController.text.trim(),
    );

    if (!mounted) return;

    if (exito) {
      _mostrarExito();
    } else {
      final error = ref.read(authProvider).error ?? 'Error al cambiar contraseña';
      _mostrarError(error);
    }
  }

  void _mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (_) => ErrorSolicitudDialog(
        mensaje: mensaje,
        labelIntentar: 'Intentar de nuevo',
        labelCancelar: 'Cerrar',
        onIntentar: () => Navigator.pop(context),
        onCancelar: () => Navigator.pop(context),
      ),
    );
  }

  void _mostrarExito() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
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
                child: const Icon(Icons.lock_open_rounded,
                    color: AppColors.success, size: 38),
              ),
              const SizedBox(height: AppSpacing.s4),
              Text('¡Contraseña Actualizada!',
                  style: AppTypography.lg),
              const SizedBox(height: AppSpacing.s2),
              Text(
                'Tu contraseña ha sido cambiada exitosamente. Ya puedes acceder a todas las funciones.',
                style: AppTypography.smGray,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s5),
              SizedBox(
                width: double.infinity,
                height: 50,
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: AppSpacing.s6),

              Center(
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_reset_rounded,
                      color: AppColors.primary, size: 40),
                ),
              ),

              const SizedBox(height: AppSpacing.s5),

              Center(
                child: Text('Cambia tu Contraseña',
                    style: AppTypography.xl2),
              ),
              const SizedBox(height: AppSpacing.s2),
              Center(
                child: Text(
                  'Es tu primer ingreso. Por seguridad debes establecer una contraseña personal.',
                  style: AppTypography.smGray,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppSpacing.s6),

              Container(
                padding: const EdgeInsets.all(AppSpacing.s3),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(
                      color: AppColors.warning.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: AppColors.warning, size: 18),
                    const SizedBox(width: AppSpacing.s2),
                    Expanded(
                      child: Text(
                        'Usa la contraseña temporal que te fue asignada como contraseña actual.',
                        style: AppTypography.xs.copyWith(
                            color: AppColors.gray700),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.s5),

              Container(
                padding: const EdgeInsets.all(AppSpacing.s5),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _buildLabel('Contraseña Actual'),
                    const SizedBox(height: AppSpacing.s2),
                    _buildPasswordField(
                      controller: _actualController,
                      hint: 'Contraseña temporal asignada',
                      obscure: _obscureActual,
                      onToggle: () => setState(
                          () => _obscureActual = !_obscureActual),
                    ),

                    const SizedBox(height: AppSpacing.s4),

                    _buildLabel('Nueva Contraseña'),
                    const SizedBox(height: AppSpacing.s2),
                    _buildPasswordField(
                      controller: _nuevaController,
                      hint: 'Mínimo 8 caracteres',
                      obscure: _obscureNueva,
                      onToggle: () => setState(
                          () => _obscureNueva = !_obscureNueva),
                    ),

                    const SizedBox(height: AppSpacing.s4),

                    _buildLabel('Confirmar Nueva Contraseña'),
                    const SizedBox(height: AppSpacing.s2),
                    _buildPasswordField(
                      controller: _confirmarController,
                      hint: 'Repite la nueva contraseña',
                      obscure: _obscureConfirmar,
                      onToggle: () => setState(
                          () => _obscureConfirmar = !_obscureConfirmar),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.s5),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _cambiar,
                  child: isLoading
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                              color: AppColors.white, strokeWidth: 2),
                        )
                      : const Text('Actualizar Contraseña'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
      text,
      style: AppTypography.xs.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.gray500,
      ));

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.sm.copyWith(color: AppColors.gray400),
        prefixIcon: const Icon(Icons.lock_outline,
            color: AppColors.gray400),
        suffixIcon: IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.gray400,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}