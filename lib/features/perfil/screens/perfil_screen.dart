import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/perfil_provider.dart';
import '../../../providers/theme_provider.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfilState  = ref.watch(perfilProvider);
    final isDark       = ref.watch(themeProvider) == ThemeMode.dark;
    final themeNotifier = ref.read(themeProvider.notifier);
    final cardColor    = Theme.of(context).cardColor;
    final borderColor  = Theme.of(context).dividerColor.withOpacity(0.15);
    final textColor    = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text('Perfil', style: AppTypography.lg.copyWith(
            color: textColor)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: AppColors.gray500),
            onPressed: () => ref.read(perfilProvider.notifier).cargar(),
          ),
        ],
      ),

      body: perfilState.isLoading
          ? const Center(child: CircularProgressIndicator(
              color: AppColors.primary))
          : perfilState.error != null
              ? _buildError(context, ref, perfilState.error!)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.s4),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.s4),

                      // ── Avatar ──────────────────────
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          perfilState.perfil?.iniciales ?? 'E',
                          style: AppTypography.xl2.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s3),
                      Text(
                        perfilState.perfil?.nombreCompleto ?? '',
                        style: AppTypography.xl.copyWith(color: textColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.s1),
                      Text(
                        perfilState.perfil?.emailInstitucional ?? '',
                        style: AppTypography.smGray,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.s2),

                      // Badge estado
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: perfilState.perfil?.matriculaActiva == true
                              ? AppColors.successLight
                              : AppColors.errorLight,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          perfilState.perfil?.matriculaActiva == true
                              ? 'Matrícula Activa'
                              : 'Matrícula Inactiva',
                          style: AppTypography.xs.copyWith(
                            color: perfilState.perfil?.matriculaActiva == true
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.s5),

                      // ── Info académica ───────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.s4),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Información Académica',
                                style: AppTypography.sm.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                )),
                            const SizedBox(height: AppSpacing.s3),
                            _buildInfoRow(
                              Icons.badge_outlined,
                              'Código',
                              perfilState.perfil?.codAlumno ?? '',
                              textColor,
                            ),
                            _buildInfoRow(
                              Icons.school_outlined,
                              'Programa',
                              perfilState.perfil?.nombrePrograma ?? '',
                              textColor,
                            ),
                            _buildInfoRow(
                              Icons.layers_outlined,
                              'Semestre',
                              '${perfilState.perfil?.semestre ?? ''} semestre',
                              textColor,
                            ),
                            _buildInfoRow(
                              Icons.wb_sunny_outlined,
                              'Jornada',
                              perfilState.perfil?.jornadaLabel ?? '',
                              textColor,
                            ),

                            const SizedBox(height: AppSpacing.s3),

                            // Barra de créditos
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Créditos inscritos',
                                    style: AppTypography.xs.copyWith(
                                        color: AppColors.gray500)),
                                Text(
                                  '${perfilState.perfil?.creditosInscritos ?? 0} / ${perfilState.perfil?.creditosMaxPermitidos ?? 0}',
                                  style: AppTypography.xs.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.s2),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: perfilState.perfil != null
                                    ? perfilState.perfil!.creditosInscritos /
                                        perfilState.perfil!.creditosMaxPermitidos
                                    : 0,
                                backgroundColor: AppColors.gray100,
                                color: AppColors.primary,
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.s4),

                      // ── Opciones ─────────────────────
                      _buildOpcion(
                        icon: Icons.lock_outline,
                        label: 'Cambiar Contraseña',
                        onTap: () => context.go('/cambiar-password'),
                        cardColor: cardColor,
                        borderColor: borderColor,
                        textColor: textColor,
                      ),

                      // Toggle tema oscuro
                      Container(
                        margin: const EdgeInsets.only(
                            bottom: AppSpacing.s2),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          border: Border.all(color: borderColor),
                        ),
                        child: ListTile(
                          leading: Icon(
                            isDark
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            color: isDark
                                ? AppColors.primary
                                : AppColors.warning,
                            size: 22,
                          ),
                          title: Text('Tema Oscuro',
                              style: AppTypography.sm.copyWith(
                                  color: textColor)),
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

                      // ── Cerrar Sesión ────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ref.read(authProvider.notifier).logout();
                            context.go('/login');
                          },
                          icon: const Icon(Icons.logout_rounded,
                              color: AppColors.error),
                          label: Text('Cerrar Sesión',
                              style: AppTypography.base.copyWith(
                                  color: AppColors.error)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: AppColors.error),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusMd),
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

  Widget _buildError(
      BuildContext context, WidgetRef ref, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.error, size: 48),
            const SizedBox(height: AppSpacing.s3),
            Text(error,
                style: AppTypography.sm.copyWith(
                    color: AppColors.gray500),
                textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.s4),
            ElevatedButton(
              onPressed: () =>
                  ref.read(perfilProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, Color? textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s3),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.gray500),
          const SizedBox(width: AppSpacing.s3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppTypography.xs.copyWith(
                      color: AppColors.gray500)),
              Text(value,
                  style: AppTypography.sm.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ],
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