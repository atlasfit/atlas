import 'package:flutter/material.dart';
import 'package:atlas/services/database.dart';
import 'profile_wrapper.dart';
import 'package:atlas/models/user.dart';

class FollowersPage extends StatefulWidget {
  final Future<List<String>> followers;

  const FollowersPage({super.key, required this.followers});

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  Future<List<AtlasUser>> _getFollowersUsers() async {
    List<String> userIds = await widget.followers;
    List<AtlasUser> users = [];
    for (String userId in userIds) {
      var user = await DatabaseService().getAtlasUser(userId);
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<AtlasUser>>(
        future: _getFollowersUsers(),
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
                        builder: (context) => ProfileWrapper(userID: user.uid),
                      ),
                    ),
                  ),
                );
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
