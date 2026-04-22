import 'dart:math';
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

    // Контроллер для тряски/моргания при вращении
    _spinController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _spinAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.easeOut),
    );

    // Контроллер для удара "Штампа"
    _hammerController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _hammerAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _hammerController, curve: Curves.elasticOut),
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

    if (options.isEmpty || session == null) return;
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _showHammer = false;
    });

    final random = Random();
    int lastIndex = _currentIndex;
    
    // Вращаем варианты около 3.5 секунд
    const int totalSteps = 30;

    for (int i = 0; i < totalSteps; i++) {
      if (!mounted) return;

      setState(() {
        if (options.length > 1) {
          int nextIndex;
          do {
            nextIndex = random.nextInt(options.length);
          } while (nextIndex == lastIndex);
          _currentIndex = nextIndex;
          lastIndex = nextIndex;
        } else {
          _currentIndex = 0;
        }
      });

      _spinController.forward(from: 0);

      // Замедление к концу
      final progress = i / totalSteps;
      final curve = Curves.easeInCubic.transform(progress);
      final delayMs = 40 + (curve * 350).toInt();

      await Future.delayed(Duration(milliseconds: delayMs));
    }

    if (!mounted) return;

    // Показываем финальный
    if (session.selectedOptionId != null) {
      final selectedIndex =
          options.indexWhere((opt) => opt.id == session.selectedOptionId);

      if (selectedIndex != -1) {
        setState(() {
          _currentIndex = selectedIndex;
          _isAnimating = false;
          _showHammer = true;
        });

        await Future.delayed(const Duration(milliseconds: 150));
        await _hammerController.forward(from: 0);
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

    final groupId = sessionAsync.valueOrNull?.groupId;

    if (groupId != null) {
      // Слушаем изменения активной сессии группы
      ref.listen<AsyncValue<models.Session?>>(
        activeSessionProvider(groupId),
        (previous, next) {
          final activeSession = next.value;
          if (activeSession != null) {
            if (activeSession.status == 'spinning' && !_isAnimating && !_showHammer) {
              _startSpinningAnimation();
            } else if (activeSession.status == 'waiting' || activeSession.status == 'idle') {
              context.go('/lobby/$groupId');
            }
          } else {
            context.go('/lobby/$groupId');
          }
        },
      );

      // Проверяем текущее состояние для первоначального запуска анимации
      final activeSession = ref.watch(activeSessionProvider(groupId)).value;
      final options = optionsAsync.value;
      
      if (activeSession != null && activeSession.status == 'spinning') {
        if (options != null && options.isNotEmpty && !_isAnimating && !_showHammer) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_isAnimating && !_showHammer) {
              _startSpinningAnimation();
            }
          });
        }
      }
    }

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
                            AnimatedBuilder(
                              animation: _spinAnimation,
                              builder: (context, child) {
                                final random = Random();
                                return Transform.translate(
                                  offset: Offset((random.nextDouble() - 0.5) * 8, 0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    color: BrutalTheme.warningYellow,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'КРУТИМ...',
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          color: BrutalTheme.primaryBlack,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            )
                          else if (_showHammer)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              color: BrutalTheme.accentRed,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'СУДЬБА РЕШЕНА',
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: BrutalTheme.primaryWhite,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),

                          // Гибкое пространство
                          const Spacer(flex: 1),

                          // Текущий вариант (в центре)
                          Flexible(
                            flex: 3,
                            child: AnimatedBuilder(
                              animation: _spinAnimation,
                              builder: (context, child) {
                                final random = Random();
                                final isSpinning = _isAnimating;
                                final offset = isSpinning 
                                    ? Offset((random.nextDouble() - 0.5) * 15 * _spinAnimation.value, 
                                             (random.nextDouble() - 0.5) * 15 * _spinAnimation.value)
                                    : Offset.zero;
                                    
                                return Transform.translate(
                                  offset: offset,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(32),
                                    margin: const EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: _showHammer
                                          ? BrutalTheme.primaryWhite
                                          : (isSpinning && _spinAnimation.value > 0.5 ? BrutalTheme.primaryWhite : BrutalTheme.primaryBlack),
                                      border: Border.all(
                                        color: _showHammer ? BrutalTheme.primaryBlack : BrutalTheme.primaryWhite,
                                        width: 6,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _showHammer ? BrutalTheme.accentRed : BrutalTheme.warningYellow,
                                          offset: const Offset(12, 12),
                                        ),
                                      ],
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        options[_currentIndex].title.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w900,
                                              color: (_showHammer || (isSpinning && _spinAnimation.value > 0.5)) 
                                                  ? BrutalTheme.primaryBlack 
                                                  : BrutalTheme.primaryWhite,
                                              height: 1.1,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
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

                  // Анимация штампа "ВЫБРАНО"
                  if (_showHammer)
                    AnimatedBuilder(
                      animation: _hammerAnimation,
                      builder: (context, child) {
                        final scale = 5.0 - (_hammerAnimation.value * 4.0); // от 5 до 1
                        final opacity = (_hammerAnimation.value * 1.5).clamp(0.0, 1.0);
                        
                        return Positioned.fill(
                          child: IgnorePointer(
                            child: Center(
                              child: Transform.scale(
                                scale: scale,
                                child: Transform.rotate(
                                  angle: -0.15,
                                  child: Opacity(
                                    opacity: opacity,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: BrutalTheme.accentRed, width: 8),
                                        color: BrutalTheme.primaryBlack.withOpacity(0.9),
                                      ),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            'ВЫБРАНО',
                                            style: TextStyle(
                                              fontFamily: 'SpaceMono',
                                              fontSize: 56,
                                              fontWeight: FontWeight.w900,
                                              color: BrutalTheme.accentRed,
                                              letterSpacing: 8,
                                            ),
                                          ),
                                        ),
                                    ),
                                  ),
                                ),
                              ),
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
