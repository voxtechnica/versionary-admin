import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_mode.dart';

/// ThemeIcon widget is an icon button that toggles the theme of the app between
/// light mode and dark mode.
class ThemeIcon extends ConsumerWidget {
  const ThemeIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    return ref.watch(themeModeNotifierProvider).when(
          loading: () => IconButton(
            tooltip: 'Toggle theme mode',
            icon: Icon(brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: null,
          ),
          data: (mode) => IconButton(
            tooltip: mode == ThemeMode.dark ? 'Light mode' : 'Dark mode',
            icon: Icon(
                mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              ref.read(themeModeNotifierProvider.notifier).toggle(brightness);
            },
          ),
          error: (error, stack) => IconButton(
            tooltip: error.toString(),
            icon: const Icon(Icons.error),
            onPressed: null,
          ),
        );
  }
}
