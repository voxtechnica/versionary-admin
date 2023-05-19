import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versionary/src/api/api.dart';

/// LogoutIcon is a button that logs the user out when pressed.
/// The tooltip shows the current user's email address, or an
/// error message if the widget is in an error state.
class LogoutIcon extends ConsumerWidget {
  const LogoutIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const icon = Icon(Icons.logout);
    return ref.watch(apiNotifierProvider).when(
          loading: () => const IconButton(
            tooltip: 'Logout',
            icon: icon,
            onPressed: null,
          ),
          data: (api) {
            if (api.client.bearerToken.isEmpty) {
              return const IconButton(
                tooltip: 'Logout',
                icon: icon,
                onPressed: null,
              );
            }
            return IconButton(
              tooltip: 'Logout ${api.client.user.email}',
              icon: icon,
              onPressed: () async {
                await ref.read(apiNotifierProvider.notifier).logout();
              },
            );
          },
          error: (error, stack) => IconButton(
            tooltip: error.toString(),
            icon: icon,
            onPressed: null,
          ),
        );
  }
}
