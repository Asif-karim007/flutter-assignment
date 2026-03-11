import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Obx(() {
        final user = authController.currentUser.value;
        if (user == null) {
          return const Center(child: Text('No user information available.'));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CircleAvatar(
              radius: 36,
              backgroundImage: NetworkImage(user.image),
            ),
            const SizedBox(height: 16),
            _InfoRow(label: 'Username', value: user.username),
            _InfoRow(label: 'Full Name', value: user.fullName),
            _InfoRow(label: 'Email', value: user.email),
            const Divider(height: 32),
            Obx(() {
              return SwitchListTile(
                title: const Text('Dark Theme'),
                value: themeController.isDarkMode.value,
                onChanged: themeController.toggleTheme,
              );
            }),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: authController.logout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ],
        );
      }),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
