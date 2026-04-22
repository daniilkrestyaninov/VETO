import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veto_app/features/auth/domain/auth_provider.dart';
import 'package:veto_app/features/session/domain/session_provider.dart';
import 'package:veto_app/core/theme/brutal_theme.dart';
import 'package:veto_app/shared/models/session.dart' as models;

class SessionScreen extends ConsumerStatefulWidget {
  final String sessionId;

  const SessionScreen({
    super.key,
    required this.sessionId,
  });

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _hammerController;
  late Animation<double> _spinAnimation;
  late Animation<double> _hammerAnimation;

  int _currentIndex = 0;
  bool _isAnimating = false;
  bool _showHammer = false;
  bool _isUsingVeto = false;

  @override
  void initState() {
    super.initState();

    // Контроллер для вращения вариантов
    _spinController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _spinAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.linear),
    );

    // Контроллер для удара молотка
    _hammerController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _hammerAnimation = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(parent: _hammerController, curve: Curves.easeInCubic),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    _hammerController.dispose();
    super.dispose();
  }

  Future<void> _startSpinningAnimation() async {
    print('DEBUG: _startSpinningAnimation called');

    final optionsAsync = ref.read(sessionOptionsProvider(widget.sessionId));
    final options = optionsAsync.value ?? [];
    final sessionAsync = ref.read(sessionProvider(widget.sessionId));
    final session = sessionAsync.value;

    print('DEBUG: Options count: ${options.length}');
    print('DEBUG: Session status: ${session?.status}');
    print('DEBUG: Selected option ID: ${session?.selectedOptionId}');

    if (options.isEmpty || session == null) {
      print('DEBUG: Cannot start animation - no options or session');
      return;
    }

    if (_isAnimating) {
      print('DEBUG: Animation already running, skipping');
      return;
    }

    setState(() {
      _isAnimating = true;
      _showHammer = false;
    });

    print('DEBUG: Starting spin animation');

    // Вращаем варианты 3 секунды
    const totalSpins = 30; // 30 итераций по 100мс = 3 секунды

    for (int i = 0; i < totalSpins; i++) {
      if (!mounted) return;

      setState(() {
        _currentIndex = (i % options.length);
      });

      await _spinController.forward();
      await _spinController.reverse();

      // Замедляем к концу
      if (i > totalSpins - 10) {
        await Future.delayed(Duration(milliseconds: i * 10));
      }
    }

    print('DEBUG: Spin animation completed, showing result');

    // Показываем выбранный вариант из БД
    if (session.selectedOptionId != null) {
      final selectedIndex =
          options.indexWhere((opt) => opt.id == session.selectedOptionId);

      print('DEBUG: Selected index: $selectedIndex');

      if (selectedIndex != -1) {
        setState(() {
          _currentIndex = selectedIndex;
          _isAnimating = false;
          _showHammer = true;
        });

        print('DEBUG: Showing hammer animation');

        // Анимация удара молотка
        await Future.delayed(const Duration(milliseconds: 300));
        await _hammerController.forward();

        print('DEBUG: Animation complete');
      } else {
        print('DEBUG: ERROR - Selected option not found in options list');
      }
    } else {
      print('DEBUG: ERROR - No selected option ID in session');
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

  Future<void> _handleVeto() async {
    final user = ref.read(currentUserProvider).value;

    if (user == null) {
      _showError('ОШИБКА: ПОЛЬЗОВАТЕЛЬ НЕ НАЙДЕН');
      return;
    }

    // Получаем сессию
    final session = await ref.read(sessionProvider(widget.sessionId).future);

    // Показываем диалог подтверждения
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BrutalTheme.darkGray,
        title: Text(
          'ИСПОЛЬЗОВАТЬ ВЕТО?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Вы уверены, что хотите использовать токен вето?\nВыбранный вариант будет удален, и все вернутся в лобби.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'ОТМЕНА',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: BrutalTheme.accentRed,
            ),
            child: Text(
              'ИСПОЛЬЗОВАТЬ ВЕТО',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: BrutalTheme.primaryWhite,
                  ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isUsingVeto = true);

    try {
      print('DEBUG: Используем вето для сессии: ${widget.sessionId}');
      await ref.read(vetoLogsProvider(widget.sessionId).notifier).useVeto(
            groupId: session.groupId,
            reason: 'Не согласен с решением',
          );

      if (mounted) {
        // Realtime автоматически вернет всех в лобби
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ВЕТО ИСПОЛЬЗОВАНО! ВОЗВРАТ В ЛОББИ...',
              style: const TextStyle(
                fontFamily: 'SpaceMono',
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: BrutalTheme.warningYellow,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('DEBUG: Ошибка использования вето: $e');
      if (mounted) {
        _showError('ОШИБКА: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isUsingVeto = false);
      }
    }
  }

  Future<void> _handleAccept() async {
    final session = await ref.read(sessionProvider(widget.sessionId).future);

    try {
      await ref
          .read(activeSessionProvider(session.groupId).notifier)
          .acceptResult();

      if (mounted) {
        // Возвращаемся в лобби
        context.go('/lobby/${session.groupId}');
      }
    } catch (e) {
      if (mounted) {
        _showError('ОШИБКА: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(sessionProvider(widget.sessionId));
    final optionsAsync = ref.watch(sessionOptionsProvider(widget.sessionId));

    // Слушаем изменения статуса сессии
    ref.listen<AsyncValue<models.Session>>(
      sessionProvider(widget.sessionId),
      (previous, next) {
        next.whenData((session) {
          print('DEBUG: Session status changed to: ${session.status}');

          if (session.status == 'spinning' && !_isAnimating && !_showHammer) {
            print('DEBUG: Starting animation for all clients');
            // Запускаем анимацию на ВСЕХ устройствах
            _startSpinningAnimation();
          } else if (session.status == 'waiting') {
            // Вернулись в лобби (после вето)
            print('DEBUG: Returning to lobby after veto');
            final groupId = session.groupId;
            context.go('/lobby/$groupId');
          }
        });
      },
    );

    return Scaffold(
      backgroundColor: BrutalTheme.primaryBlack,
      appBar: AppBar(
        title: const Text('РУЛЕТКА'),
        backgroundColor: BrutalTheme.primaryBlack,
      ),
      body: sessionAsync.when(
        data: (session) {
          return optionsAsync.when(
            data: (options) {
              if (options.isEmpty) {
                return Center(
                  child: Text(
                    'НЕТ ВАРИАНТОВ',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                );
              }

              return Stack(
                children: [
                  // Основной контент
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Логотип сверху
                          const SizedBox(height: 20),

                          // Заголовок
                          if (_isAnimating)
                            Text(
                              'ВЫБИРАЮ...',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                    color: BrutalTheme.accentRed,
                                  ),
                            )
                          else if (_showHammer)
                            Text(
                              'РЕШЕНО!',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                    color: BrutalTheme.warningYellow,
                                  ),
                            ),

                          // Гибкое пространство
                          const Spacer(flex: 1),

                          // Текущий вариант (в центре)
                          AnimatedBuilder(
                            animation: _spinAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1.0 + (_spinAnimation.value * 0.1),
                                child: Container(
                                  padding: const EdgeInsets.all(32),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  decoration: BoxDecoration(
                                    color: _showHammer
                                        ? BrutalTheme.accentRed
                                        : BrutalTheme.darkGray,
                                    border: Border.all(
                                      color: BrutalTheme.primaryWhite,
                                      width: 4,
                                    ),
                                  ),
                                  child: Text(
                                    options[_currentIndex].title.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),

                          const Spacer(flex: 1),

                          // Кнопки внизу
                          if (_showHammer) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: BrutalTheme.warningYellow,
                                  width: 3,
                                ),
                              ),
                              child: Text(
                                '⚠ РЕШЕНИЕ ОКОНЧАТЕЛЬНО\nСПОРИТЬ БЕСПОЛЕЗНО',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: BrutalTheme.warningYellow,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _handleAccept,
                                child: Text(
                                  'ПРИНЯТО',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: BrutalTheme.primaryBlack,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Кнопка вето
                            SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: _isUsingVeto ? null : _handleVeto,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: BrutalTheme.accentRed,
                                    width: 3,
                                  ),
                                ),
                                child: _isUsingVeto
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: BrutalTheme.accentRed,
                                        ),
                                      )
                                    : Text(
                                        'ИСПОЛЬЗОВАТЬ ВЕТО',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              color: BrutalTheme.accentRed,
                                              fontSize: 14,
                                            ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Анимация молотка
                  if (_showHammer)
                    AnimatedBuilder(
                      animation: _hammerAnimation,
                      builder: (context, child) {
                        return Positioned(
                          top: _hammerAnimation.value,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Icon(
                              Icons.gavel,
                              size: 150,
                              color: BrutalTheme.primaryWhite.withOpacity(0.9),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: BrutalTheme.primaryWhite,
              ),
            ),
            error: (error, _) => Center(
              child: Text(
                'ОШИБКА: $error',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: BrutalTheme.accentRed,
                    ),
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: BrutalTheme.primaryWhite,
          ),
        ),
        error: (error, _) => Center(
          child: Text(
            'ОШИБКА: $error',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: BrutalTheme.accentRed,
                ),
          ),
        ),
      ),
    );
  }
}
