import 'package:flutter/material.dart';
import 'package:atlas/services/database.dart'; // Ensure this path is correct for your DatabaseService
import 'package:atlas/screens/home/profile_page/settings_page.dart';
import 'package:atlas/screens/home/profile_page/following_page.dart';
import 'package:atlas/screens/home/profile_page/followers_page.dart';
import 'package:atlas/screens/home/profile_page/created_workouts_page.dart';
import 'package:provider/provider.dart';
import 'package:atlas/models/user.dart';
import 'package:atlas/models/workout.dart';

class ProfileView extends StatefulWidget {
  final String userID;

  const ProfileView({super.key, required this.userID});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  /* function to return widget of the button for followers and following that has the number of each */
  Widget _buildCountButton(String label, Future<List<String>> users) {
    return FutureBuilder<List<String>>(
      future:
          users, // these are the followers or following of the user depending on which are passed
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          /* Show a loading indicator while waiting for the Future to complete */
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          /* Handle any errors that occur during fetching the data */
          return Text('Error: ${snapshot.error}');
        } else {
          /* Once the Future is complete, use the length of the list */
          int count = snapshot.data?.length ?? 0;
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
            ),
            onPressed: () {
              /* If the button is pressed, navigate to the FollowersPage or FollowingPage */
              if (label == 'Followers') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      /* pass the list input to display on the corresponding page */
                      builder: (context) => FollowersPage(followers: users)),
                );
              } else if (label == 'Following') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      /* pass the list input to display on the corresponding page */
                      builder: (context) => FollowingPage(following: users)),
                );
              }
            },
            /* Display the number of followers or following */
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

  /* function to return widget of the button for workouts that has the number of workouts */
  Widget _buildWorkoutsButton(Future<List<Workout>> workoutListFuture) {
    return FutureBuilder<List<Workout>>(
      future: workoutListFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Workout>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          /* Show a loading indicator while waiting for the Future to complete */
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          /* Handle any errors that occur during fetching the data */
          return Text('Error: ${snapshot.error}');
        } else {
          /* Once the Future is complete, use the length of the list */
          int count = snapshot.data?.length ?? 0;
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
            ),
            onPressed: () {
              /* If the button is pressed, navigate to the WorkoutPage */
              Navigator.push(
                context,
                MaterialPageRoute(
                  /* Pass the Future directly to the WorkoutPage */
                  builder: (context) =>
                      CreatedWorkoutsPage(workouts: workoutListFuture),
                ),
              );
            },
            /* Display the number of workouts */
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

  /* function to return widget of the button for following and unfollowing a user */
  Widget buildFollowingUnfollowingButton(userIdCurrUser) {
    if (userIdCurrUser != widget.userID) {
      return FutureBuilder<bool?>(
        future: DatabaseService().isFollowing(
            userIdCurrUser,
            widget
                .userID), // Future that checks if the user is following the other user
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            /* Show a loading indicator or a disabled button while waiting for data */
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
                /* Follow or unfollow the user based on if the user is already following that person */
                if (isFollowing) {
                  await DatabaseService()
                      .unfollowUser(userIdCurrUser, widget.userID);
                } else {
                  await DatabaseService()
                      .followUser(userIdCurrUser, widget.userID);
                }
                /* Force a rebuild to refresh the button state */
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
    } else {
      return Container(); // Return an empty container if the current user is the same as the user ID
    }
  }

  @override
  Widget build(BuildContext context) {
    /* get atlas user from provider stream */
    final atlasUser = Provider.of<AtlasUser?>(context, listen: false);
    final userIdCurrUser = atlasUser?.uid ?? '';

    return FutureBuilder<AtlasUser>(
      future: DatabaseService()
          .getAtlasUser(widget.userID), // Future that gets the other users data
      builder: (context, snapshot) {
        /* Show a loading indicator while waiting for the Future to complete */
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('User not found or error occurred'));
        }

        /* Once the Future is complete, use the data get the user object*/
        final AtlasUser userData = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const SizedBox(width: 40),
                const Spacer(),
                /* Add a button to navigate to the settings page */
                IconButton(
                  icon: const Icon(Icons.settings),
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
              /* Column containing user image + name + followers/following/workouts */
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                      child: CircleAvatar(
                        radius: 40,
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
                    buildFollowingUnfollowingButton(userIdCurrUser)
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWorkoutsButton(DatabaseService()
                        .getCreatedWorkoutsByUser(widget.userID)),
                    _buildCountButton('Followers',
                        DatabaseService().getFollowerIDs(widget.userID)),
                    _buildCountButton('Following',
                        DatabaseService().getFollowingIDs(widget.userID)),
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
