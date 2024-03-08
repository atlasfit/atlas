import 'package:flutter/material.dart';
import 'package:atlas/models/workout.dart'; // Import your Workout model
import 'package:atlas/screens/home/profile_page/detailed_workout_page.dart'; // Import the DetailedWorkoutPage

class WorkoutPage extends StatefulWidget {
  final Future<List<Workout>> workouts; // Change the type to List<Workout>

  const WorkoutPage({super.key, required this.workouts});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Horizontally center the title
        title: const Text(
          'Workouts',
          textAlign: TextAlign.center, // Center the text within the app bar
        ),
      ),
      body: FutureBuilder<List<Workout>>(
          future:
              widget.workouts, // Use the followers future passed to the widget
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              List<Workout> workouts = (snapshot.data ?? []);

              return ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                      title: Text(workouts[index].workoutName),
                      subtitle: Text(workouts[index].description),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailedWorkoutPage(workout: workouts[index]),
                          ),
                        );
                      },
                    ));
                  });
            } else {
              return const Center(child: Text('No Workouts found'));
            }
          }),
    );
  }
}
