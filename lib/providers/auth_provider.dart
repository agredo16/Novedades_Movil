import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user:            user ?? this.user,
      isLoading:       isLoading ?? this.isLoading,
      error:           error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AuthState()) {
    _checkSession();
  }

  Future<void> _checkSession() async {
    final isLogged = await _repo.isLoggedIn();
    if (isLogged) {
      state = state.copyWith(isAuthenticated: true);
    }
  }

  Future<void> login({
    required String codigo,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _repo.login(
        codigoEstudiantil: codigo,
        password: password,
      );
      state = state.copyWith(
        user:            user,
        isLoading:       false,
        isAuthenticated: true,   
        error:           null,
      );
    }  catch (e) {
  state = state.copyWith(
    isLoading:       false,
    isAuthenticated: false,
    user:            null,
    error:           e.toString()
        .replaceAll('Exception: ', '')
        .replaceAll('DioException', '')
        .trim(),
  );
}
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState();
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
);