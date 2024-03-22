import 'package:flutter/material.dart';
import 'package:atlas/services/auth.dart';

/// A page that displays the settings for the user's profile.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          textAlign: TextAlign.center, // Center the text within the app bar
        ),
        centerTitle: true, // Horizontally center the title
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .center, // Center the column in the middle of the screen
          children: [
            const SizedBox(height: 20), // Add some spacing before the button
            TextButton.icon(
              icon: const Icon(Icons.logout), // Use the logout icon
              label: const Text('Log Out'),
              onPressed: () async {
                /* Sign out the user and pop the settings page */
                AuthService().signOut();

                /* Pop all routes until reaching the root route so user is returned to sign in page when signing out */
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
