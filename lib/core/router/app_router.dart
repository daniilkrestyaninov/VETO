import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:veto_app/features/auth/presentation/auth_screen.dart';
import 'package:veto_app/features/auth/presentation/login_screen.dart';
import 'package:veto_app/features/auth/presentation/signup_screen.dart';
import 'package:veto_app/features/groups/presentation/group_select_screen.dart';
import 'package:veto_app/features/groups/presentation/group_lobby_screen.dart';
import 'package:veto_app/features/session/presentation/session_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/auth',
    routes: [
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
