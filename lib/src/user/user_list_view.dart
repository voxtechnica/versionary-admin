import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:versionary/src/api/text_value.dart';
import 'package:versionary/src/app.dart';
import 'package:versionary/src/nav.dart';
import 'package:versionary/src/user/user.dart';

class UserListView extends ConsumerStatefulWidget {
  const UserListView({Key? key}) : super(key: key);

  static const routeName = 'users';

  @override
  ConsumerState<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends ConsumerState<UserListView> {
  final List<TextValue> _userNames = [];
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
    return ref.watch(userNamesProvider).when(
          data: (list) {
            _userNames.clear();
            for (final userName in list) {
              _userNames.add(userName);
            }
            return Scaffold(
              appBar: const VersionaryAppBar(title: 'Users'),
              drawer: const NavDrawer(
                currentRouteName: UserListView.routeName,
              ),
              body: _buildList(),
              floatingActionButton: _buildAddUserButton(context),
            );
          },
          loading: () => const Scaffold(
            appBar: VersionaryAppBar(title: 'Users'),
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Scaffold(
            appBar: const VersionaryAppBar(title: 'Users'),
            body: Center(child: Text(error.toString())),
          ),
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ListView _buildList() {
    return ListView.builder(
      restorationId: 'userListView',
      controller: _scrollController,
      itemCount: _userNames.length,
      itemBuilder: (BuildContext context, int i) => ListTile(
        key: ValueKey(_userNames[i].key),
        title: Text(_userNames[i].value),
        onTap: () {
          context.go('/users/${_userNames[i].key}');
        },
      ),
    );
  }

  Widget _buildAddUserButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // context.go(UserAddView.routeName);
        context.go('/users/add');
      },
      tooltip: 'Add User',
      child: const Icon(Icons.add),
    );
  }
}
