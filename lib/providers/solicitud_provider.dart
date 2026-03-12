import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/solicitud_model.dart';

class NuevaSolicitudState {
  final int currentStep;
  final TipoSolicitud? tipoSeleccionado;
  final String asunto;
  final String justificacion;
  final List<String> archivos;

  const NuevaSolicitudState({
    this.currentStep = 0,
    this.tipoSeleccionado,
    this.asunto = '',
    this.justificacion = '',
    this.archivos = const [],
  });

  NuevaSolicitudState copyWith({
    int? currentStep,
    TipoSolicitud? tipoSeleccionado,
    String? asunto,
    String? justificacion,
    List<String>? archivos,
  }) {
    return NuevaSolicitudState(
      currentStep: currentStep ?? this.currentStep,
      tipoSeleccionado: tipoSeleccionado ?? this.tipoSeleccionado,
      asunto: asunto ?? this.asunto,
      justificacion: justificacion ?? this.justificacion,
      archivos: archivos ?? this.archivos,
    );
  }
}

class NuevaSolicitudNotifier extends StateNotifier<NuevaSolicitudState> {
  NuevaSolicitudNotifier() : super(const NuevaSolicitudState());

  void seleccionarTipo(TipoSolicitud tipo) =>
      state = state.copyWith(tipoSeleccionado: tipo);

  void setAsunto(String value) =>
      state = state.copyWith(asunto: value);

  void setJustificacion(String value) =>
      state = state.copyWith(justificacion: value);

  void agregarArchivo(String nombre) =>
      state = state.copyWith(archivos: [...state.archivos, nombre]);

  void eliminarArchivo(String nombre) =>
      state = state.copyWith(
        archivos: state.archivos.where((a) => a != nombre).toList());

  void reset() => state = const NuevaSolicitudState();
}

final nuevaSolicitudProvider =
    StateNotifierProvider<NuevaSolicitudNotifier, NuevaSolicitudState>(
  (ref) => NuevaSolicitudNotifier(),
);