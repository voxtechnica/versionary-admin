import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versionary/src/login.dart';
import 'package:versionary/src/logout.dart';
import 'package:versionary/src/routes.dart';
import 'package:versionary/src/api/api.dart';
import 'package:versionary/src/api/api_icon.dart';
import 'package:versionary/src/theme/theme_icon.dart';
import 'package:versionary/src/theme/theme_mode.dart';

class VersionaryApp extends ConsumerWidget {
  const VersionaryApp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider).when(
          data: (mode) => mode,
          loading: () => ThemeMode.system,
          error: (error, stack) => ThemeMode.system,
        );
    final api = ref.watch(apiNotifierProvider);

    // Show the loading screen until the API client is initialized.
    if (api.isLoading) {
      return MaterialApp(
        title: 'Versionary',
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        themeMode: themeMode,
        restorationScopeId: 'app',
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Show an error message if the API client failed to initialize.
    if (api.hasError && api.error != null) {
      final errorMessage = api.error.toString();
      return MaterialApp(
        title: 'Versionary',
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        themeMode: themeMode,
        restorationScopeId: 'app',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Text(errorMessage),
          ),
        ),
      );
    }

    // Show the login screen if the API client is not authenticated.
    if (api.hasValue && api.value != null && !api.value!.isAdmin) {
      return MaterialApp(
        title: 'Versionary',
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        themeMode: themeMode,
        restorationScopeId: 'app',
        debugShowCheckedModeBanner: false,
        home: const LoginView(),
      );
    }

    // Show the main application to authenticated administrators.
    return MaterialApp.router(
      title: 'Versionary',
      theme: ThemeData(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: themeMode,
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

/// VersionaryAppBar is a reusable widget that displays the title of the app
/// and optionally some actions.
class VersionaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VersionaryAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        ...?actions,
        const ThemeIcon(),
        const ApiIcon(),
        const LogoutIcon(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
