import 'package:edutest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/profile_card.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const ProfileCard(),
            const SizedBox(height: 20),

            SettingsTile(icon: Icons.person, title: 'Profile'),
            SettingsTile(icon: Icons.bar_chart, title: 'Test Results'),
            SettingsTile(icon: Icons.settings, title: 'Settings'),
            SettingsTile(icon: Icons.help, title: 'FAQs'),

            const Spacer(),

            TextButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Quit Confirmation'),
                    content: const Text('Are you sure you want to Sign Out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  context.read<AuthBloc>().add(AuthSignoutRequested());
                }
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.deepOrange, fontSize: 16),
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              'versi 1.0.0\nby rekandtech',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
