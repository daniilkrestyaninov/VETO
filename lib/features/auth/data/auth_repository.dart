import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:veto_app/core/config/supabase_config.dart';
import 'package:veto_app/shared/models/user.dart' as models;

class AuthRepository {
  final SupabaseClient _supabase = SupabaseConfig.client;

  // Получить текущего пользователя
  User? get currentUser => _supabase.auth.currentUser;

  // Проверка авторизации
  bool get isAuthenticated => currentUser != null;

  // Регистрация нового пользователя
  Future<models.User> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      print('DEBUG: Начинаем регистрацию с email: $email, username: $username');

      // Регистрация через Supabase Auth
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      print('DEBUG: Auth response получен, user: ${authResponse.user?.id}');

      if (authResponse.user == null) {
        throw Exception('Ошибка регистрации');
      }

      // Создание записи в таблице users
      final userData = {
        'id': authResponse.user!.id,
        'username': username,
        'created_at': DateTime.now().toIso8601String(),
      };

      print('DEBUG: Создаем запись в таблице users: $userData');
      await _supabase.from('users').insert(userData);
      print('DEBUG: Запись в users создана успешно');

      return models.User.fromJson({
        ...userData,
        'avatar_url': null,
      });
    } catch (e) {
      print('DEBUG: Ошибка в signUp: $e');
      throw Exception('Ошибка регистрации: $e');
    }
  }

  // Вход существующего пользователя
  Future<models.User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Ошибка входа');
      }

      // Получаем данные пользователя из таблицы users
      final userResponse = await _supabase
          .from('users')
          .select()
          .eq('id', authResponse.user!.id)
          .single();

      return models.User.fromJson(userResponse);
    } catch (e) {
      throw Exception('Ошибка входа: $e');
    }
  }

  // Анонимный вход (для быстрого старта)
  Future<models.User> signInAnonymously({required String username}) async {
    try {
      print('DEBUG: Начинаем анонимный вход с именем: $username');

      // Сначала выходим из текущей сессии, если она есть
      if (isAuthenticated) {
        print('DEBUG: Выходим из текущей сессии');
        await signOut();
      }

      print('DEBUG: Проверяем, существует ли пользователь с именем: $username');

      // Проверяем, есть ли уже пользователь с таким именем
      final existingUsers = await _supabase
          .from('users')
          .select()
          .eq('username', username)
          .limit(1);

      if (existingUsers.isNotEmpty) {
        print('DEBUG: Пользователь найден, используем существующего');
        final existingUser = models.User.fromJson(existingUsers.first);

        // Пытаемся войти с сохраненными данными
        // Для анонимных пользователей используем email из базы
        final userEmail = '${existingUser.id}@anon.veto';
        final userPassword = existingUser.id;

        try {
          print('DEBUG: Пытаемся войти с существующими данными');
          await _supabase.auth.signInWithPassword(
            email: userEmail,
            password: userPassword,
          );
          print('DEBUG: Вход выполнен успешно');
        } catch (e) {
          print('DEBUG: Не удалось войти, создаем новую сессию: $e');
          // Если не удалось войти, возвращаем данные пользователя
          // (возможно, это старый пользователь без auth записи)
        }

        return existingUser;
      }

      print('DEBUG: Пользователь не найден, создаем нового');
      // Генерируем уникальный ID для нового пользователя
      final userId = DateTime.now().millisecondsSinceEpoch.toString();
      final randomEmail = '$userId@anon.veto';
      final randomPassword = userId;

      return await signUp(
        email: randomEmail,
        password: randomPassword,
        username: username,
      );
    } catch (e) {
      print('DEBUG: Ошибка в signInAnonymously: $e');
      throw Exception('Ошибка анонимного входа: $e');
    }
  }

  // Выход
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Ошибка выхода: $e');
    }
  }

  // Получить данные текущего пользователя из таблицы users
  Future<models.User?> getCurrentUserData() async {
    try {
      if (!isAuthenticated) return null;

      final userResponse = await _supabase
          .from('users')
          .select()
          .eq('id', currentUser!.id)
          .single();

      return models.User.fromJson(userResponse);
    } catch (e) {
      return null;
    }
  }

  // Обновить профиль пользователя
  Future<models.User> updateProfile({
    required String userId,
    String? username,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      final response = await _supabase
          .from('users')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return models.User.fromJson(response);
    } catch (e) {
      throw Exception('Ошибка обновления профиля: $e');
    }
  }
}
