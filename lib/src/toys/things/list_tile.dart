import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'thing.dart';

class ThingListTile extends ConsumerStatefulWidget {
  const ThingListTile({super.key, required this.thing});
  final Thing thing;

  @override
  ConsumerState<ThingListTile> createState() => ThingListTileState();
}

class ThingListTileState extends ConsumerState<ThingListTile> {
  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.thing.title);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        controller: titleController,
        decoration: const InputDecoration(
          hintText: 'Thing title',
        ),
        onChanged: (title) {
          setState(() {
            widget.thing.title = title;
          });
        },
      ),
      leading: const CircleAvatar(
        // Display the Flutter Logo image asset.
        foregroundImage: AssetImage('assets/images/flutter_logo.png'),
      ),
      trailing: Checkbox(
        value: widget.thing.isComplete,
        onChanged: (checked) {
          setState(() {
            widget.thing.isComplete = checked ?? false;
          });
        },
      ),
      onTap: () => context.goNamed(
        'thing',
        pathParameters: {'id': '${widget.thing.id}'},
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }
}
