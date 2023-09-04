import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api.dart';

/// ApiIcon widget is an icon button that allows the user to select an API host.
/// A new API host name is specified by the user in a dialog and the host name
/// is validated before it is saved. The host name is then persisted in local
/// storage and the API client is updated. The current API host name is
/// displayed in the tooltip of the icon button.
class ApiIcon extends ConsumerWidget {
  const ApiIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(apiNotifierProvider).when(
          loading: () => const IconButton(
            tooltip: 'API host',
            icon: Icon(Icons.api),
            onPressed: null,
          ),
          data: (api) => IconButton(
            tooltip: api.hostName,
            icon: const Icon(Icons.api),
            onPressed: () async {
              final hostName = await showDialog<String>(
                context: context,
                builder: (context) => HostNameDialog(hostName: api.hostName),
              );
              if (hostName != null) {
                final errorMessage = await ref
                    .read(apiNotifierProvider.notifier)
                    .updateHostName(hostName);
                if (errorMessage != null) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      duration: const Duration(seconds: 5),
                    ),
                  );
                }
              }
            },
          ),
          error: (error, stack) => IconButton(
            tooltip: error.toString(),
            icon: const Icon(Icons.error),
            onPressed: null,
          ),
        );
  }
}

/// HostNameDialog is a widget that allows the user to enter a new API host name.
class HostNameDialog extends StatelessWidget {
  const HostNameDialog({
    super.key,
    required this.hostName,
  });

  final String hostName;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: hostName);
    return AlertDialog(
      title: const Text('API Host Name'),
      content: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'api.versionary.net',
          ),
          validator: (value) => validateHostName(value),
        ),
      ),
      actions: [
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.pop(context, controller.text);
            }
          },
        ),
      ],
    );
  }
}

/// validateHostName checks if the host name is valid. A valid host name is not
/// empty, does not contain spaces, and can be parsed as a URI.
String? validateHostName(String? hostName) {
  if (hostName == null || hostName.isEmpty) {
    return 'Required';
  }
  if (hostName.contains(' ')) {
    return 'Spaces are not allowed';
  }
  try {
    Uri.parse('https://$hostName');
  } on FormatException {
    return 'Invalid host name';
  }
  return null;
}
