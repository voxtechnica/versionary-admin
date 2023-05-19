import 'package:go_router/go_router.dart';
import 'package:versionary/src/about/about_view.dart';
import 'package:versionary/src/toys/counter/view.dart';
import 'package:versionary/src/error.dart';
import 'package:versionary/src/login.dart';
import 'package:versionary/src/toys/things/detail_view.dart';
import 'package:versionary/src/toys/things/list_view.dart';

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

final homeRoute = GoRoute(
  name: 'home',
  path: '/',
  builder: (context, state) => const AboutView(),
  routes: [
    counterRoute,
    thingsRoute,
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
