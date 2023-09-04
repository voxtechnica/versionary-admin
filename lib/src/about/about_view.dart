import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versionary/src/app.dart';
import 'package:versionary/src/nav.dart';

import 'about.dart';

class AboutView extends ConsumerWidget {
  const AboutView({Key? key}) : super(key: key);

  static const routeName = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = Theme.of(context).textTheme.bodyMedium;
    return ref.watch(aboutApiProvider).when(
          data: (about) => Scaffold(
            appBar: const VersionaryAppBar(title: 'About Versionary'),
            drawer: const NavDrawer(
              currentRouteName: routeName,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Name: ${about.name ?? ''}', style: s),
                    Text('Base Domain: ${about.baseDomain ?? ''}', style: s),
                    SelectableText('Git Hash: ${about.gitHash ?? ''}',
                        style: s),
                    Text('Build Time: ${about.buildTime ?? ''}', style: s),
                    Text('Language: ${about.language ?? ''}', style: s),
                    Text('Environment: ${about.environment ?? ''}', style: s),
                    Text('Description: ${about.description ?? ''}', style: s),
                  ],
                ),
              ),
            ),
          ),
          loading: () => const Scaffold(
            appBar: VersionaryAppBar(title: 'About Versionary'),
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Scaffold(
            appBar: const VersionaryAppBar(title: 'About Versionary'),
            body: Center(child: Text(error.toString())),
          ),
        );
  }
}
