// I want to take in the workoutIds and display the workouts in a list
// I will use the getWorkoutsByUser function from the database.dart file
// I will also use the Workout class from the workout.dart file
// I will use the FutureBuilder to display the workouts in a list
// I will also use the Provider to get the userId

// I will start by importing the necessary files
import 'package:atlas/models/workout.dart';
import 'package:provider/provider.dart';
import 'package:atlas/services/database.dart'; // Import your DatabaseService
import 'package:flutter/material.dart';
import 'package:atlas/models/user.dart';

// I will then create the DisplayWorkoutsPage class
class DisplayWorkoutsPage extends StatelessWidget {
  // I will create a function that returns a Future<List<Workout>> using the getWorkoutsByUser function from the database.dart file
  Future<List<Workout>> getWorkoutsByUser(BuildContext context) async {
    // Get the userId from the Provider
    final atlasUser = Provider.of<AtlasUser?>(context);
    final userId = atlasUser?.uid ?? '';
    List<Workout> workouts = await DatabaseService().getWorkoutsByUser(userId);
    return workouts;
  }

  @override
  Widget build(BuildContext context) {
    // I will use the FutureBuilder to display the workouts in a list
    return FutureBuilder<List<Workout>>(
      future: getWorkoutsByUser(context),
      builder: (BuildContext context, AsyncSnapshot<List<Workout>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the Future to complete
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle any errors that occur during fetching the data
          return Text('Error: ${snapshot.error}');
        } else {
          // Once the Future is complete, use the length of the list
          List<Workout> workouts = snapshot.data ?? [];
          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(workouts[index].workoutName),
                subtitle: Text(workouts[index].description),
              );
            },
          );
        }
      },
    );
  }
}
// I will now use the DisplayWorkoutsPage in the ProfilePage
// I will import the DisplayWorkoutsPage in the profile_page.dart file
// I will then add the DisplayWorkoutsPage to the ProfilePage widget
// I will also pass the context