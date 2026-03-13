import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/theme_provider.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeProvider.notifier);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final cardColor = Theme.of(context).cardColor;
    final borderColor = Theme.of(context).dividerColor.withOpacity(0.15);
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text('Perfil', style: AppTypography.lg.copyWith(
            color: textColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.s4),

            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primaryLight,
              child: const Icon(Icons.person_rounded,
                  color: AppColors.primary, size: 48),
            ),
            const SizedBox(height: AppSpacing.s3),
            Text('Carlos Rodríguez',
                style: AppTypography.xl.copyWith(color: textColor)),
            const SizedBox(height: AppSpacing.s1),
            Text('Código: 202310001', style: AppTypography.smGray),
            const SizedBox(height: AppSpacing.s1),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('Estudiante Activo',
                  style: AppTypography.xs.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600)),
            ),

            const SizedBox(height: AppSpacing.s6),

            _buildOpcion(
              icon: Icons.person_outline,
              label: 'Información Personal',
              onTap: () {},
              cardColor: cardColor,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildOpcion(
              icon: Icons.lock_outline,
              label: 'Cambiar Contraseña',
              onTap: () {},
              cardColor: cardColor,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildOpcion(
              icon: Icons.notifications_outlined,
              label: 'Notificaciones',
              onTap: () {},
              cardColor: cardColor,
              borderColor: borderColor,
              textColor: textColor,
            ),

            Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.s2),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: borderColor),
              ),
              child: ListTile(
                leading: Icon(
                  isDark
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: isDark ? AppColors.primary : AppColors.warning,
                  size: 22,
                ),
                title: Text('Tema Oscuro',
                    style: AppTypography.sm.copyWith(color: textColor)),
                trailing: Switch.adaptive(
                  value: isDark,
                  onChanged: (_) => themeNotifier.toggle(),
                  activeColor: AppColors.primary,
                ),
              ),
            ),

            _buildOpcion(
              icon: Icons.help_outline,
              label: 'Centro de Ayuda',
              onTap: () {},
              cardColor: cardColor,
              borderColor: borderColor,
              textColor: textColor,
            ),
            _buildOpcion(
              icon: Icons.description_outlined,
              label: 'Términos de Uso',
              onTap: () {},
              cardColor: cardColor,
              borderColor: borderColor,
              textColor: textColor,
            ),

            const SizedBox(height: AppSpacing.s4),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.logout_rounded,
                    color: AppColors.error),
                label: Text('Cerrar Sesión',
                    style: AppTypography.base.copyWith(
                        color: AppColors.error)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.s4),
            Text('AcademiaMóvil v2.4.0',
                style: AppTypography.xs.copyWith(
                    color: AppColors.gray400)),
            const SizedBox(height: AppSpacing.s4),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcion({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color cardColor,
    required Color borderColor,
    required Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s2),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.gray600, size: 22),
        title: Text(label,
            style: AppTypography.sm.copyWith(color: textColor)),
        trailing: const Icon(Icons.chevron_right,
            color: AppColors.gray400, size: 20),
        onTap: onTap,
      ),
    );
  }
}