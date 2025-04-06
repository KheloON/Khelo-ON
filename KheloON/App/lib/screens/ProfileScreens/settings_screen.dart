import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _locationEnabled = true;
  String _distanceUnit = 'Kilometers';
  String _weightUnit = 'Kilograms';
  double _fontSize = 1.0; // 1.0 is normal

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Account'),
          _buildAccountSettings(),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Preferences'),
          _buildPreferencesSettings(),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Notifications'),
          _buildNotificationSettings(),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Privacy'),
          _buildPrivacySettings(),
          
          const SizedBox(height: 24),
          _buildSectionHeader('About'),
          _buildAboutSettings(),
          
          const SizedBox(height: 40),
          Center(
            child: TextButton(
              onPressed: () {
                // Log out
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            title: 'Edit Profile',
            icon: Icons.person,
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            title: 'Change Password',
            icon: Icons.lock,
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            title: 'Connected Accounts',
            icon: Icons.link,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSettings() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            title: 'Dark Mode',
            icon: Icons.dark_mode,
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          _buildDivider(),
          _buildDropdownTile(
            title: 'Distance Unit',
            icon: Icons.straighten,
            value: _distanceUnit,
            items: const ['Kilometers', 'Miles'],
            onChanged: (value) {
              setState(() {
                _distanceUnit = value!;
              });
            },
          ),
          _buildDivider(),
          _buildDropdownTile(
            title: 'Weight Unit',
            icon: Icons.monitor_weight,
            value: _weightUnit,
            items: const ['Kilograms', 'Pounds'],
            onChanged: (value) {
              setState(() {
                _weightUnit = value!;
              });
            },
          ),
          _buildDivider(),
          _buildSliderTile(
            title: 'Text Size',
            icon: Icons.text_fields,
            value: _fontSize,
            min: 0.8,
            max: 1.2,
            divisions: 4,
            onChanged: (value) {
              setState(() {
                _fontSize = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            title: 'Push Notifications',
            icon: Icons.notifications,
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          _buildDivider(),
          _buildSettingsTile(
            title: 'Notification Preferences',
            icon: Icons.tune,
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            title: 'Email Notifications',
            icon: Icons.email,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettings() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            title: 'Location Services',
            icon: Icons.location_on,
            value: _locationEnabled,
            onChanged: (value) {
              setState(() {
                _locationEnabled = value;
              });
            },
          ),
          _buildDivider(),
          _buildSettingsTile(
            title: 'Privacy Policy',
            icon: Icons.privacy_tip,
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            title: 'Data Management',
            icon: Icons.storage,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSettings() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            title: 'App Version',
            icon: Icons.info,
            trailing: const Text(
              'v1.0.0',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            title: 'Terms of Service',
            icon: Icons.description,
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            title: 'Help & Support',
            icon: Icons.help,
            onTap: () {},
          ),
          _buildDivider(),
          _buildSettingsTile(
            title: 'Rate the App',
            icon: Icons.star,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required IconData icon,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      trailing: Switch(
        value: value,
        activeColor: Theme.of(context).colorScheme.primary,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownTile<T>({
    required String title,
    required IconData icon,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      trailing: DropdownButton<T>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(item.toString()),
          );
        }).toList(),
        onChanged: onChanged,
        underline: Container(),
      ),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required IconData icon,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      subtitle: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        activeColor: Theme.of(context).colorScheme.primary,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}

