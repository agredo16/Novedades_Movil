import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:novedades_movil/data/repositories/solicitud_repository.dart';
import '../data/models/solicitud_model.dart';
import '../data/models/solicitud_request_model.dart';

class NuevaSolicitudState {
  final int currentStep;
  final TipoSolicitud? tipoSeleccionado;
  final String justificacion;
  final String periodoAcademico;
  final int? grupoNuevoId;
  final int? grupoActualId;
  final String? jornadaActual;
  final String? jornadaNueva;
  final List<String> archivos;
  final bool isLoading;
  final String? error;
  final SolicitudResponseModel? respuesta;

  const NuevaSolicitudState({
    this.currentStep      = 0,
    this.tipoSeleccionado,
    this.justificacion    = '',
    this.periodoAcademico = '2026-1',
    this.grupoNuevoId,
     this.grupoActualId,
    this.jornadaActual,
    this.jornadaNueva,
    this.archivos         = const [],
    this.isLoading        = false,
    this.error,
    this.respuesta,
  });

  NuevaSolicitudState copyWith({
    int? currentStep,
    TipoSolicitud? tipoSeleccionado,
    String? justificacion,
    String? periodoAcademico,
    int? grupoNuevoId,
    int? grupoActualId,
    String? jornadaActual,
    String? jornadaNueva,
    List<String>? archivos,
    bool? isLoading,
    String? error,
    SolicitudResponseModel? respuesta,
  }) {
    return NuevaSolicitudState(
      currentStep:      currentStep      ?? this.currentStep,
      tipoSeleccionado: tipoSeleccionado  ?? this.tipoSeleccionado,
      justificacion:    justificacion     ?? this.justificacion,
      periodoAcademico: periodoAcademico  ?? this.periodoAcademico,
      grupoNuevoId:     grupoNuevoId      ?? this.grupoNuevoId,
      grupoActualId:    grupoActualId     ?? this.grupoActualId,
      jornadaActual:    jornadaActual     ?? this.jornadaActual,
      jornadaNueva:     jornadaNueva      ?? this.jornadaNueva,
      archivos:         archivos          ?? this.archivos,
      isLoading:        isLoading         ?? this.isLoading,
      error:            error,
      respuesta:        respuesta         ?? this.respuesta,
    );
  }
}

class NuevaSolicitudNotifier extends StateNotifier<NuevaSolicitudState> {
  final SolicitudRepository _repo;

  NuevaSolicitudNotifier(this._repo) : super(const NuevaSolicitudState());
  void setGrupoActualId(int id) =>
    state = state.copyWith(grupoActualId: id);

  void seleccionarTipo(TipoSolicitud tipo) =>
      state = state.copyWith(tipoSeleccionado: tipo);

  void setJustificacion(String value) =>
      state = state.copyWith(justificacion: value);

  void setJornadaActual(String value) =>
      state = state.copyWith(jornadaActual: value);

  void setJornadaNueva(String value) =>
      state = state.copyWith(jornadaNueva: value);

  void setGrupoNuevoId(int id) =>
      state = state.copyWith(grupoNuevoId: id);

  void agregarArchivo(String nombre) =>
      state = state.copyWith(archivos: [...state.archivos, nombre]);

  void eliminarArchivo(String nombre) =>
      state = state.copyWith(
        archivos: state.archivos.where((a) => a != nombre).toList());


  Future<bool> enviarSolicitud() async {
    if (state.tipoSeleccionado == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = SolicitudRequestModel(
        tipoSolicitud:    state.tipoSeleccionado!.apiValue,
        justificacion:    state.justificacion,
        periodoAcademico: state.periodoAcademico,
        grupoNuevoId:     state.grupoNuevoId,
        grupoActualId:    state.grupoActualId,
        jornadaActual:    state.jornadaActual,
        jornadaNueva:     state.jornadaNueva,
      );

      final respuesta = await _repo.crearSolicitud(request);

      state = state.copyWith(
        isLoading: false,
        respuesta: respuesta,
      );

      return true;

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  void reset() => state = const NuevaSolicitudState();
}

final solicitudRepositoryProvider = Provider<SolicitudRepository>(
  (ref) => SolicitudRepository(),
);

final nuevaSolicitudProvider =
    StateNotifierProvider<NuevaSolicitudNotifier, NuevaSolicitudState>(
  (ref) => NuevaSolicitudNotifier(ref.read(solicitudRepositoryProvider)),
);