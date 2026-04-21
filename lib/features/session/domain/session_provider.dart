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

    // Подписываемся на изменения, если сессия существует
    if (session != null) {
      _subscribeToSession(session.id);
    }

    // Отписываемся при dispose
    ref.onDispose(() {
      _unsubscribe();
    });

    return session;
  }

  void _subscribeToSession(String sessionId) {
    final repo = ref.read(sessionRepositoryProvider);
    _sessionChannel = repo.subscribeToSession(
      sessionId: sessionId,
      onSessionUpdate: (session) {
        state = AsyncValue.data(session);
      },
    );
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
    _subscribeToSession(session.id);

    return session;
  }

  // Запустить рулетку
  Future<void> startSpinning() async {
    final currentSession = state.value;
    if (currentSession == null) return;

    final repo = ref.read(sessionRepositoryProvider);
    await repo.startSpinning(currentSession.id);
  }
}

// Провайдер вариантов сессии с Realtime
@riverpod
class SessionOptions extends _$SessionOptions {
  RealtimeChannel? _optionsChannel;

  @override
  Future<List<Option>> build(String sessionId) async {
    final repo = ref.watch(sessionRepositoryProvider);
    final options = await repo.getSessionOptions(sessionId);

    // Подписываемся на изменения вариантов
    _subscribeToOptions();

    // Отписываемся при dispose
    ref.onDispose(() {
      _unsubscribe();
    });

    return options;
  }

  void _subscribeToOptions() {
    final repo = ref.read(sessionRepositoryProvider);
    _optionsChannel = repo.subscribeToOptions(
      sessionId: sessionId,
      onOptionsUpdate: (options) {
        state = AsyncValue.data(options);
      },
    );
  }

  void _unsubscribe() {
    if (_optionsChannel != null) {
      final repo = ref.read(sessionRepositoryProvider);
      repo.unsubscribe(_optionsChannel!);
      _optionsChannel = null;
    }
  }

  // Добавить вариант
  Future<void> addOption({
    required String title,
    required String userId,
  }) async {
    final repo = ref.read(sessionRepositoryProvider);
    await repo.addOption(
      sessionId: sessionId,
      title: title,
      userId: userId,
    );
    // Realtime автоматически обновит список
  }

  // Удалить вариант
  Future<void> deleteOption(String optionId) async {
    final repo = ref.read(sessionRepositoryProvider);
    await repo.deleteOption(optionId);
    // Realtime автоматически обновит список
  }
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
    required String userId,
    String? reason,
  }) async {
    final repo = ref.read(sessionRepositoryProvider);
    await repo.useVeto(
      sessionId: sessionId,
      groupId: groupId,
      userId: userId,
      reason: reason,
    );
    // Realtime автоматически обновит список
  }
}
