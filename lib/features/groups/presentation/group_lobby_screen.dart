import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veto_app/features/auth/domain/auth_provider.dart';
import 'package:veto_app/features/groups/domain/group_provider.dart';
import 'package:veto_app/features/session/domain/session_provider.dart';
import 'package:veto_app/features/auth/presentation/widgets/brutal_text_field.dart';
import 'package:veto_app/core/theme/brutal_theme.dart';

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

  @override
  void dispose() {
    _optionController.dispose();
    super.dispose();
  }

  Future<void> _copyGroupId() async {
    await Clipboard.setData(ClipboardData(text: widget.groupId));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('КОД ГРУППЫ СКОПИРОВАН'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _addOption() async {
    final title = _optionController.text.trim();
    final user = ref.read(currentUserProvider).value;

    if (title.isEmpty) {
      _showError('ВВЕДИТЕ ВАРИАНТ');
      return;
    }

    if (user == null) {
      _showError('ОШИБКА: ПОЛЬЗОВАТЕЛЬ НЕ НАЙДЕН');
      return;
    }

    setState(() => _isAddingOption = true);

    try {
      print('DEBUG: Начинаем добавление варианта: $title');
      final sessionAsync = ref.read(activeSessionProvider(widget.groupId));
      final session = sessionAsync.value;

      print('DEBUG: Текущая сессия: ${session?.id}');

      if (session == null) {
        // Создаем новую сессию, если её нет
        print('DEBUG: Создаем новую сессию');
        final newSession = await ref
            .read(activeSessionProvider(widget.groupId).notifier)
            .createSession();

        print('DEBUG: Новая сессия создана: ${newSession.id}');
        await ref
            .read(sessionOptionsProvider(newSession.id).notifier)
            .addOption(title: title, userId: user.id);
        print('DEBUG: Вариант добавлен в новую сессию');
      } else {
        print('DEBUG: Добавляем вариант в существующую сессию');
        await ref
            .read(sessionOptionsProvider(session.id).notifier)
            .addOption(title: title, userId: user.id);
        print('DEBUG: Вариант добавлен');
      }

      _optionController.clear();
      print('DEBUG: Поле очищено');
    } catch (e, stackTrace) {
      print('DEBUG: Ошибка при добавлении варианта: $e');
      print('DEBUG: StackTrace: $stackTrace');
      if (mounted) {
        _showError('ОШИБКА: ${e.toString()}');
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
      await ref
          .read(sessionOptionsProvider(sessionId).notifier)
          .deleteOption(optionId);
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

    final optionsAsync = ref.read(sessionOptionsProvider(session.id));
    final options = optionsAsync.value ?? [];

    if (options.length < 2) {
      _showError('НУЖНО МИНИМУМ 2 ВАРИАНТА');
      return;
    }

    try {
      await ref
          .read(activeSessionProvider(widget.groupId).notifier)
          .startSpinning();

      if (mounted) {
        context.go('/session/${session.id}');
      }
    } catch (e) {
      if (mounted) {
        _showError('ОШИБКА ЗАПУСКА: ${e.toString()}');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: BrutalTheme.accentRed,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupAsync = ref.watch(groupProvider(widget.groupId));
    final membersAsync =
        ref.watch(groupMembersWithUsersProvider(widget.groupId));
    final sessionAsync = ref.watch(activeSessionProvider(widget.groupId));
    final user = ref.watch(currentUserProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: groupAsync.when(
          data: (group) => Text(group.name.toUpperCase()),
          loading: () => const Text('ЗАГРУЗКА...'),
          error: (_, __) => const Text('ОШИБКА'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _copyGroupId,
            tooltip: 'Поделиться кодом',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Код группы
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: BrutalTheme.primaryWhite, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'КОД ГРУППЫ',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _copyGroupId,
                      child: Text(
                        widget.groupId,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontFamily: 'monospace',
                            ),
                        textAlign: TextAlign.center,
                      ),
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
              membersAsync.when(
                data: (members) {
                  if (members.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: BrutalTheme.mediumGray,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        'НЕТ УЧАСТНИКОВ',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return Column(
                    children: members.map((member) {
                      final memberUser = member['users'];
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            color: BrutalTheme.warningYellow,
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
                                style: Theme.of(context).textTheme.labelLarge,
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
    );
  }
}
