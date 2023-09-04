import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:versionary/src/about/about_view.dart';
import 'package:versionary/src/toys/counter/view.dart';
import 'package:versionary/src/error.dart';
import 'package:versionary/src/login.dart';
import 'package:versionary/src/toys/nav_drawer.dart';
import 'package:versionary/src/toys/things/detail_view.dart';
import 'package:versionary/src/toys/things/list_view.dart';
import 'package:versionary/src/user/user_list_view.dart';

final loginRoute = GoRoute(
  name: 'login',
  path: '/login',
  builder: (context, state) => const LoginView(),
);

final errorRoute = GoRoute(
  name: 'error',
  path: '/error',
  builder: (context, state) => ErrorView(error: state.error),
);

final counterRoute = GoRoute(
  name: 'counter',
  path: 'counter',
  builder: (context, state) => const CounterView(title: 'Counter'),
);

final thingsRoute = GoRoute(
  name: 'things',
  path: 'things',
  builder: (context, state) => const ThingListView(),
  routes: [
    GoRoute(
      name: 'thing',
      path: ':id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return ThingDetailView(id: id);
      },
    ),
  ],
);

final usersRoute = GoRoute(
  name: 'users',
  path: 'users',
  builder: (context, state) => const UserListView(),
);

final drawerRoute = GoRoute(
  name: 'drawer',
  path: 'drawer',
  builder: (context, state) => const NavigationDrawerExample(),
);

final homeRoute = GoRoute(
  name: 'home',
  path: '/',
  builder: (context, state) => const AboutView(),
  routes: [
    usersRoute,
    counterRoute,
    thingsRoute,
    drawerRoute,
  ],
);

final router = GoRouter(
  debugLogDiagnostics: false,
  initialLocation: homeRoute.path,
  routes: [
    homeRoute,
    loginRoute,
    errorRoute,
  ],
  // uncomment to use a custom error route:
  // errorBuilder: errorRoute.builder,
);

/// Destination is a helper class for building navigation drawer destinations.
/// It is used by the [NavigationDrawer] widget.
class Destination {
  const Destination({
    required this.label,
    required this.icon,
    required this.routeName,
  });

  final String label;
  final IconData icon;
  final String routeName;
}

final destinations = [
  const Destination(
    label: 'Home',
    icon: Icons.home,
    routeName: 'home',
  ),
  const Destination(
    label: 'Users',
    icon: Icons.people,
    routeName: 'users',
  ),
  const Destination(
    label: 'Counter',
    icon: Icons.add,
    routeName: 'counter',
  ),
  const Destination(
    label: 'Things',
    icon: Icons.list,
    routeName: 'things',
  ),
  const Destination(
    label: 'Drawer',
    icon: Icons.menu,
    routeName: 'drawer',
  ),
];
