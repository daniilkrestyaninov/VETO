import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:veto_app/features/session/data/session_repository.dart';
import 'package:veto_app/shared/models/session.dart' as models;
import 'package:veto_app/shared/models/option.dart';
import 'package:veto_app/shared/models/veto_log.dart';

part 'session_provider.g.dart';

// Провайдер репозитория
@riverpod
SessionRepository sessionRepository(SessionRepositoryRef ref) {
  return SessionRepository();
}

// Провайдер активной сессии группы
@riverpod
class ActiveSession extends _$ActiveSession {
  RealtimeChannel? _sessionChannel;

  @override
  Future<models.Session?> build(String groupId) async {
    final repo = ref.watch(sessionRepositoryProvider);
    final session = await repo.getActiveSession(groupId);

    // Подписываемся на изменения ВСЕХ сессий группы (Realtime)
    _subscribeToGroupSessions(groupId);

    // Отписываемся при dispose
    ref.onDispose(() {
      _unsubscribe();
    });

    return session;
  }

  void _subscribeToGroupSessions(String groupId) {
    final repo = ref.read(sessionRepositoryProvider);
    _sessionChannel = repo.subscribeToGroupSessions(
      groupId: groupId,
      onSessionUpdate: (models.Session? session) {
        state = AsyncValue.data(session);

        // Автоматический переход на рулетку при статусе spinning
        if (session != null && session.status == 'spinning') {
          _navigateToRoulette(session.id);
        }
      },
    );
  }

  void _navigateToRoulette(String sessionId) {
    // Используем callback для навигации из UI
    // UI должен подписаться на изменения сессии
  }

  void _unsubscribe() {
    if (_sessionChannel != null) {
      final repo = ref.read(sessionRepositoryProvider);
      repo.unsubscribe(_sessionChannel!);
      _sessionChannel = null;
    }
  }

  // Создать новую сессию
  Future<models.Session> createSession() async {
    final repo = ref.read(sessionRepositoryProvider);
    final session = await repo.createSession(groupId: groupId);

    state = AsyncValue.data(session);
    // Realtime подписка уже активна для группы, так что она обработает изменения

    return session;
  }

  // Запустить рулетку
  Future<void> startSpinning() async {
    final currentSession = state.value;
    if (currentSession == null) return;

    final repo = ref.read(sessionRepositoryProvider);
    await repo.startSpinning(currentSession.id);
    // Realtime автоматически обновит состояние
  }

  // Принять результат
  Future<void> acceptResult() async {
    final currentSession = state.value;
    if (currentSession == null) return;

    final repo = ref.read(sessionRepositoryProvider);
    await repo.acceptResult(sessionId: currentSession.id);
    // Realtime автоматически обновит состояние
  }

  // Сбросить сессию (для владельца)
  Future<void> resetSession() async {
    final currentSession = state.value;
    if (currentSession == null) return;

    final repo = ref.read(sessionRepositoryProvider);
    await repo.resetSession(currentSession.id);
    // Realtime автоматически обновит состояние
  }
}

// Провайдер вариантов сессии с Stream
@riverpod
Stream<List<Option>> sessionOptions(SessionOptionsRef ref, String sessionId) {
  final repo = ref.watch(sessionRepositoryProvider);
  return repo.streamSessionOptions(sessionId);
}

// Провайдер конкретной сессии по ID
@riverpod
Future<models.Session> session(SessionRef ref, String sessionId) async {
  final repo = ref.watch(sessionRepositoryProvider);
  return await repo.getSession(sessionId);
}

// Провайдер количества токенов вето пользователя
@riverpod
Future<int> userVetoTokens(
  UserVetoTokensRef ref, {
  required String groupId,
  required String userId,
}) async {
  final repo = ref.watch(sessionRepositoryProvider);
  return await repo.getUserVetoTokens(groupId: groupId, userId: userId);
}

// Провайдер истории вето для сессии
@riverpod
class VetoLogs extends _$VetoLogs {
  RealtimeChannel? _vetoLogsChannel;

  @override
  Future<List<VetoLog>> build(String sessionId) async {
    final repo = ref.watch(sessionRepositoryProvider);
    final logs = await repo.getVetoLogs(sessionId);

    // Подписываемся на изменения логов вето
    _subscribeToVetoLogs();

    // Отписываемся при dispose
    ref.onDispose(() {
      _unsubscribe();
    });

    return logs;
  }

  void _subscribeToVetoLogs() {
    final repo = ref.read(sessionRepositoryProvider);
    _vetoLogsChannel = repo.subscribeToVetoLogs(
      sessionId: sessionId,
      onVetoLogsUpdate: (logs) {
        state = AsyncValue.data(logs);
      },
    );
  }

  void _unsubscribe() {
    if (_vetoLogsChannel != null) {
      final repo = ref.read(sessionRepositoryProvider);
      repo.unsubscribe(_vetoLogsChannel!);
      _vetoLogsChannel = null;
    }
  }

  // Использовать вето
  Future<void> useVeto({
    required String groupId,
    String? reason,
  }) async {
    final repo = ref.read(sessionRepositoryProvider);
    await repo.useVeto(
      sessionId: sessionId,
      groupId: groupId,
      reason: reason,
    );
    // Realtime автоматически обновит список
  }
}
