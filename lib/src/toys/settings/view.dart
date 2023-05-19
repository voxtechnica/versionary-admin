import 'package:flutter/material.dart';
import 'controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text('Theme Mode'),
                  trailing: _buildThemeModeDropdown(),
                ),
                ListTile(
                  title: const Text('API Host Name'),
                  subtitle: Text(controller.hostName),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit',
                    onPressed: () async {
                      final newHostName = await showDialog<String>(
                        context: context,
                        builder: (context) => _buildHostNameDialog(context),
                      );
                      if (newHostName != null) {
                        controller.updateHostName(newHostName);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  /// Builds a DropdownButton to select the ThemeMode.
  ///
  /// The selected ThemeMode is displayed in the DropdownButton and the
  /// SettingsController is updated when a new ThemeMode is selected.
  /// The SettingsController notifies listeners that the ThemeMode has changed
  /// and the Widgets that listen to the SettingsController are rebuilt.
  DropdownButton<ThemeMode> _buildThemeModeDropdown() {
    return DropdownButton<ThemeMode>(
      value: controller.themeMode,
      onChanged: controller.updateThemeMode,
      items: const [
        DropdownMenuItem(
          value: ThemeMode.system,
          child: Text('System Theme'),
        ),
        DropdownMenuItem(
          value: ThemeMode.light,
          child: Text('Light Theme'),
        ),
        DropdownMenuItem(
          value: ThemeMode.dark,
          child: Text('Dark Theme'),
        )
      ],
    );
  }

  /// Builds a Dialog to edit the API Host Name.
  ///
  /// The API Host Name is displayed in the Dialog and the SettingsController is
  /// updated when a new API Host Name is entered. The SettingsController
  /// notifies listeners that the API Host Name has changed and the Widgets that
  /// listen to the SettingsController are rebuilt.
  AlertDialog _buildHostNameDialog(BuildContext context) {
    final controller = TextEditingController(text: this.controller.hostName);
    return AlertDialog(
      title: const Text('API Host Name'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Enter the API Host Name',
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () => Navigator.pop(context, controller.text),
        ),
      ],
    );
  }
}
