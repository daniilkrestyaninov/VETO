import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veto_app/features/auth/domain/auth_provider.dart';
import 'package:veto_app/features/session/domain/session_provider.dart';
import 'package:veto_app/core/theme/brutal_theme.dart';

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
  String? _finalDecision;
  bool _isSpinning = false;
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

    // Автоматически запускаем рулетку
    Future.microtask(() {
      if (mounted) {
        _startSpinning();
      }
    });
  }

  @override
  void dispose() {
    _spinController.dispose();
    _hammerController.dispose();
    super.dispose();
  }

  Future<void> _startSpinning() async {
    final optionsAsync = ref.read(sessionOptionsProvider(widget.sessionId));
    final options = optionsAsync.value ?? [];

    if (options.isEmpty) {
      _showError('НЕТ ВАРИАНТОВ ДЛЯ ВЫБОРА');
      return;
    }

    setState(() {
      _isSpinning = true;
    });

    // Вращаем варианты 3 секунды
    final random = Random();
    final totalSpins = 30; // 30 итераций по 100мс = 3 секунды

    for (int i = 0; i < totalSpins; i++) {
      if (!mounted) return;

      setState(() {
        _currentIndex = random.nextInt(options.length);
      });

      await _spinController.forward();
      await _spinController.reverse();

      // Замедляем к концу
      if (i > totalSpins - 10) {
        await Future.delayed(Duration(milliseconds: i * 10));
      }
    }

    // Финальный выбор
    final finalIndex = random.nextInt(options.length);
    final selectedOption = options[finalIndex];

    setState(() {
      _currentIndex = finalIndex;
      _finalDecision = selectedOption.title;
      _isSpinning = false;
      _showHammer = true;
    });

    // Анимация удара молотка
    await Future.delayed(const Duration(milliseconds: 300));
    await _hammerController.forward();

    // Записываем результат в БД
    try {
      await ref.read(sessionRepositoryProvider).resolveSession(
            sessionId: widget.sessionId,
            finalDecisionId: selectedOption.id,
          );
    } catch (e) {
      print('Ошибка записи результата: $e');
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
          'Вы уверены, что хотите использовать токен вето?\nЭто отменит текущее решение и запустит новую рулетку.',
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
            userId: user.id,
            reason: 'Не согласен с решением',
          );

      if (mounted) {
        // Возвращаемся в лобби группы
        context.go('/lobby/${session.groupId}');
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

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(sessionProvider(widget.sessionId));
    final optionsAsync = ref.watch(sessionOptionsProvider(widget.sessionId));

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
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Заголовок
                        if (_isSpinning)
                          Text(
                            'ВЫБИРАЮ...',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: BrutalTheme.accentRed,
                                ),
                          )
                        else if (_finalDecision != null)
                          Text(
                            'РЕШЕНО!',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  color: BrutalTheme.warningYellow,
                                ),
                          ),
                        const SizedBox(height: 48),

                        // Текущий вариант
                        AnimatedBuilder(
                          animation: _spinAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + (_spinAnimation.value * 0.1),
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                decoration: BoxDecoration(
                                  color: _finalDecision != null
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

                        if (_finalDecision != null) ...[
                          const SizedBox(height: 48),
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(horizontal: 24),
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
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
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
                            width: 200,
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
                        ],
                      ],
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
