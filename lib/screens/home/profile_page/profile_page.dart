import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'package:atlas/models/user.dart';
import 'package:atlas/models/workout.dart';
import 'package:provider/provider.dart';
import 'package:atlas/services/database.dart'; // Import your DatabaseService
import 'following_page.dart';
import 'followers_page.dart';
import 'display_workouts_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Widget to build the count button
  Widget _buildCountButton(String label, Future<List<dynamic>> countFuture) {
    return FutureBuilder<List<dynamic>>(
      future: countFuture,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the Future to complete
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle any errors that occur during fetching the data
          return Text('Error: ${snapshot.error}');
        } else {
          // Once the Future is complete, use the length of the list
          int count = snapshot.data?.length ?? 0;
          return ElevatedButton(
            //decrease space between buttons

            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
            ),
            onPressed: () {
              if (label == 'Followers') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FollowersPage(followers: countFuture)),
                );
              } else if (label == 'Following') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FollowingPage(following: countFuture)),
                );
                // Navigate to the following page
              }
            },
            child: Column(
              children: [
                Text('$count', style: TextStyle(fontSize: 20)),
                Text(label),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get AtlasUser
    final atlasUser = Provider.of<AtlasUser?>(context);
    final userId = atlasUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const SizedBox(width: 40),
            Text('Profile', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        "https://image-cdn.essentiallysports.com/wp-content/uploads/arnold-schwarzenegger-volume-workout-1110x788.jpg"), // Replace with user's profile picture
                  ),
                ),
                const SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15.0),
                    Text(
                      '${atlasUser?.firstName ?? "First"} ${atlasUser?.lastName ?? "Last"}',
                      style: const TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      '@${atlasUser?.username ?? "username"}',
                      style: const TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5.0),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15.0),

            Row(
              //decrease padding between buttons
              //align the buttons to the right of the screen
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Align the buttons to the right of the screen

              children: [
                _buildCountButton(
                    'Workouts', DatabaseService().getWorkoutIDsByUser(userId)),
                _buildCountButton(
                    'Followers', DatabaseService().getFollowersCount(userId)),
                _buildCountButton(
                    'Following', DatabaseService().getFollowingCount(userId)),
              ],
            ),
            //add space between divider and above
            const SizedBox(height: 15.0),
            const Divider(
              color: Colors.black,
              thickness: 2,
            ),
            const SizedBox(height: 15.0),
            ...List.generate(
              2, // Dynamically change this for each user depending on the number of workouts they've posted
              (index) => const Card(
                child: ListTile(
                  title: Text(
                      "Recent Workout Card"), // Placeholder until you decide how each card should look
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
