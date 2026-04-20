import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:veto_app/features/auth/domain/auth_provider.dart';
import 'package:veto_app/features/auth/presentation/widgets/brutal_text_field.dart';
import 'package:veto_app/core/theme/brutal_theme.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String username) {
    if (username.isEmpty) {
      return 'ВВЕДИТЕ ИМЯ';
    }
    if (username.length < 3) {
      return 'ИМЯ СЛИШКОМ КОРОТКОЕ (МИН. 3 СИМВОЛА)';
    }
    if (username.length > 20) {
      return 'ИМЯ СЛИШКОМ ДЛИННОЕ (МАКС. 20 СИМВОЛОВ)';
    }
    return null;
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

  String? _validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'ПОДТВЕРДИТЕ ПАРОЛЬ';
    }
    if (password != confirmPassword) {
      return 'ПАРОЛИ НЕ СОВПАДАЮТ';
    }
    return null;
  }

  Future<void> _handleSignUp() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Валидация
    final usernameError = _validateUsername(username);
    if (usernameError != null) {
      _showError(usernameError);
      return;
    }

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

    final confirmPasswordError =
        _validateConfirmPassword(password, confirmPassword);
    if (confirmPasswordError != null) {
      _showError(confirmPasswordError);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(currentUserProvider.notifier).signUp(
            email: email,
            password: password,
            username: username,
          );

      if (mounted) {
        context.go('/group-select');
      }
    } catch (e) {
      if (mounted) {
        _showError('ОШИБКА РЕГИСТРАЦИИ: ${e.toString()}');
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
        title: const Text('РЕГИСТРАЦИЯ'),
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
                'СОЗДАТЬ АККАУНТ',
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                height: 3,
                color: BrutalTheme.primaryWhite,
              ),
              const SizedBox(height: 48),

              // Имя пользователя
              BrutalTextField(
                controller: _usernameController,
                label: 'ИМЯ ПОЛЬЗОВАТЕЛЯ',
                hint: 'Ваше имя',
                enabled: !_isLoading,
              ),
              const SizedBox(height: 24),

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
              const SizedBox(height: 24),

              // Подтверждение пароля
              BrutalTextField(
                controller: _confirmPasswordController,
                label: 'ПОДТВЕРДИТЕ ПАРОЛЬ',
                hint: 'Повторите пароль',
                enabled: !_isLoading,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: BrutalTheme.primaryWhite,
                  ),
                  onPressed: () {
                    setState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword);
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Кнопка регистрации
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignUp,
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
                          'ЗАРЕГИСТРИРОВАТЬСЯ',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: BrutalTheme.primaryBlack),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Ссылка на вход
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'УЖЕ ЕСТЬ АККАУНТ? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            context.go('/login');
                          },
                    child: Text(
                      'ВОЙТИ',
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
