import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NavDrawer extends ConsumerStatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  ConsumerState<NavDrawer> createState() => NavDrawerState();
}

class NavDrawerState extends ConsumerState<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            text: 'Home',
            onTap: () => context.go('/'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.info,
            text: 'Counter',
            onTap: () => context.goNamed('counter'),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.list,
            text: 'Things',
            onTap: () => context.goNamed('things'),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      // decoration: const BoxDecoration(
      //     color: Theme.of(context).primaryColor,
      //     ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Versionary',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            'Versionary is an adminstrative application for managing versionable content.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}
