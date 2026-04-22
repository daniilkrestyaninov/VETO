import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:veto_app/core/config/supabase_config.dart';
import 'package:veto_app/shared/models/session.dart' as models;
import 'package:veto_app/shared/models/option.dart';
import 'package:veto_app/shared/models/veto_log.dart';

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

  // Запустить рулетку (изменить статус на spinning и выбрать случайный вариант)
  Future<models.Session> startSpinning(String sessionId) async {
    try {
      // 1. Получаем все варианты сессии
      final options = await getSessionOptions(sessionId);

      if (options.isEmpty) {
        throw Exception('Нет вариантов для выбора');
      }

      // 2. Выбираем случайный вариант НА СЕРВЕРЕ
      final random =
          options[DateTime.now().millisecondsSinceEpoch % options.length];

      // 3. Обновляем сессию: статус = spinning, selected_option_id = выбранный вариант
      final response = await _supabase
          .from('sessions')
          .update({
            'status': 'spinning',
            'selected_option_id': random.id,
          })
          .eq('id', sessionId)
          .select()
          .single();

      return models.Session.fromJson(response);
    } catch (e) {
      throw Exception('Ошибка запуска рулетки: $e');
    }
  }

  // Завершить сессию с выбранным вариантом (принять результат)
  Future<models.Session> acceptResult({
    required String sessionId,
  }) async {
    try {
      // Получаем текущую сессию
      final session = await getSession(sessionId);

      if (session.selectedOptionId == null) {
        throw Exception('Не выбран вариант');
      }

      // Меняем статус на resolved и копируем selected_option_id в final_decision_id
      final response = await _supabase
          .from('sessions')
          .update({
            'status': 'resolved',
            'final_decision_id': session.selectedOptionId,
            'resolved_at': DateTime.now().toIso8601String(),
          })
          .eq('id', sessionId)
          .select()
          .single();

      return models.Session.fromJson(response);
    } catch (e) {
      throw Exception('Ошибка принятия результата: $e');
    }
  }

  // Сбросить сессию в waiting (для владельца после принятия)
  Future<models.Session> resetSession(String sessionId) async {
    try {
      final response = await _supabase
          .from('sessions')
          .update({
            'status': 'waiting',
            'selected_option_id': null,
            'final_decision_id': null,
            'resolved_at': null,
          })
          .eq('id', sessionId)
          .select()
          .single();

      return models.Session.fromJson(response);
    } catch (e) {
      throw Exception('Ошибка сброса сессии: $e');
    }
  }

  // Подписаться на изменения всех сессий группы (Realtime)
  RealtimeChannel subscribeToGroupSessions({
    required String groupId,
    required Function(models.Session?) onSessionUpdate,
  }) {
    final channel = _supabase.channel('group_sessions:$groupId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'sessions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'group_id',
            value: groupId,
          ),
          callback: (payload) {
            if (payload.newRecord != null && payload.newRecord.isNotEmpty) {
              final session = models.Session.fromJson(payload.newRecord);
              // Если сессия активна (ожидает, крутится или сброшена в idle), обновляем
              if (session.status == 'waiting' ||
                  session.status == 'spinning' ||
                  session.status == 'idle') {
                onSessionUpdate(session);
              } else {
                // Если сессия завершена (resolved) или отменена, обнуляем активную сессию
                onSessionUpdate(null);
              }
            }
          },
        )
        .subscribe();

    return channel;
  }

  // Stream вариантов сессии (Realtime)
  Stream<List<Option>> streamSessionOptions(String sessionId) {
    late final StreamController<List<Option>> controller;
    RealtimeChannel? channel;
    List<Option> currentOptions = [];

    controller = StreamController<List<Option>>.broadcast(
      onListen: () async {
        // Начальная загрузка
        try {
          currentOptions = await getSessionOptions(sessionId);
          if (!controller.isClosed) controller.add(List.from(currentOptions));
        } catch (e) {
          if (!controller.isClosed) controller.addError(e);
        }
        
        channel = _supabase.channel('options_channel:$sessionId');
        channel!
            .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: 'options',
              // Не фильтруем по session_id, чтобы ловить удаление (где payload может не содержать session_id)
              callback: (payload) {
                bool changed = false;
                
                if (payload.eventType == PostgresChangeEvent.insert) {
                  final newRecord = payload.newRecord;
                  if (newRecord['session_id'] == sessionId) {
                    final option = Option.fromJson(newRecord);
                    if (!currentOptions.any((o) => o.id == option.id)) {
                      currentOptions.add(option);
                      changed = true;
                    }
                  }
                } else if (payload.eventType == PostgresChangeEvent.delete) {
                  final oldRecord = payload.oldRecord;
                  final deletedId = oldRecord['id'];
                  final index = currentOptions.indexWhere((o) => o.id == deletedId);
                  if (index != -1) {
                    currentOptions.removeAt(index);
                    changed = true;
                  }
                } else if (payload.eventType == PostgresChangeEvent.update) {
                  final newRecord = payload.newRecord;
                  if (newRecord['session_id'] == sessionId) {
                    final option = Option.fromJson(newRecord);
                    final index = currentOptions.indexWhere((o) => o.id == option.id);
                    if (index != -1) {
                      currentOptions[index] = option;
                    } else {
                      currentOptions.add(option);
                    }
                    changed = true;
                  }
                }
                
                if (changed && !controller.isClosed) {
                  // Сортируем по времени добавления
                  currentOptions.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                  controller.add(List.from(currentOptions));
                }
              },
            )
            .subscribe();
      },
      onCancel: () {
        if (channel != null) {
          _supabase.removeChannel(channel!);
        }
      },
    );

    return controller.stream;
  }

  // Отписаться от канала
  Future<void> unsubscribe(RealtimeChannel channel) async {
    await _supabase.removeChannel(channel);
  }

  // Проверить количество токенов вето у пользователя
  Future<int> getUserVetoTokens({
    required String groupId,
    required String userId,
  }) async {
    try {
      final response = await _supabase
          .from('group_members')
          .select('veto_tokens')
          .eq('group_id', groupId)
          .eq('user_id', userId)
          .single();

      return response['veto_tokens'] as int;
    } catch (e) {
      throw Exception('Ошибка получения токенов вето: $e');
    }
  }

  // Использовать вето (транзакция)
  Future<void> useVeto({
    required String sessionId,
    required String groupId,
    String? reason,
  }) async {
    try {
      print('DEBUG: Начинаем использование вето');
      print('DEBUG: sessionId: $sessionId, groupId: $groupId');

      // Получаем текущего пользователя
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Пользователь не авторизован');
      }
      final userId = currentUser.id;
      print('DEBUG: userId: $userId');

      // 1. Проверяем количество токенов
      final tokens = await getUserVetoTokens(groupId: groupId, userId: userId);
      print('DEBUG: Текущее количество токенов: $tokens');

      if (tokens <= 0) {
        throw Exception('У вас нет токенов вето');
      }

      // 2. Получаем текущую сессию
      final session = await getSession(sessionId);
      print('DEBUG: Статус сессии: ${session.status}');

      if (session.status != 'spinning' && session.status != 'resolved') {
        throw Exception(
            'Вето можно использовать только на активную или завершенную сессию');
      }

      // 3. Получаем выбранный вариант
      final selectedOptionId =
          session.selectedOptionId ?? session.finalDecisionId;
      if (selectedOptionId == null) {
        throw Exception('Нет выбранного варианта для вето');
      }

      // 4. Списываем токен
      print('DEBUG: Списываем токен вето');
      await _supabase
          .from('group_members')
          .update({'veto_tokens': tokens - 1})
          .eq('group_id', groupId)
          .eq('user_id', userId);

      // 5. Записываем в лог вето
      print('DEBUG: Записываем в лог вето');
      final vetoLogData = {
        'session_id': sessionId,
        'user_id': userId,
        'vetoed_option_id': selectedOptionId,
        'reason': reason,
        'used_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('veto_logs').insert(vetoLogData);

      // 6. Удаляем вариант из options
      print('DEBUG: Удаляем вариант $selectedOptionId');
      await _supabase.from('options').delete().eq('id', selectedOptionId);

      // 7. Сбрасываем сессию в idle
      print('DEBUG: Сбрасываем сессию в idle');
      await _supabase.from('sessions').update({
        'status': 'idle',
        'selected_option_id': null,
        'final_decision_id': null,
        'resolved_at': null,
      }).eq('id', sessionId);

      print('DEBUG: Вето успешно использовано');
    } catch (e) {
      print('DEBUG: Ошибка при использовании вето: $e');
      throw Exception('Ошибка использования вето: $e');
    }
  }

  // Получить историю вето для сессии
  Future<List<VetoLog>> getVetoLogs(String sessionId) async {
    try {
      final response = await _supabase
          .from('veto_logs')
          .select()
          .eq('session_id', sessionId)
          .order('used_at', ascending: false);

      return (response as List).map((item) => VetoLog.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Ошибка получения истории вето: $e');
    }
  }

  // Подписаться на изменения вето логов (Realtime)
  RealtimeChannel subscribeToVetoLogs({
    required String sessionId,
    required Function(List<VetoLog>) onVetoLogsUpdate,
  }) {
    final channel = _supabase.channel('veto_logs:$sessionId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'veto_logs',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'session_id',
            value: sessionId,
          ),
          callback: (payload) async {
            // Перезагружаем все логи при любом изменении
            final logs = await getVetoLogs(sessionId);
            onVetoLogsUpdate(logs);
          },
        )
        .subscribe();

    return channel;
  }
}
