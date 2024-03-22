import 'package:atlas/screens/home/profile_page/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:atlas/services/database.dart';
import 'package:atlas/models/user.dart';

class FollowingPage extends StatefulWidget {
  final Future<List<String>> following; // Assuming this is a list of user IDs

  const FollowingPage({super.key, required this.following});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  // function to get following users
  Future<List<AtlasUser>> _getFollowingUsers() async {
    // wait on following user IDs to be passed and saved to userIds
    List<String> userIds = await widget.following;

    // get AtlasUser objects for each user ID concurrently
    List<Future<AtlasUser>> futures = userIds
        .map((userId) => DatabaseService().getAtlasUser(userId))
        .toList();

    // wait for all futures to complete and return the list of AtlasUser objects
    List<AtlasUser> users = await Future.wait(futures);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<AtlasUser>>(
        future:
            _getFollowingUsers(), // Fetch following users as AtlasUser objects
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Consider customizing this message based on the error
            return const Center(
                child: Text('Something went wrong. Please try again later.'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var user = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text('@${user.username}'),
                    subtitle: Text('${user.firstName} ${user.lastName}'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileView(userID: user.uid),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No following found'));
          }
        },
      ),
    );
  }
}
