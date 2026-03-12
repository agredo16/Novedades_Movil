import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/solicitud_model.dart';

final historialProvider = Provider<List<SolicitudModel>>((ref) => const [
  SolicitudModel(
    id: 'RAD-2024-0891',
    titulo: 'Cambio de Jornada',
    subtitulo: 'Radicado: RAD-2024-0891',
    tiempo: '24 May, 2024',
    estado: EstadoSolicitud.aprobado,
  ),
  SolicitudModel(
    id: 'RAD-2024-0942',
    titulo: 'Adición de Curso: Cálculo',
    subtitulo: 'Radicado: RAD-2024-0942',
    tiempo: '20 May, 2024',
    estado: EstadoSolicitud.pendiente,
  ),
  SolicitudModel(
    id: 'RAD-2024-0756',
    titulo: 'Cancelación de Semestre',
    subtitulo: 'Radicado: RAD-2024-0756',
    tiempo: '15 Abr, 2024',
    estado: EstadoSolicitud.rechazado,
  ),
  SolicitudModel(
    id: 'RAD-2024-0345',
    titulo: 'Curso Dirigido: Ética',
    subtitulo: 'Radicado: RAD-2024-0345',
    tiempo: '02 Mar, 2024',
    estado: EstadoSolicitud.aprobado,
  ),
  SolicitudModel(
    id: 'RAD-2024-0001',
    titulo: 'Cambio de Programa',
    subtitulo: 'Radicado: RAD-2024-0001',
    tiempo: '12 Ene, 2024',
    estado: EstadoSolicitud.aprobado,
  ),
]);

// Filtro activo
enum FiltroHistorial { todos, pendientes, aprobados, rechazados }

final filtroHistorialProvider = StateProvider<FiltroHistorial>(
    (ref) => FiltroHistorial.todos);

final historialFiltradoProvider = Provider<List<SolicitudModel>>((ref) {
  final historial = ref.watch(historialProvider);
  final filtro = ref.watch(filtroHistorialProvider);
  switch (filtro) {
    case FiltroHistorial.todos:      return historial;
    case FiltroHistorial.pendientes: return historial
        .where((s) => s.estado == EstadoSolicitud.pendiente).toList();
    case FiltroHistorial.aprobados:  return historial
        .where((s) => s.estado == EstadoSolicitud.aprobado).toList();
    case FiltroHistorial.rechazados: return historial
        .where((s) => s.estado == EstadoSolicitud.rechazado).toList();
  }
});