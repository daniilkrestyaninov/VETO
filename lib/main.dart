import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veto_app/core/config/supabase_config.dart';
import 'package:veto_app/core/router/app_router.dart';
import 'package:veto_app/core/theme/brutal_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация Supabase
  await SupabaseConfig.initialize();
  
  runApp(
    const ProviderScope(
      child: VetoApp(),
    ),
  );
}

class VetoApp extends StatelessWidget {
  const VetoApp({super.key});

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
