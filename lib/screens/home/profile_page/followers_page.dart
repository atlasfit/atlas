import 'package:flutter/material.dart';
import 'package:atlas/services/database.dart'; // Import your DatabaseService

class FollowersPage extends StatefulWidget {
  final Future<List<dynamic>> followers;

  const FollowersPage({super.key, required this.followers});

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Followers',
          textAlign: TextAlign.center, // Center the text within the app bar
        ),
        centerTitle: true, // Horizontally center the title
      ),
      body: FutureBuilder<List<dynamic>>(
        future:
            widget.followers, // Use the followers future passed to the widget
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<dynamic> followers = snapshot.data!;
            return ListView.builder(
              itemCount: followers.length,
              itemBuilder: (context, index) {
                var userId = followers[index];
                return FutureBuilder<Map<String, dynamic>>(
                  future: DatabaseService().getUserData(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      Map<String, dynamic> follower = snapshot.data!;
                      return Card(
                        child: ListTile(
                          title: Text(
                              '@${follower['username']}'), // Corrected map access
                          subtitle: Text(
                              '${follower['firstName'] ?? ''} ${follower['lastName'] ?? ''}'), // Corrected map access with null check
                        ),
                      );
                    } else {
                      return const Center(child: Text('No followers found'));
                    }
                  },
                );
                //
                // Access follower data assuming it's a Map
              },
            );
          } else {
            return const Center(child: Text('No followers found'));
          }
        },
      ),
    );
  }
}
