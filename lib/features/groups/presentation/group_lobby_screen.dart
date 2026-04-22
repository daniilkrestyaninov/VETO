import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:veto_app/features/auth/domain/auth_provider.dart';
import 'package:veto_app/features/groups/domain/group_provider.dart';
import 'package:veto_app/features/session/domain/session_provider.dart';
import 'package:veto_app/features/auth/presentation/widgets/brutal_text_field.dart';
import 'package:veto_app/core/theme/brutal_theme.dart';
import 'package:veto_app/shared/models/session.dart' as models;
import 'package:veto_app/shared/models/option.dart';

class GroupLobbyScreen extends ConsumerStatefulWidget {
  final String groupId;

  const GroupLobbyScreen({
    super.key,
    required this.groupId,
  });

  @override
  ConsumerState<GroupLobbyScreen> createState() => _GroupLobbyScreenState();
}

class _GroupLobbyScreenState extends ConsumerState<GroupLobbyScreen> {
  final _optionController = TextEditingController();
  bool _isAddingOption = false;
  DateTime? _lastAddTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _optionController.dispose();
    super.dispose();
  }

  void _showQrCode() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: BrutalTheme.primaryBlack,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(color: BrutalTheme.primaryWhite, width: 3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'QR-КОД ГРУППЫ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                color: BrutalTheme.primaryWhite,
                child: QrImageView(
                  data: widget.groupId,
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: BrutalTheme.primaryWhite,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: BrutalTheme.primaryBlack,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: BrutalTheme.primaryBlack,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'ЗАКРЫТЬ',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: BrutalTheme.primaryBlack,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copyGroupId() async {
    await Clipboard.setData(ClipboardData(text: widget.groupId));
    if (mounted) {
      _showSuccess('КОД ГРУППЫ СКОПИРОВАН');
    }
  }

  Future<void> _addOption() async {
    // Debounce: не позволяем добавлять чаще чем раз в секунду
    final now = DateTime.now();
    if (_lastAddTime != null &&
        now.difference(_lastAddTime!).inMilliseconds < 1000) {
      _showError('ПОДОЖДИТЕ СЕКУНДУ');
      return;
    }

    final title = _optionController.text.trim();
    final user = ref.read(currentUserProvider).value;

    if (title.isEmpty) {
      _showError('ВВЕДИТЕ ВАРИАНТ');
      return;
    }

    if (title.length < 2) {
      _showError('ВАРИАНТ СЛИШКОМ КОРОТКИЙ');
      return;
    }

    if (user == null) {
      _showError('ОШИБКА: ПОЛЬЗОВАТЕЛЬ НЕ НАЙДЕН');
      return;
    }

    // Проверяем, не существует ли уже такой вариант - пропускаем проверку
    // т.к. Stream провайдер не поддерживает синхронное чтение
    final sessionAsync = ref.read(activeSessionProvider(widget.groupId));
    final session = sessionAsync.value;

    setState(() => _isAddingOption = true);
    _lastAddTime = now;

    try {
      print('DEBUG: Начинаем добавление варианта: $title');

      if (session == null) {
        // Создаем новую сессию, если её нет
        print('DEBUG: Создаем новую сессию');
        final newSession = await ref
            .read(activeSessionProvider(widget.groupId).notifier)
            .createSession();

        print('DEBUG: Новая сессия создана: ${newSession.id}');
        await ref
            .read(sessionRepositoryProvider)
            .addOption(sessionId: newSession.id, title: title, userId: user.id);
        print('DEBUG: Вариант добавлен в новую сессию');
      } else {
        print('DEBUG: Добавляем вариант в существующую сессию');
        await ref
            .read(sessionRepositoryProvider)
            .addOption(sessionId: session.id, title: title, userId: user.id);
        print('DEBUG: Вариант добавлен');
      }

      _optionController.clear();
      print('DEBUG: Поле очищено');
    } catch (e, stackTrace) {
      print('DEBUG: Ошибка при добавлении варианта: $e');
      print('DEBUG: StackTrace: $stackTrace');
      if (mounted) {
        if (e.toString().contains('network') ||
            e.toString().contains('connection')) {
          _showError('НЕТ ПОДКЛЮЧЕНИЯ К СЕТИ');
        } else {
          _showError('ОШИБКА: ${e.toString()}');
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isAddingOption = false);
      }
    }
  }

  Future<void> _deleteOption(String optionId, String sessionId) async {
    try {
      print('DEBUG: Удаляем вариант: $optionId из сессии: $sessionId');
      await ref.read(sessionRepositoryProvider).deleteOption(optionId);
      print('DEBUG: Вариант удален успешно');
    } catch (e, stackTrace) {
      print('DEBUG: Ошибка удаления варианта: $e');
      print('DEBUG: StackTrace: $stackTrace');
      if (mounted) {
        _showError('ОШИБКА УДАЛЕНИЯ: ${e.toString()}');
      }
    }
  }

  Future<void> _startSession() async {
    final sessionAsync = ref.read(activeSessionProvider(widget.groupId));
    final session = sessionAsync.value;

    if (session == null) {
      _showError('СНАЧАЛА ДОБАВЬТЕ ВАРИАНТЫ');
      return;
    }

    // Проверка количества вариантов будет на сервере
    try {
      print('DEBUG: Starting roulette for session: ${session.id}');

      // Запускаем рулетку (выбор на сервере)
      await ref
          .read(activeSessionProvider(widget.groupId).notifier)
          .startSpinning();

      print('DEBUG: Roulette started, status changed to spinning');

      // НЕ переходим сразу - переход произойдет автоматически через listener
      // когда Realtime обновит статус сессии на 'spinning'
    } catch (e) {
      print('DEBUG: Error starting roulette: $e');
      if (mounted) {
        _showError('ОШИБКА ЗАПУСКА: ${e.toString()}');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'SpaceMono',
            fontWeight: FontWeight.bold,
            color: BrutalTheme.primaryWhite,
          ),
        ),
        backgroundColor: BrutalTheme.accentRed,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'SpaceMono',
            fontWeight: FontWeight.bold,
            color: BrutalTheme.primaryBlack,
          ),
        ),
        backgroundColor: BrutalTheme.warningYellow,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    );
  }

  Future<void> _leaveGroup() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    final membersAsync = ref.read(groupMembersWithUsersProvider(widget.groupId));
    final members = membersAsync.value ?? [];
    
    // Check if current user is owner
    bool isOwner = false;
    for (final member in members) {
      if (member['user_id'] == user.id && member['role'] == 'owner') {
        isOwner = true;
        break;
      }
    }

    if (isOwner) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: BrutalTheme.darkGray,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text(
            'ВНИМАНИЕ',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: BrutalTheme.warningYellow),
          ),
          content: Text(
            'ВЫ УВЕРЕНЫ? ГРУППА БУДЕТ ПОЛНОСТЬЮ УДАЛЕНА СО ВСЕМИ ДАННЫМИ.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: BrutalTheme.primaryWhite),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'ОТМЕНА',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: BrutalTheme.primaryWhite),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: BrutalTheme.accentRed,
                foregroundColor: BrutalTheme.primaryWhite,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('УДАЛИТЬ'),
            ),
          ],
        ),
      );

      if (confirm != true) return;
    }

    try {
      await ref.read(leaveGroupProvider(
        groupId: widget.groupId,
        userId: user.id,
        isOwner: isOwner,
      ).future);

      if (mounted) {
        context.go('/group-select');
      }
    } catch (e) {
      if (mounted) {
        _showError('ОШИБКА: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupAsync = ref.watch(groupProvider(widget.groupId));
    final sessionAsync = ref.watch(activeSessionProvider(widget.groupId));
    final user = ref.watch(currentUserProvider).value;

    // Слушаем изменения статуса сессии для автоперехода на рулетку
    ref.listen<AsyncValue<models.Session?>>(
      activeSessionProvider(widget.groupId),
      (previous, next) {
        print('DEBUG LOBBY: Session state changed');
        next.whenData((session) {
          print('DEBUG LOBBY: Session status: ${session?.status}');
          if (session != null && session.status == 'spinning') {
            print('DEBUG LOBBY: Navigating to roulette screen');
            // Автоматический переход на экран рулетки
            context.go('/session/${session.id}');
          }
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: groupAsync.when(
          data: (group) => Text(group.name.toUpperCase()),
          loading: () => const Text('ЗАГРУЗКА...'),
          error: (_, __) => const Text('ОШИБКА'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: _showQrCode,
            tooltip: 'QR-код группы',
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copyGroupId,
            tooltip: 'Скопировать код',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _leaveGroup,
            tooltip: 'Выйти из группы',
            color: BrutalTheme.accentRed,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Обновляем все данные
            ref.invalidate(groupProvider(widget.groupId));
            ref.invalidate(groupMembersWithUsersProvider(widget.groupId));
            ref.invalidate(activeSessionProvider(widget.groupId));
          },
          color: BrutalTheme.primaryWhite,
          backgroundColor: BrutalTheme.darkGray,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Код группы
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: BrutalTheme.primaryWhite, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'КОД ГРУППЫ',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _copyGroupId,
                              child: Text(
                                widget.groupId.substring(0, 8).toUpperCase() +
                                    '...',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.qr_code, size: 20),
                            onPressed: _showQrCode,
                            color: BrutalTheme.warningYellow,
                            tooltip: 'Показать QR',
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: _copyGroupId,
                            color: BrutalTheme.warningYellow,
                            tooltip: 'Копировать',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Участники
                Text(
                  'УЧАСТНИКИ',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ref.watch(groupMembersWithUsersProvider(widget.groupId)).when(
                      data: (members) {
                        if (members.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: CircularProgressIndicator(
                                color: BrutalTheme.primaryWhite,
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: members.map((member) {
                            final memberUser = member['users'];
                            
                            // Если данные пользователя еще не загрузились (неполный список)
                            if (memberUser == null) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: BrutalTheme.darkGray,
                                  border: Border.all(
                                    color: BrutalTheme.mediumGray,
                                    width: 2,
                                  ),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: BrutalTheme.primaryWhite,
                                  ),
                                ),
                              );
                            }
                            
                            final memberData = member;
                            final isOwner = memberData['role'] == 'owner';
                            final vetoTokens = memberData['veto_tokens'] as int;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: BrutalTheme.darkGray,
                                border: Border.all(
                                  color: isOwner
                                      ? BrutalTheme.warningYellow
                                      : BrutalTheme.primaryWhite,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          memberUser['username']
                                              .toString()
                                              .toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        if (isOwner)
                                          Text(
                                            'ВЛАДЕЛЕЦ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color:
                                                      BrutalTheme.warningYellow,
                                                ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: BrutalTheme.primaryWhite,
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      'ВЕТО: $vetoTokens',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: BrutalTheme.primaryWhite,
                        ),
                      ),
                      error: (error, _) => Text(
                        'ОШИБКА: $error',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: BrutalTheme.accentRed,
                            ),
                      ),
                    ),
                const SizedBox(height: 24),

                // Варианты выбора
                Text(
                  'ВАРИАНТЫ ВЫБОРА',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),

                // Список вариантов
                sessionAsync.when(
                  data: (session) {
                    if (session == null) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: BrutalTheme.mediumGray,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          'ДОБАВЬТЕ ПЕРВЫЙ ВАРИАНТ',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    // Слушаем AsyncValue напрямую
                    final optionsAsync =
                        ref.watch(sessionOptionsProvider(session.id));

                    return optionsAsync.when(
                      data: (options) {
                        if (options.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: BrutalTheme.mediumGray,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              'НЕТ ВАРИАНТОВ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return Column(
                          children: options.map((option) {
                            final isMyOption = user?.id == option.addedBy;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: BrutalTheme.darkGray,
                                border: Border.all(
                                  color: BrutalTheme.primaryWhite,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      option.title.toUpperCase(),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                  if (isMyOption)
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      color: BrutalTheme.accentRed,
                                      onPressed: () => _deleteOption(
                                        option.id,
                                        session.id,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: BrutalTheme.primaryWhite,
                        ),
                      ),
                      error: (error, _) => Text(
                        'ОШИБКА: $error',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: BrutalTheme.accentRed,
                            ),
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: BrutalTheme.primaryWhite,
                    ),
                  ),
                  error: (error, _) => Text(
                    'ОШИБКА: $error',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: BrutalTheme.accentRed,
                        ),
                  ),
                ),
                const SizedBox(height: 16),

                // Добавить вариант
                BrutalTextField(
                  controller: _optionController,
                  label: 'ДОБАВИТЬ ВАРИАНТ',
                  hint: 'Куда пойдем?',
                  enabled: !_isAddingOption,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isAddingOption ? null : _addOption,
                    child: _isAddingOption
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: BrutalTheme.primaryBlack,
                            ),
                          )
                        : Text(
                            'ДОБАВИТЬ',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: BrutalTheme.primaryBlack),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Кнопка запуска
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _startSession,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BrutalTheme.accentRed,
                      foregroundColor: BrutalTheme.primaryWhite,
                    ),
                    child: Text(
                      'ЗАПУСТИТЬ РУЛЕТКУ',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 20,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
