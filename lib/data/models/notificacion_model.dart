enum TipoNotificacion { solicitudAprobada, documentoPendiente, actualizacion, recordatorio }

class NotificacionModel {
  final String id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String tiempo;
  final bool leida;
  final TipoNotificacion tipo;

  const NotificacionModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.tiempo,
    required this.leida,
    required this.tipo,
  });
}