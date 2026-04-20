import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Supabase project configuration
  static const String supabaseUrl = 'https://kbnmctxdxdjqjrplcdjp.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtibm1jdHhkeGRqcWpycGxjZGpwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY3MDYxNjksImV4cCI6MjA5MjI4MjE2OX0.zkqd0uLr3pYKVD4wJ3LK-L72S5zMCMDuFKK97_8Q_J0';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
