import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:novedades_movil/features/auth/screens/cambiar_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/solicitud/screens/nueva_solicitud_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
       GoRoute(
        path: '/cambiar-password',        // ← nueva ruta
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const CambiarPasswordScreen(),
          transitionsBuilder: (context, animation, _, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        ),
       ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const HomeScreen(),
          transitionsBuilder: (context, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: '/solicitud',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const NuevaSolicitudScreen(),
          transitionsBuilder: (context, animation, _, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
        ),
      ),
    ],
  );
}