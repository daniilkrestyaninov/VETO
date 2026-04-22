import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veto_app/features/auth/domain/auth_provider.dart';
import 'package:veto_app/features/groups/domain/group_provider.dart';
import 'package:veto_app/features/auth/presentation/widgets/brutal_text_field.dart';
import 'package:veto_app/core/theme/brutal_theme.dart';

class GroupSelectScreen extends ConsumerStatefulWidget {
  const GroupSelectScreen({super.key});

  @override
  ConsumerState<GroupSelectScreen> createState() => _GroupSelectScreenState();
}

class _GroupSelectScreenState extends ConsumerState<GroupSelectScreen> {
  final _groupNameController = TextEditingController();
  final _groupIdController = TextEditingController();
  bool _isCreating = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _groupNameController.dispose();
    _groupIdController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateGroup() async {
    final groupName = _groupNameController.text.trim();
    final user = ref.read(currentUserProvider).value;

    if (user == null) {
      _showError('ОШИБКА: ПОЛЬЗОВАТЕЛЬ НЕ НАЙДЕН');
      return;
    }

    if (groupName.isEmpty) {
      _showError('ВВЕДИТЕ НАЗВАНИЕ ГРУППЫ');
      return;
    }

    if (groupName.length < 3) {
      _showError('НАЗВАНИЕ СЛИШКОМ КОРОТКОЕ (МИН. 3 СИМВОЛА)');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final group = await ref.read(createGroupProvider(
        groupName: groupName,
        userId: user.id,
      ).future);

      if (mounted) {
        context.go('/lobby/${group.id}');
      }
    } catch (e) {
      if (mounted) {
        _showError('ОШИБКА: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleJoinGroup() async {
    final groupId = _groupIdController.text.trim();
    final user = ref.read(currentUserProvider).value;

    if (user == null) {
      _showError('ОШИБКА: ПОЛЬЗОВАТЕЛЬ НЕ НАЙДЕН');
      return;
    }

    if (groupId.isEmpty) {
      _showError('ВВЕДИТЕ КОД ГРУППЫ');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(joinGroupProvider(
        groupId: groupId,
        userId: user.id,
      ).future);

      if (mounted) {
        context.go('/lobby/$groupId');
      }
    } catch (e) {
      if (mounted) {
        _showError('ОШИБКА: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openScanner() async {
    final result = await context.push<String>('/qr-scanner');
    if (result != null && result.isNotEmpty) {
      _groupIdController.text = result;
      _handleJoinGroup();
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
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ВЫБОР ГРУППЫ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(currentUserProvider.notifier).signOut();
              if (mounted) {
                context.go('/auth');
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: userAsync.when(
          data: (user) {
            if (user == null) {
              // Используем Future.microtask вместо addPostFrameCallback
              Future.microtask(() {
                if (mounted) {
                  context.go('/auth');
                }
              });
              return const SizedBox.shrink();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Приветствие
                  Text(
                    'ПРИВЕТ, ${user.username.toUpperCase()}',
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 3,
                    color: BrutalTheme.primaryWhite,
                  ),
                  const SizedBox(height: 32),

                  // Переключатель режима
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isCreating = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: _isCreating
                                  ? BrutalTheme.primaryWhite
                                  : BrutalTheme.darkGray,
                              border: Border.all(
                                color: BrutalTheme.primaryWhite,
                                width: 3,
                              ),
                            ),
                            child: Text(
                              'СОЗДАТЬ',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: _isCreating
                                        ? BrutalTheme.primaryBlack
                                        : BrutalTheme.primaryWhite,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isCreating = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: !_isCreating
                                  ? BrutalTheme.primaryWhite
                                  : BrutalTheme.darkGray,
                              border: Border.all(
                                color: BrutalTheme.primaryWhite,
                                width: 3,
                              ),
                            ),
                            child: Text(
                              'ВОЙТИ',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: !_isCreating
                                        ? BrutalTheme.primaryBlack
                                        : BrutalTheme.primaryWhite,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Форма создания группы
                  if (_isCreating) ...[
                    Text(
                      'СОЗДАТЬ НОВУЮ ГРУППУ',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    BrutalTextField(
                      controller: _groupNameController,
                      label: 'НАЗВАНИЕ ГРУППЫ',
                      hint: 'Куда пойдем?',
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleCreateGroup,
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: BrutalTheme.primaryBlack,
                                ),
                              )
                            : Text(
                                'СОЗДАТЬ ГРУППУ',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(color: BrutalTheme.primaryBlack),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: BrutalTheme.primaryWhite,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'КАК ЭТО РАБОТАЕТ:',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '1. Создайте группу\n2. Поделитесь кодом с друзьями\n3. Добавьте варианты выбора\n4. Запустите рулетку\n5. Подчинитесь решению',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Форма входа в группу
                  if (!_isCreating) ...[
                    Text(
                      'ВОЙТИ В ГРУППУ',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: BrutalTextField(
                            controller: _groupIdController,
                            label: 'КОД ГРУППЫ',
                            hint: 'Вставьте код группы',
                            enabled: !_isLoading,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          margin: const EdgeInsets.only(top: 24), // Выравниваем с полем ввода
                          height: 60,
                          width: 60,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _openScanner,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: BrutalTheme.warningYellow,
                              padding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              side: const BorderSide(color: BrutalTheme.primaryWhite, width: 2),
                            ),
                            child: const Icon(
                              Icons.qr_code_scanner,
                              color: BrutalTheme.primaryBlack,
                              size: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleJoinGroup,
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: BrutalTheme.primaryBlack,
                                ),
                              )
                            : Text(
                                'ВОЙТИ В ГРУППУ',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(color: BrutalTheme.primaryBlack),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: BrutalTheme.warningYellow,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '⚠ ПОЛУЧИТЕ КОД ГРУППЫ У СОЗДАТЕЛЯ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: BrutalTheme.warningYellow,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: BrutalTheme.primaryWhite,
            ),
          ),
          error: (error, stack) => Center(
            child: Text(
              'ОШИБКА: $error',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: BrutalTheme.accentRed,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
