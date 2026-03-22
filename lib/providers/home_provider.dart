import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/solicitud_model.dart';
import '../data/models/historial_model.dart';
import 'auth_provider.dart';
import 'perfil_provider.dart';
import 'historial_provider.dart';

// ── Nombre del usuario ────────────────────────────────
final nombreUsuarioProvider = Provider<String>((ref) {
  final perfil = ref.watch(perfilProvider).perfil;
  if (perfil != null) {
    return perfil.nombreCompleto.split(' ').first;
  }
  final authState = ref.watch(authProvider);
  if (authState.user != null) {
    return authState.user!.nombreCompleto.split(' ').first;
  }
  return 'Estudiante';
});

// ── Stats desde el historial real ────────────────────
final statsProvider = Provider<Map<String, int>>((ref) {
  final solicitudes = ref.watch(historialProvider).solicitudes;
  return {
    'enProceso':  solicitudes.where((s) => s.estado == 'PENDIENTE').length,
    'aprobadas':  solicitudes.where((s) => s.estado == 'APROBADO').length,
    'rechazadas': solicitudes.where((s) => s.estado == 'RECHAZADO').length,
  };
});

// ── 3 más recientes como SolicitudModel (para StatsCard) ──
final solicitudesRecientesProvider = Provider<List<SolicitudModel>>((ref) {
  final solicitudes = ref.watch(historialProvider).solicitudes;
  return solicitudes.take(3).map((s) => SolicitudModel(
    id:       s.id,
    titulo:   s.tipoLabel,
    subtitulo: s.codigoSolicitud,
    tiempo:   _tiempoRelativo(s.createdAt),
    estado:   _mapearEstado(s.estado),
  )).toList();
});

// ── 3 más recientes como HistorialModel (para el modal) ──
final solicitudesRecientesHistorialProvider =
    Provider<List<HistorialSolicitudModel>>((ref) {
  final solicitudes = ref.watch(historialProvider).solicitudes;
  return solicitudes.take(3).toList();
});

EstadoSolicitud _mapearEstado(String estado) {
  switch (estado) {
    case 'APROBADO':  return EstadoSolicitud.aprobado;
    case 'RECHAZADO': return EstadoSolicitud.rechazado;
    case 'PENDIENTE': return EstadoSolicitud.pendiente;
    default:          return EstadoSolicitud.enProceso;
  }
}

String _tiempoRelativo(DateTime fecha) {
  final diff = DateTime.now().difference(fecha);
  if (diff.inMinutes < 60)      return 'Hace ${diff.inMinutes} min';
  if (diff.inHours < 24)        return 'Hace ${diff.inHours} horas';
  if (diff.inDays == 1)         return 'Ayer';
  if (diff.inDays < 7)          return 'Hace ${diff.inDays} días';
  return '${fecha.day} ${_mes(fecha.month)}';
}

String _mes(int mes) {
  const meses = [
    '', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
  ];
  return meses[mes];
}