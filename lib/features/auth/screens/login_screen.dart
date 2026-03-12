import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _codigoController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _codigoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
  // Validación básica
  if (_codigoController.text.isEmpty || _passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Por favor completa todos los campos'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
    return;
  }

  setState(() => _isLoading = true);
  await Future.delayed(const Duration(milliseconds: 1200));

  if (mounted) {
    setState(() => _isLoading = false);
    context.go('/home');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.s12),

              // ── Ícono superior ──────────────────────────
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: AppColors.white,
                  size: 40,
                ),
              ),

              const SizedBox(height: AppSpacing.s6),

              // ── Título ──────────────────────────────────
              Text('Bienvenido, Estudiante', style: AppTypography.xl2),
              const SizedBox(height: AppSpacing.s2),
              Text(
                'Gestiona tus trámites académicos de\nforma rápida y segura.',
                style: AppTypography.smGray,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.s8),

              // ── Card del formulario ─────────────────────
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

                    // ── Campo Código ──────────────────────
                    Text('CÓDIGO ESTUDIANTIL',
                      style: AppTypography.xs.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.gray500,
                      ),
                    ),
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

                    // ── Campo Contraseña ──────────────────
                    Text('CONTRASEÑA',
                      style: AppTypography.xs.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.gray500,
                      ),
                    ),
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

                    // ── ¿Olvidaste tu código? ─────────────
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

              // ── Botón Iniciar Sesión ────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
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

              // ── Acceso Seguro SSL ───────────────────────
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

              const SizedBox(height: AppSpacing.s4),

              // ── Footer ─────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.help_outline,
                      size: 14, color: AppColors.gray400),
                  const SizedBox(width: AppSpacing.s1),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero),
                    child: Text('Centro de Ayuda',
                        style: AppTypography.xs.copyWith(
                            color: AppColors.gray500)),
                  ),
                  Text(' • ',
                      style: AppTypography.xs.copyWith(
                          color: AppColors.gray400)),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero),
                    child: Text('Términos de Uso',
                        style: AppTypography.xs.copyWith(
                            color: AppColors.gray500)),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.s2),
              Text('© 2024 AcademiaMóvil v2.4.0',
                style: AppTypography.xs.copyWith(color: AppColors.gray400)),

              const SizedBox(height: AppSpacing.s6),
            ],
          ),
        ),
      ),
    );
  }
}