import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/perfil_model.dart';
import '../data/repositories/perfil_repository.dart';

class PerfilState {
  final PerfilModel? perfil;
  final bool isLoading;
  final String? error;

  const PerfilState({
    this.perfil,
    this.isLoading = false,
    this.error,
  });

  PerfilState copyWith({
    PerfilModel? perfil,
    bool? isLoading,
    String? error,
  }) {
    return PerfilState(
      perfil:    perfil    ?? this.perfil,
      isLoading: isLoading ?? this.isLoading,
      error:     error,
    );
  }
}

class PerfilNotifier extends StateNotifier<PerfilState> {
  final PerfilRepository _repo;

  PerfilNotifier(this._repo) : super(const PerfilState()) {
    cargar();
  }

  Future<void> cargar() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final perfil = await _repo.getPerfil();
      state = state.copyWith(perfil: perfil, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}

final perfilRepositoryProvider = Provider<PerfilRepository>(
  (ref) => PerfilRepository(),
);

final perfilProvider = StateNotifierProvider<PerfilNotifier, PerfilState>(
  (ref) => PerfilNotifier(ref.read(perfilRepositoryProvider)),
);