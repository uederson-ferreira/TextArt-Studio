import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/editor/presentation/pages/editor_page.dart';

abstract final class AppRoutes {
  static const String home = '/';
  static const String editor = '/editor';
  static const String editorWithProject = '/editor/:projectId';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: HomePage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.editor,
      name: 'editor-new',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const EditorPage(),
        transitionsBuilder: _slideTransition,
      ),
    ),
    GoRoute(
      path: AppRoutes.editorWithProject,
      name: 'editor-project',
      pageBuilder: (context, state) {
        final projectId = state.pathParameters['projectId']!;
        return CustomTransitionPage(
          child: EditorPage(projectId: projectId),
          transitionsBuilder: _slideTransition,
        );
      },
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Página não encontrada: ${state.uri}'),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Voltar ao início'),
            ),
          ],
        ),
      ),
    ),
  ),
);

Widget _slideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
    child: child,
  );
}
