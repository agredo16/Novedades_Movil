import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/historial_model.dart';
import '../../../providers/historial_provider.dart';

class HistorialScreen extends ConsumerWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historialProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text('Mi Historial', style: AppTypography.lg.copyWith(
          color: Theme.of(context).appBarTheme.titleTextStyle?.color,
        )),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: AppColors.gray700),
            onPressed: () =>
                ref.read(historialProvider.notifier).cargar(),
          ),
        ],
      ),

      body: Column(
        children: [

          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s4, 0, AppSpacing.s4, AppSpacing.s3),
            child: TextField(
              onChanged: (v) =>
                  ref.read(historialProvider.notifier).buscar(v),
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

          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s4, 0, AppSpacing.s4, AppSpacing.s3),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: FiltroHistorial.values.map((f) {
                  final isActive = state.filtro == f;
                  final labels = {
                    FiltroHistorial.todos:      'Todos',
                    FiltroHistorial.pendientes: 'Pendientes',
                    FiltroHistorial.aprobados:  'Aprobados',
                    FiltroHistorial.rechazados: 'Rechazados',
                  };
                  return GestureDetector(
                    onTap: () => ref
                        .read(historialProvider.notifier)
                        .cambiarFiltro(f),
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
                        borderRadius: BorderRadius.circular(
                            AppSpacing.radiusFull),
                      ),
                      child: Text(labels[f]!,
                          style: AppTypography.sm.copyWith(
                            color: isActive
                                ? AppColors.white
                                : AppColors.gray600,
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

          Expanded(
            child: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary))
                : state.error != null
                    ? _buildError(context, ref, state.error!)
                    : state.filtradas.isEmpty
                        ? _buildVacio()
                        : ListView.builder(
                            padding: const EdgeInsets.all(AppSpacing.s4),
                            itemCount: state.filtradas.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppSpacing.s3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Mostrando ${state.filtradas.length} solicitudes',
                                        style: AppTypography.sm.copyWith(
                                            color: AppColors.gray500),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return _HistorialCard(
                                  solicitud: state.filtradas[index - 1]);
                            },
                          ),
          ),
        ],
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
                  ref.read(historialProvider.notifier).cargar(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVacio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined,
              color: AppColors.gray300, size: 56),
          const SizedBox(height: AppSpacing.s3),
          Text('No hay solicitudes',
              style: AppTypography.base.copyWith(
                  color: AppColors.gray400)),
          const SizedBox(height: AppSpacing.s1),
          Text('Tus trámites aparecerán aquí',
              style: AppTypography.sm.copyWith(
                  color: AppColors.gray400)),
        ],
      ),
    );
  }
}

class _HistorialCard extends StatelessWidget {
  final HistorialSolicitudModel solicitud;

  const _HistorialCard({required this.solicitud});

  Color get _estadoColor {
    switch (solicitud.estadoVisual) {
      case EstadoVisual.aprobado:  return AppColors.success;
      case EstadoVisual.rechazado: return AppColors.error;
      case EstadoVisual.pendiente: return AppColors.warning;
      case EstadoVisual.enProceso: return AppColors.info;
    }
  }

  Color get _estadoBg {
    switch (solicitud.estadoVisual) {
      case EstadoVisual.aprobado:  return AppColors.successLight;
      case EstadoVisual.rechazado: return AppColors.errorLight;
      case EstadoVisual.pendiente: return AppColors.warningLight;
      case EstadoVisual.enProceso: return AppColors.infoLight;
    }
  }

  IconData get _tipoIcon {
    switch (solicitud.tipoSolicitud) {
      case 'ADICION':        return Icons.add_circle_outline_rounded;
      case 'CAMBIO_JORNADA': return Icons.schedule_rounded;
      case 'CAMBIO_CURSO':   return Icons.swap_horiz_rounded;
      case 'CURSO_DIRIGIDO': return Icons.menu_book_rounded;
      default:               return Icons.description_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fecha = DateFormat('dd MMM, yyyy', 'es')
        .format(solicitud.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.gray100),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray200.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s3),
            child: Row(
              children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(_tipoIcon,
                      color: AppColors.gray600, size: 22),
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(solicitud.tipoLabel,
                          style: AppTypography.sm.copyWith(
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(solicitud.codigoSolicitud,
                          style: AppTypography.xs.copyWith(
                              color: AppColors.gray500)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _estadoBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(solicitud.estado,
                      style: AppTypography.xs.copyWith(
                        color: _estadoColor,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: AppColors.gray100),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: AppSpacing.s2,
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 12, color: AppColors.gray400),
                const SizedBox(width: 4),
                Text(fecha,
                    style: AppTypography.xs.copyWith(
                        color: AppColors.gray400)),
                const Spacer(),
                const Icon(Icons.school_outlined,
                    size: 12, color: AppColors.gray400),
                const SizedBox(width: 4),
                Text(solicitud.periodoAcademico,
                    style: AppTypography.xs.copyWith(
                        color: AppColors.gray400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}