import 'package:flutter/material.dart';
import 'package:atlas/services/auth.dart'; // Ensure this import is correct and AuthService class has a signOut method

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
            const Text('Settings Page'),
            const SizedBox(height: 20), // Add some spacing before the button
            TextButton.icon(
              icon: const Icon(Icons.logout), // Use the logout icon
              label: const Text('Log Out'),
              onPressed: () async {
                // Add sign out functionality
                // Call signOut method from AuthService
                AuthService().signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Sign Out'),
            onPressed: () async {
              // Add sign out functionality
              //Call signOut method from AuthService
              AuthService().signOut();
            },
          ), */