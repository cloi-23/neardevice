import 'package:flutter/material.dart';

import '../../../core/settings/internet_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool? _useInternet;

  @override
  void initState() {
    super.initState();
    _loadSetting();
  }

  Future<void> _loadSetting() async {
    final enabled = await InternetSettings.isEnabled();
    if (!mounted) return;

    setState(() {
      _useInternet = enabled;
    });
  }

  Future<void> _setUseInternet(bool enabled) async {
    setState(() {
      _useInternet = enabled;
    });
    await InternetSettings.setEnabled(enabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.public),
            title: const Text('Use internet connection'),
            subtitle: const Text(
              'Allow online tracking when it is available. Nearby remains the offline fallback.',
            ),
            value: _useInternet ?? false,
            onChanged: _useInternet == null ? null : _setUseInternet,
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Online location sync requires a server connection. This setting is saved now and will be used when online tracking is added.',
            ),
          ),
        ],
      ),
    );
  }
}
