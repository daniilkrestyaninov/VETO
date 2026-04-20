import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:veto_app/core/config/supabase_config.dart';
import 'package:veto_app/shared/models/session.dart' as models;
import 'package:veto_app/shared/models/option.dart';

class SessionRepository {
  final SupabaseClient _supabase = SupabaseConfig.client;

  // Создать новую сессию
  Future<models.Session> createSession({
    required String groupId,
  }) async {
    try {
      final sessionData = {
        'group_id': groupId,
        'status': 'waiting',
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('sessions')
          .insert(sessionData)
          .select()
          .single();

      return models.Session.fromJson(response);
    } catch (e) {
      throw Exception('Ошибка создания сессии: $e');
    }
  }

  // Получить активную сессию группы
  Future<models.Session?> getActiveSession(String groupId) async {
    try {
      final response = await _supabase
          .from('sessions')
          .select()
          .eq('group_id', groupId)
          .inFilter('status', ['waiting', 'spinning'])
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;

      return models.Session.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Получить сессию по ID
  Future<models.Session> getSession(String sessionId) async {
    try {
      final response = await _supabase
          .from('sessions')
          .select()
          .eq('id', sessionId)
          .single();

      return models.Session.fromJson(response);
    } catch (e) {
      throw Exception('Ошибка получения сессии: $e');
    }
  }

  // Добавить вариант выбора
  Future<Option> addOption({
    required String sessionId,
    required String title,
    required String userId,
  }) async {
    try {
      final optionData = {
        'session_id': sessionId,
        'title': title,
        'added_by': userId,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response =
          await _supabase.from('options').insert(optionData).select().single();

      return Option.fromJson(response);
    } catch (e) {
      throw Exception('Ошибка добавления варианта: $e');
    }
  }

  // Получить все варианты сессии
  Future<List<Option>> getSessionOptions(String sessionId) async {
    try {
      final response = await _supabase
          .from('options')
          .select()
          .eq('session_id', sessionId)
          .order('created_at', ascending: true);

      return (response as List).map((item) => Option.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Ошибка получения вариантов: $e');
    }
  }

  // Удалить вариант
  Future<void> deleteOption(String optionId) async {
    try {
      await _supabase.from('options').delete().eq('id', optionId);
    } catch (e) {
      throw Exception('Ошибка удаления варианта: $e');
    }
  }

  // Запустить рулетку (изменить статус на spinning)
  Future<models.Session> startSpinning(String sessionId) async {
    try {
      final response = await _supabase
          .from('sessions')
          .update({'status': 'spinning'})
          .eq('id', sessionId)
          .select()
          .single();

      return models.Session.fromJson(response);
    } catch (e) {
      throw Exception('Ошибка запуска рулетки: $e');
    }
  }

  // Завершить сессию с выбранным вариантом
  Future<models.Session> resolveSession({
    required String sessionId,
    required String finalDecisionId,
  }) async {
    try {
      final response = await _supabase
          .from('sessions')
          .update({
            'status': 'resolved',
            'final_decision_id': finalDecisionId,
            'resolved_at': DateTime.now().toIso8601String(),
          })
          .eq('id', sessionId)
          .select()
          .single();

      return models.Session.fromJson(response);
    } catch (e) {
      throw Exception('Ошибка завершения сессии: $e');
    }
  }

  // Подписаться на изменения сессии (Realtime)
  RealtimeChannel subscribeToSession({
    required String sessionId,
    required Function(models.Session) onSessionUpdate,
  }) {
    final channel = _supabase.channel('session:$sessionId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'sessions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: sessionId,
          ),
          callback: (payload) {
            final session = models.Session.fromJson(payload.newRecord);
            onSessionUpdate(session);
          },
        )
        .subscribe();

    return channel;
  }

  // Подписаться на изменения вариантов (Realtime)
  RealtimeChannel subscribeToOptions({
    required String sessionId,
    required Function(List<Option>) onOptionsUpdate,
  }) {
    final channel = _supabase.channel('options:$sessionId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'options',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'session_id',
            value: sessionId,
          ),
          callback: (payload) async {
            // Перезагружаем все варианты при любом изменении
            final options = await getSessionOptions(sessionId);
            onOptionsUpdate(options);
          },
        )
        .subscribe();

    return channel;
  }

  // Отписаться от канала
  Future<void> unsubscribe(RealtimeChannel channel) async {
    await _supabase.removeChannel(channel);
  }
}
