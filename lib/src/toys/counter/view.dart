import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versionary/src/app.dart';
import 'package:versionary/src/nav.dart';
import 'counter.dart';

class CounterView extends ConsumerStatefulWidget {
  const CounterView({super.key, required this.title});

  final String title;
  static const routeName = '/counter';

  @override
  CounterViewState createState() => CounterViewState();
}

class CounterViewState extends ConsumerState<CounterView> {
  CounterViewState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VersionaryAppBar(title: widget.title),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Count:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(width: 16.0),
              Text(
                '${ref.watch(counterProvider)}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ],
      ),
      drawer: const NavDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
