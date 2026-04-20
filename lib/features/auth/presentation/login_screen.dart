import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veto_app/features/auth/domain/auth_provider.dart';
import 'package:veto_app/features/auth/presentation/widgets/brutal_text_field.dart';
import 'package:veto_app/core/theme/brutal_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'ВВЕДИТЕ EMAIL';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'НЕВЕРНЫЙ ФОРМАТ EMAIL';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'ВВЕДИТЕ ПАРОЛЬ';
    }
    if (password.length < 6) {
      return 'ПАРОЛЬ СЛИШКОМ КОРОТКИЙ (МИН. 6 СИМВОЛОВ)';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Валидация
    final emailError = _validateEmail(email);
    if (emailError != null) {
      _showError(emailError);
      return;
    }

    final passwordError = _validatePassword(password);
    if (passwordError != null) {
      _showError(passwordError);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(currentUserProvider.notifier).signIn(
            email: email,
            password: password,
          );

      if (mounted) {
        context.go('/group-select');
      }
    } catch (e) {
      if (mounted) {
        _showError('ОШИБКА ВХОДА: ${e.toString()}');
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
      appBar: AppBar(
        title: const Text('ВХОД'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),

              // Заголовок
              Text(
                'С ВОЗВРАЩЕНИЕМ',
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                height: 3,
                color: BrutalTheme.primaryWhite,
              ),
              const SizedBox(height: 48),

              // Email поле
              BrutalTextField(
                controller: _emailController,
                label: 'EMAIL',
                hint: 'your@email.com',
                enabled: !_isLoading,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),

              // Пароль поле
              BrutalTextField(
                controller: _passwordController,
                label: 'ПАРОЛЬ',
                hint: 'Минимум 6 символов',
                enabled: !_isLoading,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: BrutalTheme.primaryWhite,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Кнопка входа
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
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
                          'ВОЙТИ',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: BrutalTheme.primaryBlack),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Ссылка на регистрацию
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'НЕТ АККАУНТА? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            context.go('/signup');
                          },
                    child: Text(
                      'ЗАРЕГИСТРИРОВАТЬСЯ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: BrutalTheme.warningYellow,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
