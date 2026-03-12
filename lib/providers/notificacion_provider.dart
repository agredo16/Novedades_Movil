import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/notificacion_model.dart';

class NotificacionNotifier extends StateNotifier<List<NotificacionModel>> {
  NotificacionNotifier() : super(_inicial);

  static const _inicial = [
    NotificacionModel(
      id: '1',
      titulo: 'Solicitud Aprobada',
      descripcion: 'Tu solicitud de "Cambio de Jornada" ha sido aprobada por la...',
      categoria: 'Jornada',
      tiempo: 'HACE 10 MIN',
      leida: false,
      tipo: TipoNotificacion.solicitudAprobada,
    ),
    NotificacionModel(
      id: '2',
      titulo: 'Documentación Pendiente',
      descripcion: 'Falta adjuntar el recibo de pago para la solicitud de "Curso Dirigido".',
      categoria: 'Curso Dirigido',
      tiempo: 'HACE 2 HORAS',
      leida: false,
      tipo: TipoNotificacion.documentoPendiente,
    ),
    NotificacionModel(
      id: '3',
      titulo: 'Actualización de Estado',
      descripcion: 'La solicitud de "Adición de Curso" se encuentra ahora en revisión.',
      categoria: 'Adición',
      tiempo: 'AYER',
      leida: true,
      tipo: TipoNotificacion.actualizacion,
    ),
    NotificacionModel(
      id: '4',
      titulo: 'Recordatorio de Cita',
      descripcion: 'Tu cita con el asesor académico está programada para mañana a...',
      categoria: 'Asesoría',
      tiempo: 'HACE 2 DÍAS',
      leida: true,
      tipo: TipoNotificacion.recordatorio,
    ),
  ];

  void marcarLeida(String id) {
    state = state.map((n) =>
      n.id == id ? NotificacionModel(
        id: n.id, titulo: n.titulo, descripcion: n.descripcion,
        categoria: n.categoria, tiempo: n.tiempo, leida: true, tipo: n.tipo,
      ) : n,
    ).toList();
  }

  void marcarTodasLeidas() {
    state = state.map((n) => NotificacionModel(
      id: n.id, titulo: n.titulo, descripcion: n.descripcion,
      categoria: n.categoria, tiempo: n.tiempo, leida: true, tipo: n.tipo,
    )).toList();
  }
}

final notificacionProvider =
    StateNotifierProvider<NotificacionNotifier, List<NotificacionModel>>(
  (ref) => NotificacionNotifier(),
);

final noLeidasCountProvider = Provider<int>((ref) {
  return ref.watch(notificacionProvider).where((n) => !n.leida).length;
});