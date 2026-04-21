import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:veto_app/core/config/supabase_config.dart';
import 'package:veto_app/core/router/app_router.dart';
import 'package:veto_app/core/theme/brutal_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Supabase с поддержкой Deep Links
  await SupabaseConfig.initialize();

  runApp(
    const ProviderScope(
      child: VetoApp(),
    ),
  );
}

class VetoApp extends ConsumerStatefulWidget {
  const VetoApp({super.key});

  @override
  ConsumerState<VetoApp> createState() => _VetoAppState();
}

class _VetoAppState extends ConsumerState<VetoApp> {
  @override
  void initState() {
    super.initState();

    // Слушаем изменения состояния авторизации
    SupabaseConfig.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      print('DEBUG: Auth state changed: $event');

      if (event == AuthChangeEvent.signedIn) {
        print('DEBUG: Пользователь вошел в систему');
        // Обновляем состояние приложения
        setState(() {});
      } else if (event == AuthChangeEvent.signedOut) {
        print('DEBUG: Пользователь вышел из системы');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VETO',
      debugShowCheckedModeBanner: false,
      theme: BrutalTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
