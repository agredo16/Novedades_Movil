import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../providers/historial_provider.dart';
import '../widgets/historial_item_card.dart';

class HistorialScreen extends ConsumerWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solicitudes = ref.watch(historialFiltradoProvider);
    final filtro = ref.watch(filtroHistorialProvider);
    final total = ref.watch(historialProvider).length;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Mi Historial', style: AppTypography.lg),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_rounded, color: AppColors.gray700),
            onPressed: () {},
          ),
        ],
      ),

      body: Column(
        children: [
          // ── Buscador ───────────────────────────────────
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s4, 0, AppSpacing.s4, AppSpacing.s3),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por trámite o radicado...',
                hintStyle: AppTypography.sm.copyWith(
                    color: AppColors.gray400),
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.gray400),
                fillColor: AppColors.gray50,
                filled: true,
              ),
            ),
          ),

          // ── Filtros ────────────────────────────────────
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s4, 0, AppSpacing.s4, AppSpacing.s3),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: FiltroHistorial.values.map((f) {
                  final isActive = filtro == f;
                  final labels = {
                    FiltroHistorial.todos: 'Todos',
                    FiltroHistorial.pendientes: 'Pendientes',
                    FiltroHistorial.aprobados: 'Aprobados',
                    FiltroHistorial.rechazados: 'Rechazados',
                  };
                  return GestureDetector(
                    onTap: () => ref
                        .read(filtroHistorialProvider.notifier)
                        .state = f,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: AppSpacing.s2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s4,
                          vertical: AppSpacing.s2),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.gray100,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(labels[f]!,
                          style: AppTypography.sm.copyWith(
                            color: isActive
                                ? AppColors.white
                                : AppColors.gray600 ?? AppColors.gray500,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.normal,
                          )),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ── Lista ──────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.s4),
              itemCount: solicitudes.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mostrando ${solicitudes.length} solicitudes',
                            style: AppTypography.sm.copyWith(
                                color: AppColors.gray500)),
                        Row(
                          children: [
                            const Icon(Icons.filter_list_rounded,
                                size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text('Filtrar',
                                style: AppTypography.smPrimary),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return HistorialItemCard(
                    solicitud: solicitudes[index - 1]);
              },
            ),
          ),
        ],
      ),
    );
  }
}