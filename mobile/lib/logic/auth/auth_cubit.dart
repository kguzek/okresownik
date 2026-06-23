import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState());

  Future<void> checkAuth() async {
    emit(state.copyWith(status: AuthStatus.loading));

    final loggedIn = await _repository.isLoggedIn();
    if (loggedIn) {
      final user = await _repository.getSavedUser();
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final result = await _repository.register(
        email: email,
        password: password,
        name: name,
      );
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: result.user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final result = await _repository.login(
        email: email,
        password: password,
      );
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: result.user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
