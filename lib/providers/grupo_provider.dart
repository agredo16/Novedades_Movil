import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/grupo_model.dart';
import '../data/repositories/grupo_repository.dart';

class GrupoState {
  final List<GrupoModel> grupos;
  final bool isLoading;
  final String? error;

  const GrupoState({
    this.grupos    = const [],
    this.isLoading = false,
    this.error,
  });

  GrupoState copyWith({
    List<GrupoModel>? grupos,
    bool? isLoading,
    String? error,
  }) {
    return GrupoState(
      grupos:    grupos    ?? this.grupos,
      isLoading: isLoading ?? this.isLoading,
      error:     error,
    );
  }
}

class GrupoNotifier extends StateNotifier<GrupoState> {
  final GrupoRepository _repo;

  GrupoNotifier(this._repo) : super(const GrupoState()) {
    cargar();
  }

  Future<void> cargar({String periodo = '2026-1'}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final grupos = await _repo.getGrupos(periodo: periodo);
      state = state.copyWith(grupos: grupos, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}

final grupoRepositoryProvider = Provider<GrupoRepository>(
  (ref) => GrupoRepository(),
);

final grupoProvider =
    StateNotifierProvider<GrupoNotifier, GrupoState>(
  (ref) => GrupoNotifier(ref.read(grupoRepositoryProvider)),
);