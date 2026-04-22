import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:veto_app/features/auth/presentation/auth_screen.dart';
import 'package:veto_app/features/auth/presentation/login_screen.dart';
import 'package:veto_app/features/auth/presentation/signup_screen.dart';
import 'package:veto_app/features/groups/presentation/group_select_screen.dart';
import 'package:veto_app/features/groups/presentation/group_lobby_screen.dart';
import 'package:veto_app/features/groups/presentation/qr_scanner_screen.dart';
import 'package:veto_app/features/session/presentation/session_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(Supabase.instance.client.auth.onAuthStateChange),
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isAuth = session != null;
      
      final isGoingToAuth = state.matchedLocation == '/auth' || 
                            state.matchedLocation == '/login' || 
                            state.matchedLocation == '/signup';

      if (state.matchedLocation == '/') {
        return isAuth ? '/group-select' : '/auth';
      }

      if (!isAuth && !isGoingToAuth) {
        return '/auth';
      }
      
      if (isAuth && isGoingToAuth) {
        return '/group-select';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/group-select',
        name: 'group-select',
        builder: (context, state) => const GroupSelectScreen(),
      ),
      GoRoute(
        path: '/qr-scanner',
        name: 'qr-scanner',
        builder: (context, state) => const QrScannerScreen(),
      ),
      GoRoute(
        path: '/lobby/:groupId',
        name: 'lobby',
        builder: (context, state) {
          final groupId = state.pathParameters['groupId']!;
          return GroupLobbyScreen(groupId: groupId);
        },
      ),
      GoRoute(
        path: '/session/:sessionId',
        name: 'session',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          return SessionScreen(sessionId: sessionId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'ERROR 404',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    ),
  );
}
