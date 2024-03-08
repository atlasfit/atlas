import 'package:flutter/material.dart';
import 'package:atlas/services/database.dart'; // Ensure this path is correct for your DatabaseService
import 'package:atlas/screens/home/profile_page/settings_page.dart';
import 'package:atlas/screens/home/profile_page/following_page.dart';
import 'package:atlas/screens/home/profile_page/followers_page.dart';
import 'package:atlas/screens/home/profile_page/workout_page.dart';
import 'package:provider/provider.dart';
import 'package:atlas/models/user.dart';
import 'package:atlas/models/workout.dart';

class DefaultProfile extends StatefulWidget {
  final String otherUserId;

  const DefaultProfile({super.key, required this.otherUserId});

  @override
  State<DefaultProfile> createState() => _DefaultProfileState();
}

class _DefaultProfileState extends State<DefaultProfile> {
  bool? isUserFollowing;

  Future<bool?> checkFollowingStatus() async {
    final atlasUser = Provider.of<AtlasUser?>(context, listen: false);
    final userIdCurrUser = atlasUser?.uid ?? '';

    if (userIdCurrUser.isNotEmpty) {
      return await DatabaseService()
          .isFollowing(userIdCurrUser, widget.otherUserId);
    }
    return null; // Indicates that the check could not be performed
  }

  Widget _buildCountButton(String label, Future<List<String>> users) {
    return FutureBuilder<List<String>>(
      future: users,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the Future to complete
          return const CircularProgressIndicator();
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
                      // pass the list input to display on the corresponding page
                      builder: (context) => FollowersPage(followers: users)),
                );
              } else if (label == 'Following') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      // pass the list input to display on the corresponding page
                      builder: (context) => FollowingPage(following: users)),
                );
              }
            },
            child: Column(
              children: [
                Text('$count', style: const TextStyle(fontSize: 20)),
                Text(label),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildWorkoutsButton(Future<List<Workout>> workoutListFuture) {
    return FutureBuilder<List<Workout>>(
      future: workoutListFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Workout>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the Future to complete
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle any errors that occur during fetching the data
          return Text('Error: ${snapshot.error}');
        } else {
          // Once the Future is complete, use the length of the list
          int count = snapshot.data?.length ?? 0;
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
            ),
            onPressed: () {
              // If the button is pressed, navigate to the WorkoutPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  // Pass the Future directly to the WorkoutPage
                  builder: (context) =>
                      WorkoutPage(workouts: workoutListFuture),
                ),
              );
            },
            child: Column(
              children: [
                Text('$count', style: const TextStyle(fontSize: 20)),
                const Text('Workouts'),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildFollowingUnfollowingButton() {
    return FutureBuilder<bool?>(
      future: checkFollowingStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          // Show a loading indicator or a disabled button while waiting for data
          return const ElevatedButton(
            onPressed: null, // Disable the button
            child: Text('Loading...'),
          );
        }

        final isFollowing =
            snapshot.data ?? false; // Safely use the snapshot data

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ElevatedButton(
            onPressed: () async {
              final atlasUser = Provider.of<AtlasUser?>(context, listen: false);
              final userIdCurrUser = atlasUser?.uid ?? '';

              if (isFollowing) {
                await DatabaseService()
                    .unfollowUser(userIdCurrUser, widget.otherUserId);
              } else {
                await DatabaseService()
                    .followUser(userIdCurrUser, widget.otherUserId);
              }
              // Force a rebuild to refresh the button state
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isFollowing
                  ? const Color.fromARGB(255, 51, 51, 51)
                  : const Color.fromARGB(255, 20, 111, 185),
              fixedSize: const Size(100, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
            ),
            child: Text(
              isFollowing ? 'Unfollow' : 'Follow',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AtlasUser>(
      future: DatabaseService().getAtlasUser(widget.otherUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('User not found or error occurred'));
        }

        final userData = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const SizedBox(width: 40),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()),
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
                      padding:
                          EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
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
                          '${userData.firstName} ${userData.lastName}',
                          style: const TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          '@${userData.username}',
                          style: const TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5.0),
                      ],
                    ),
                    buildFollowingUnfollowingButton(),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWorkoutsButton(DatabaseService()
                        .getCreatedWorkoutsByUser(widget.otherUserId)),
                    _buildCountButton('Followers',
                        DatabaseService().getFollowerIDs(widget.otherUserId)),
                    _buildCountButton('Following',
                        DatabaseService().getFollowingIDs(widget.otherUserId)),
                  ],
                ),
                const SizedBox(height: 15.0),
                const Divider(color: Colors.black, thickness: 2),
                const SizedBox(height: 15.0),
              ]),
            ],
          ),
        );
      },
    );
  }
}
