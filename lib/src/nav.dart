import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:versionary/src/api/api.dart';
import 'package:versionary/src/user/user.dart';
import 'package:versionary/src/routes.dart';

class NavDrawer extends ConsumerStatefulWidget {
  const NavDrawer({Key? key, required this.currentRouteName}) : super(key: key);

  final String currentRouteName;

  @override
  ConsumerState<NavDrawer> createState() => NavDrawerState();
}

class NavDrawerState extends ConsumerState<NavDrawer> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < destinations.length; i++) {
      if (destinations[i].routeName == widget.currentRouteName) {
        selectedIndex = i;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(apiNotifierProvider).when(
          data: (api) {
            return NavigationDrawer(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                if (index < destinations.length) {
                  final routeName = destinations[index].routeName;
                  context.goNamed(routeName);
                }
              },
              children: <Widget>[
                _buildUserHeader(context, api.client.user),
                ...destinations
                    .map((d) => NavigationDrawerDestination(
                          icon: Icon(d.icon),
                          label: Text(d.label),
                        ))
                    .toList(),
                _buildAboutBox(context),
              ],
            );
          },
          error: (error, stack) => Drawer(
            child: Center(
              child: Text('Error: $error'),
            ),
          ),
          loading: () => const Drawer(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
  }

  Widget _buildUserHeader(BuildContext context, User user) {
    final fullName = user.fullName();
    return UserAccountsDrawerHeader(
        accountName: Text(fullName),
        accountEmail: Text(user.email ?? ''),
        currentAccountPicture: const CircleAvatar(
          foregroundImage: AssetImage('assets/images/flutter_logo.png'),
        ));
  }

  Widget _buildAboutBox(BuildContext context) {
    return AboutListTile(
      icon: const Icon(Icons.info),
      applicationName: 'Versionary',
      applicationVersion: '0.0.1',
      applicationLegalese: '© 2021 Versionary',
      aboutBoxChildren: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text(
            'Versionary is an adminstrative application for managing versionable content.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
