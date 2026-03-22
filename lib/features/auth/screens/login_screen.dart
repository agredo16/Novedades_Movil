import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:novedades_movil/features/shared/resultado_solicitud_dialog.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _codigoController    = TextEditingController();
  final _passwordController  = TextEditingController();
  bool _obscurePassword      = true;

  @override
  void dispose() {
    _codigoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

 Future<void> _handleLogin() async {
  if (_codigoController.text.isEmpty || _passwordController.text.isEmpty) {
    showDialog(
      context: context,
      builder: (_) => ErrorSolicitudDialog(
        mensaje: 'Por favor completa el código estudiantil y la contraseña.',
        onIntentar: () => Navigator.pop(context),
        onCancelar: () => Navigator.pop(context),
      ),
    );
    return;
  }

  await ref.read(authProvider.notifier).login(
    codigo:   _codigoController.text.trim(),
    password: _passwordController.text.trim(),
  );

  if (!mounted) return;

  final authState = ref.read(authProvider);

  if (authState.isAuthenticated && authState.user != null) {
    if (authState.user!.primerLogin) {
      context.go('/cambiar-password'); 
    } else {
      context.go('/home');         
    }
  } else if (authState.error != null) {
    showDialog(
      context: context,
      builder: (_) => ErrorSolicitudDialog(
        mensaje: authState.error!,
        onIntentar: () => Navigator.pop(context),
        onCancelar: () => Navigator.pop(context),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.s12),

              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: const Icon(Icons.school_rounded,
                    color: AppColors.white, size: 40),
              ),

              const SizedBox(height: AppSpacing.s6),
              Text('Bienvenido, Estudiante', style: AppTypography.xl2),
              const SizedBox(height: AppSpacing.s2),
              Text(
                'Gestiona tus trámites académicos de\nforma rápida y segura.',
                style: AppTypography.smGray,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.s8),

              Container(
                padding: const EdgeInsets.all(AppSpacing.s5),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
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
                    Text('CÓDIGO ESTUDIANTIL',
                        style: AppTypography.xs.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.gray500,
                        )),
                    const SizedBox(height: AppSpacing.s2),
                    TextField(
                      controller: _codigoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Ej. 202310001',
                        hintStyle: AppTypography.sm.copyWith(
                            color: AppColors.gray400),
                        prefixIcon: const Icon(Icons.person_outline,
                            color: AppColors.gray400),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text('CONTRASEÑA',
                        style: AppTypography.xs.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.gray500,
                        )),
                    const SizedBox(height: AppSpacing.s2),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: AppTypography.sm.copyWith(
                            color: AppColors.gray400),
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: AppColors.gray400),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.gray400,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text('¿Olvidaste tu código?',
                            style: AppTypography.smPrimary),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.s5),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleLogin,
                  child: isLoading
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                              color: AppColors.white, strokeWidth: 2),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Iniciar Sesión',
                                style: AppTypography.lgWhite),
                            const SizedBox(width: AppSpacing.s2),
                            const Icon(Icons.arrow_forward,
                                color: AppColors.white),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: AppSpacing.s6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified_user_outlined,
                      size: 14, color: AppColors.gray400),
                  const SizedBox(width: AppSpacing.s1),
                  Text('ACCESO SEGURO SSL',
                      style: AppTypography.xs.copyWith(
                          color: AppColors.gray400, letterSpacing: 0.8)),
                ],
              ),
              const SizedBox(height: AppSpacing.s6),
            ],
          ),
        ),
      ),
    );
  }
}