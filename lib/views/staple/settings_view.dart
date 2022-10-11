import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: const Text('Blockchain'),
          tiles: <SettingsTile>[
            SettingsTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
            ),
            SettingsTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy'),
            ),
            SettingsTile(
              leading: const Icon(Icons.people),
              title: const Text('Friends'),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              value: const Text('English'),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.satellite),
              title: const Text('Network'),
              value: const Text('Ethereum'),
            ),
            SettingsTile.switchTile(
              onToggle: (value) {},
              initialValue: true,
              leading: const Icon(Icons.format_paint),
              title: const Text('Enable dark mode'),
            ),
          ],
        ),
      ],
    );
  }
}
