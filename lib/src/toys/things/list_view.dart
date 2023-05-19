import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:versionary/src/app.dart';
import 'package:versionary/src/nav.dart';
import 'package:versionary/src/toys/things/thing.dart';
import 'package:versionary/src/toys/things/list_tile.dart';

class ThingListView extends ConsumerStatefulWidget {
  const ThingListView({super.key});

  static const routeName = '/things';

  @override
  ConsumerState<ThingListView> createState() => ThingListViewState();
}

class ThingListViewState extends ConsumerState<ThingListView> {
  final List<Thing> items = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        FocusScope.of(context).requestFocus(FocusNode());
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VersionaryAppBar(
        title: 'Things',
        actions: [
          // Counter button
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Counter',
            onPressed: () => context.goNamed('counter'),
          ),
        ],
      ),
      body: _buildList(),
      drawer: const NavDrawer(),
      floatingActionButton: _buildAddThingButton(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 60,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Versionary Menu'),
            ),
          ),
          ListTile(
            title: const Text('Counter'),
            onTap: () => context.goNamed('counter'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddThingButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        setState(() {
          final id = items.length + 1;
          items.add(Thing(
            id: id,
            title: 'Thing $id',
            isComplete: false,
          ));
        });
      },
    );
  }

  // To work with lists that may contain a large number of items, it’s best
  // to use the ListView.builder constructor.
  //
  // In contrast to the default ListView constructor, which requires
  // building all Widgets up front, the ListView.builder constructor lazily
  // builds Widgets as they’re scrolled into view.
  ListView _buildList() {
    return ListView.builder(
      // Providing a restorationId allows the ListView to restore the
      // scroll position when a user leaves and returns to the app after it
      // has been killed while running in the background.
      restorationId: 'thingListView',
      controller: _scrollController,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) =>
          ThingListTile(thing: items[index]),
    );
  }
}
