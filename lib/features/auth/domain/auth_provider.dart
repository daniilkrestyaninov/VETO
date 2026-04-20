import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:veto_app/features/auth/data/auth_repository.dart';
import 'package:veto_app/shared/models/user.dart';

part 'auth_provider.g.dart';

// Провайдер репозитория
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository();
}

// Провайдер текущего пользователя
@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  Future<User?> build() async {
    final authRepo = ref.watch(authRepositoryProvider);
    return await authRepo.getCurrentUserData();
  }

  // Анонимный вход
  Future<void> signInAnonymously(String username) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      return await authRepo.signInAnonymously(username: username);
    });
  }

  // Регистрация
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      return await authRepo.signUp(
        email: email,
        password: password,
        username: username,
      );
    });
  }

  // Вход
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      return await authRepo.signIn(email: email, password: password);
    });
  }

  // Выход
  Future<void> signOut() async {
    final authRepo = ref.read(authRepositoryProvider);
    await authRepo.signOut();
    state = const AsyncValue.data(null);
  }

  // Обновить профиль
  Future<void> updateProfile({
    String? username,
    String? avatarUrl,
  }) async {
    final currentState = state.value;
    if (currentState == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      return await authRepo.updateProfile(
        userId: currentState.id,
        username: username,
        avatarUrl: avatarUrl,
      );
    });
  }
}
