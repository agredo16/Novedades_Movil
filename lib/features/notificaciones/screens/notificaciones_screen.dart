import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/notificacion_model.dart';
import '../../../providers/notificacion_provider.dart';
import '../widgets/notificacion_card.dart';

class NotificacionesScreen extends ConsumerStatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  ConsumerState<NotificacionesScreen> createState() =>
      _NotificacionesScreenState();
}

class _NotificacionesScreenState extends ConsumerState<NotificacionesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificaciones = ref.watch(notificacionProvider);
    final noLeidas = ref.watch(noLeidasCountProvider);
    final notifier = ref.read(notificacionProvider.notifier);

    final todasList = notificaciones;
    final noLeidasList = notificaciones.where((n) => !n.leida).toList();
    final tramitesList = notificaciones.where((n) =>
        n.tipo == TipoNotificacion.solicitudAprobada ||
        n.tipo == TipoNotificacion.actualizacion).toList();

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Notificaciones', style: AppTypography.lg),
        actions: [
          TextButton(
            onPressed: notifier.marcarTodasLeidas,
            child: Text('Marcar todo',
                style: AppTypography.smPrimary),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.gray500,
              indicatorColor: AppColors.primary,
              indicatorWeight: 2,
              labelStyle: AppTypography.sm.copyWith(
                  fontWeight: FontWeight.w600),
              tabs: [
                const Tab(text: 'Todas'),
                Tab(text: 'No leídas ${noLeidas > 0 ? "($noLeidas)" : ""}'),
                const Tab(text: 'Trámites'),
              ],
            ),
          ),
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(todasList, notifier),
          _buildList(noLeidasList, notifier),
          _buildList(tramitesList, notifier),
        ],
      ),
    );
  }

  Widget _buildList(List<NotificacionModel> lista,
      NotificacionNotifier notifier) {
    if (lista.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_off_outlined,
                color: AppColors.gray300, size: 48),
            const SizedBox(height: AppSpacing.s3),
            Text('Sin notificaciones',
                style: AppTypography.base.copyWith(
                    color: AppColors.gray400)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.s4),
      itemCount: lista.length,
      itemBuilder: (context, index) {
        // Separador "Anteriores"
        final mostrarSeparador = index > 0 &&
            !lista[index - 1].leida && lista[index].leida;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mostrarSeparador) ...[
              const SizedBox(height: AppSpacing.s2),
              Text('ANTERIORES',
                  style: AppTypography.xs.copyWith(
                    color: AppColors.gray400,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  )),
              const SizedBox(height: AppSpacing.s2),
            ],
            NotificacionCard(
              notificacion: lista[index],
              onTap: () => notifier.marcarLeida(lista[index].id),
            ),
          ],
        );
      },
    );
  }
}