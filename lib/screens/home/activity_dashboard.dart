import 'package:atlas/models/user.dart';
import 'package:atlas/models/workout.dart';
import 'package:atlas/services/database.dart';
import 'package:atlas/shared/workout_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityDashboard extends StatefulWidget {
  const ActivityDashboard({super.key});

  @override
  State<ActivityDashboard> createState() => _ActivityDashboardState();
}

class _ActivityDashboardState extends State<ActivityDashboard> {
  final db = DatabaseService();

  /* function to load completed workouts for all users that will be displayed on the activity dashboard */
  Future<List<CompletedWorkout>> _getActivityDashboardWorkouts(
      String userID) async {
    /* create a list to store the completed workouts */
    List<CompletedWorkout> completedWorkouts = [];

    /* create a list to store the completed workouts */
    List<String> userIDs = await db.getFollowerIDs(userID);

    /* add the current user's ID to the list */
    userIDs.add(userID);

    /* loop through the list of user IDs and get the completed workouts for each user */
    for (var id in userIDs) {
      /* get the completed workouts for the user */
      List<CompletedWorkout> workouts = await db.getCompletedWorkoutsByUser(id);

      /* add the completed workouts to the list */
      completedWorkouts.addAll(workouts);
    }

    /* return the list of completed workouts */
    return completedWorkouts;
  }

  @override
  Widget build(BuildContext context) {
    final atlasUser = Provider.of<AtlasUser?>(context);
    final userId = atlasUser?.uid ?? '';

    // Add a button to sign out of firebase
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Dashboard'),
      ),
      body: FutureBuilder<List<CompletedWorkout>>(
        future: _getActivityDashboardWorkouts(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<CompletedWorkout> workouts = snapshot.data ?? [];
            return ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (BuildContext context, int index) {
                return WorkoutCard(workout: workouts[index]);
              },
            );
          } else {
            return const Center(child: Text('No Workouts found'));
          }
        },
      ),
    );
  }
}
