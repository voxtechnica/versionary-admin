import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays detailed information about a Thing.
class ThingDetailView extends ConsumerWidget {
  const ThingDetailView({super.key, required this.id});

  final String? id;
  static const routeName = '/thing';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = id == null ? 'No ID supplied' : 'ID: $id';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Center(
        // display the item ID
        child: Text(message, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}
