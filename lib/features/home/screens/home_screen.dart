import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/home_provider.dart';
import '../../shared/bottom_nav_bar.dart';
import '../../notificaciones/screens/notificaciones_screen.dart';
import '../../historial/screens/historial_screen.dart';
import '../widgets/stats_card.dart';
import '../widgets/solicitud_item_card.dart';
import '../../perfil/screens/perfil_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  // ── Lista de pantallas del BottomNav ──────────────
 static const List<Widget> _screens = [
  _HomeBody(),
  NotificacionesScreen(),
  HistorialScreen(),
  PerfilScreen(),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,

      // AppBar solo visible en Home (index 0)
      appBar: _currentIndex == 0 ? AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.school_rounded,
                  color: AppColors.white, size: 18),
            ),
            const SizedBox(width: AppSpacing.s2),
            Text('AcademiaMóvil',
                style: AppTypography.base.copyWith(
                    fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.s4),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryLight,
              child: const Icon(Icons.person,
                  color: AppColors.primary, size: 20),
            ),
          ),
        ],
      ) : null,

      // Cambia el body según el tab activo
      body: _screens[_currentIndex],

      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

// ── Body del Home separado como widget privado ────────
class _HomeBody extends ConsumerWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final solicitudes = ref.watch(solicitudesRecientesProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Saludo ────────────────────────────────
          const SizedBox(height: AppSpacing.s2),
          Row(
            children: [
              Text('Hola, Carlos ', style: AppTypography.xl),
              const Text('👋', style: TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: AppSpacing.s1),
          Text('Revisa el estado de tus trámites académicos de hoy.',
              style: AppTypography.smGray),

          const SizedBox(height: AppSpacing.s4),

          // ── Stats ──────────────────────────────────
          Row(
            children: [
              StatsCard(
                count: stats['enProceso']!,
                label: 'EN PROCESO',
                color: AppColors.gray700,
              ),
              const SizedBox(width: AppSpacing.s2),
              StatsCard(
                count: stats['aprobadas']!,
                label: 'APROBADAS',
                color: AppColors.gray700,
              ),
              const SizedBox(width: AppSpacing.s2),
              StatsCard(
                count: stats['rechazadas']!,
                label: 'RECHAZADAS',
                color: AppColors.error,
                hasError: true,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s4),

          // ── Banner Nueva Solicitud ─────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.s4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('¿Necesitas algo?',
                          style: AppTypography.base.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: AppSpacing.s1),
                      Text(
                        'Inicia un nuevo proceso académico de forma rápida y sencilla.',
                        style: AppTypography.xs.copyWith(
                            color: AppColors.white.withOpacity(0.85)),
                      ),
                      const SizedBox(height: AppSpacing.s3),
                      OutlinedButton.icon(
                        onPressed: () => context.go('/solicitud'),
                        icon: const Icon(Icons.add_circle_outline,
                            color: AppColors.white, size: 16),
                        label: Text('Nueva Solicitud',
                            style: AppTypography.sm.copyWith(
                                color: AppColors.white)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: AppColors.white, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppSpacing.radiusFull),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s4,
                            vertical: AppSpacing.s2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                        AppSpacing.radiusFull),
                  ),
                  child: const Icon(Icons.add,
                      color: AppColors.white, size: 24),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.s5),

          // ── Resumen Reciente ───────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Resumen Reciente', style: AppTypography.baseBold),
              TextButton(
                onPressed: () {},
                child: Text('Ver todo', style: AppTypography.smPrimary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),

          ...solicitudes.asMap().entries.map((entry) =>
            SolicitudItemCard(
              solicitud: entry.value,
              isHighlighted: entry.key == 1,
            ),
          ),

          const SizedBox(height: AppSpacing.s4),

          // ── Recordatorio ───────────────────────────
          Container(
            padding: const EdgeInsets.all(AppSpacing.s4),
            decoration: BoxDecoration(
              color: AppColors.warningLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                  color: AppColors.warning.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.notifications_outlined,
                    color: AppColors.warning, size: 20),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Text(
                    'La fecha límite para solicitudes de cancelación de curso es el próximo viernes 20 de Octubre.',
                    style: AppTypography.xs.copyWith(
                        color: AppColors.gray700),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.s6),
        ],
      ),
    );
  }
}