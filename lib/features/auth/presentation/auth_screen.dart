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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isLoading = false;
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      await ref.read(currentUserProvider.notifier).signInWithGoogle();

      if (mounted) {
        context.go('/group-select');
      }
    } catch (e) {
      if (mounted) {
        _showError('ОШИБКА GOOGLE AUTH: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleEmailAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('ЗАПОЛНИТЕ ВСЕ ПОЛЯ');
      return;
    }

    if (_isSignUp && username.isEmpty) {
      _showError('ВВЕДИТЕ ИМЯ ПОЛЬЗОВАТЕЛЯ');
      return;
    }

    if (password.length < 6) {
      _showError('ПАРОЛЬ СЛИШКОМ КОРОТКИЙ (МИН. 6 СИМВОЛОВ)');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isSignUp) {
        await ref.read(currentUserProvider.notifier).signUpWithEmail(
              email: email,
              password: password,
              username: username,
            );
      } else {
        await ref.read(currentUserProvider.notifier).signInWithEmail(
              email: email,
              password: password,
            );
      }

      if (mounted) {
        context.go('/group-select');
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'SpaceMono',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        backgroundColor: BrutalTheme.accentRed,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrutalTheme.primaryBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Гигантский заголовок VETO
              Text(
                'VETO',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 72,
                      letterSpacing: 8,
                      height: 1,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                height: 6,
                color: BrutalTheme.warningYellow,
              ),
              const SizedBox(height: 48),

              // Кнопка Google OAuth
              _buildSocialButton(
                label: 'GOOGLE',
                icon: '🔍',
                onPressed: _isLoading ? null : _handleGoogleSignIn,
                color: BrutalTheme.primaryWhite,
                textColor: BrutalTheme.primaryBlack,
              ),
              const SizedBox(height: 32),

              // Разделитель
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 3,
                      color: BrutalTheme.mediumGray,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '/// OR MANUAL OVERRIDE ///',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: BrutalTheme.warningYellow,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 3,
                      color: BrutalTheme.mediumGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Переключатель режима
              Row(
                children: [
                  Expanded(
                    child: _buildModeButton(
                      label: 'ВХОД',
                      isActive: !_isSignUp,
                      onPressed: () => setState(() => _isSignUp = false),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildModeButton(
                      label: 'РЕГИСТРАЦИЯ',
                      isActive: _isSignUp,
                      onPressed: () => setState(() => _isSignUp = true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Поля Email и Password
              if (_isSignUp) ...[
                BrutalTextField(
                  controller: _usernameController,
                  label: 'USERNAME',
                  hint: 'Введите имя пользователя',
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),
              ],
              BrutalTextField(
                controller: _emailController,
                label: 'EMAIL',
                hint: 'user@example.com',
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
              BrutalTextField(
                controller: _passwordController,
                label: 'PASSWORD',
                hint: '••••••••',
                obscureText: true,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 32),

              // Кнопка EXECUTE
              _buildExecuteButton(),
              const SizedBox(height: 48),

              // Предупреждение
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: BrutalTheme.warningYellow,
                    width: 4,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '⚠ SYSTEM WARNING ⚠',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: BrutalTheme.warningYellow,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'РЕШЕНИЯ ОКОНЧАТЕЛЬНЫ\nВЕТО ОГРАНИЧЕНО\nНИКАКИХ ВОЗВРАТОВ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: BrutalTheme.warningYellow,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required String icon,
    required VoidCallback? onPressed,
    required Color color,
    required Color textColor,
  }) {
    return SizedBox(
      height: 70,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 0,
          side: BorderSide(color: color, width: 4),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: _isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: textColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'ВОЙТИ ЧЕРЕЗ $label',
                    style: TextStyle(
                      fontFamily: 'SpaceMono',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildModeButton({
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: _isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor:
              isActive ? BrutalTheme.warningYellow : Colors.transparent,
          foregroundColor:
              isActive ? BrutalTheme.primaryBlack : BrutalTheme.primaryWhite,
          side: BorderSide(
            color:
                isActive ? BrutalTheme.warningYellow : BrutalTheme.mediumGray,
            width: 3,
          ),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'SpaceMono',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color:
                isActive ? BrutalTheme.primaryBlack : BrutalTheme.primaryWhite,
          ),
        ),
      ),
    );
  }

  Widget _buildExecuteButton() {
    return SizedBox(
      height: 70,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleEmailAuth,
        style: ElevatedButton.styleFrom(
          backgroundColor: BrutalTheme.warningYellow,
          foregroundColor: BrutalTheme.primaryBlack,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 0,
          side: const BorderSide(color: BrutalTheme.warningYellow, width: 4),
        ),
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
                '>>> EXECUTE ${_isSignUp ? 'REGISTRATION' : 'LOGIN'} <<<',
                style: const TextStyle(
                  fontFamily: 'SpaceMono',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
      ),
    );
  }
}
