import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veto_app/features/auth/domain/auth_provider.dart';
import 'package:veto_app/features/auth/presentation/widgets/brutal_text_field.dart';
import 'package:veto_app/core/theme/brutal_theme.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleQuickStart() async {
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      _showError('ВВЕДИТЕ ИМЯ');
      return;
    }

    if (username.length < 3) {
      _showError('ИМЯ СЛИШКОМ КОРОТКОЕ (МИН. 3 СИМВОЛА)');
      return;
    }

    setState(() => _isLoading = true);

    try {
      print('DEBUG: Начинаем анонимный вход с именем: $username');
      await ref.read(currentUserProvider.notifier).signInAnonymously(username);
      print('DEBUG: Анонимный вход успешен');

      if (mounted) {
        print('DEBUG: Переходим на /group-select');
        // Переход на экран выбора группы
        context.go('/group-select');
      }
    } catch (e, stackTrace) {
      print('DEBUG: Ошибка при входе: $e');
      print('DEBUG: StackTrace: $stackTrace');
      if (mounted) {
        _showError('ОШИБКА: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Логотип и заголовок
              Text(
                'VETO',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'ДИКТАТОР РЕШЕНИЙ',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                height: 4,
                color: BrutalTheme.primaryWhite,
              ),
              const SizedBox(height: 48),

              // Описание
              Text(
                'НИКАКИХ СПОРОВ.\nТОЛЬКО РЕШЕНИЯ.',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Поле ввода имени
              BrutalTextField(
                controller: _usernameController,
                label: 'ВВЕДИТЕ ИМЯ',
                hint: 'Ваше имя',
                enabled: !_isLoading,
              ),
              const SizedBox(height: 24),

              // Кнопка быстрого старта
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleQuickStart,
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
                          'БЫСТРЫЙ СТАРТ',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: BrutalTheme.primaryBlack),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Разделитель
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: BrutalTheme.mediumGray,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'ИЛИ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: BrutalTheme.mediumGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Кнопка входа с email
              SizedBox(
                height: 60,
                child: OutlinedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          context.go('/login');
                        },
                  child: Text(
                    'ВХОД С EMAIL',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Предупреждение
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: BrutalTheme.warningYellow,
                    width: 3,
                  ),
                ),
                child: Text(
                  '⚠ ВНИМАНИЕ: РЕШЕНИЯ ОКОНЧАТЕЛЬНЫ\nВЕТО ОГРАНИЧЕНО',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: BrutalTheme.warningYellow,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
