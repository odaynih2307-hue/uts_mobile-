import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

// --- Injection Providers ---
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main.dart');
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(sharedPreferences: ref.watch(sharedPreferencesProvider));
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

// --- Auth State ---
class AuthState {
  final bool isLoading;
  final User? user;
  final String? errorMessage;

  const AuthState({this.isLoading = false, this.user, this.errorMessage});

  AuthState copyWith({bool? isLoading, User? user, String? errorMessage}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage, // We don't always retain error message
    );
  }
}

// --- Auth Notifier ---
class AuthNotifier extends Notifier<AuthState> {
  late AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    // Menjalankan checkStatus saat provider diinisialisasi pertama kali
    Future.microtask(() => checkStatus());
    return const AuthState();
  }

  Future<void> checkStatus() async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.checkAuthStatus();
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, user: null),
      (user) => state = state.copyWith(isLoading: false, user: user),
    );
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _repository.login(username, password);
    
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user);
        return true;
      },
    );
  }

  Future<bool> register(String username, String password, String name) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _repository.register(username, password, name);
    
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user);
        return true;
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _repository.logout();
    state = const AuthState(); // Reset back to default (no user)
  }
}

// --- Notifier Provider ---
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
