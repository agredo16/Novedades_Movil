import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/historial_model.dart';
import '../data/repositories/historial_repository.dart';

// Estado
class HistorialState {
  final List<HistorialSolicitudModel> solicitudes;
  final List<HistorialSolicitudModel> filtradas;
  final bool isLoading;
  final String? error;
  final FiltroHistorial filtro;
  final String busqueda;

  const HistorialState({
    this.solicitudes = const [],
    this.filtradas   = const [],
    this.isLoading   = false,
    this.error,
    this.filtro      = FiltroHistorial.todos,
    this.busqueda    = '',
  });

  HistorialState copyWith({
    List<HistorialSolicitudModel>? solicitudes,
    List<HistorialSolicitudModel>? filtradas,
    bool? isLoading,
    String? error,
    FiltroHistorial? filtro,
    String? busqueda,
  }) {
    return HistorialState(
      solicitudes: solicitudes ?? this.solicitudes,
      filtradas:   filtradas   ?? this.filtradas,
      isLoading:   isLoading   ?? this.isLoading,
      error:       error,
      filtro:      filtro      ?? this.filtro,
      busqueda:    busqueda    ?? this.busqueda,
    );
  }
}

enum FiltroHistorial { todos, pendientes, aprobados, rechazados }

class HistorialNotifier extends StateNotifier<HistorialState> {
  final HistorialRepository _repo;

  HistorialNotifier(this._repo) : super(const HistorialState()) {
    cargar();
  }

  Future<void> cargar() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final solicitudes = await _repo.getMisSolicitudes();
      state = state.copyWith(
        solicitudes: solicitudes,
        filtradas:   solicitudes,
        isLoading:   false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void cambiarFiltro(FiltroHistorial filtro) {
    state = state.copyWith(filtro: filtro);
    _aplicarFiltros();
  }

  void buscar(String texto) {
    state = state.copyWith(busqueda: texto);
    _aplicarFiltros();
  }

  void _aplicarFiltros() {
    var lista = state.solicitudes;

    // Filtro por estado
    switch (state.filtro) {
      case FiltroHistorial.pendientes:
        lista = lista.where((s) => s.estado == 'PENDIENTE').toList();
        break;
      case FiltroHistorial.aprobados:
        lista = lista.where((s) => s.estado == 'APROBADO').toList();
        break;
      case FiltroHistorial.rechazados:
        lista = lista.where((s) => s.estado == 'RECHAZADO').toList();
        break;
      default:
        break;
    }

    // Filtro por búsqueda
    if (state.busqueda.isNotEmpty) {
      final q = state.busqueda.toLowerCase();
      lista = lista.where((s) =>
        s.tipoLabel.toLowerCase().contains(q) ||
        s.codigoSolicitud.toLowerCase().contains(q) ||
        s.justificacion.toLowerCase().contains(q),
      ).toList();
    }

    state = state.copyWith(filtradas: lista);
  }
}

final historialRepositoryProvider = Provider<HistorialRepository>(
  (ref) => HistorialRepository(),
);

final historialProvider =
    StateNotifierProvider<HistorialNotifier, HistorialState>(
  (ref) => HistorialNotifier(ref.read(historialRepositoryProvider)),
);