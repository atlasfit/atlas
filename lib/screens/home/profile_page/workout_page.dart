import 'package:flutter/material.dart';
import 'package:atlas/models/workout.dart'; // Import your Workout model

class WorkoutPage extends StatefulWidget {
  final Future<List<dynamic>> workouts; // Change the type to List<Workout>

  const WorkoutPage({super.key, required this.workouts});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workouts',
          textAlign: TextAlign.center, // Center the text within the app bar
        ),
        centerTitle: true, // Horizontally center the title
      ),
      body: FutureBuilder<List<dynamic>>(
          future:
              widget.workouts, // Use the followers future passed to the widget
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              List<Workout> workouts = (snapshot.data ?? []) as List<Workout>;
              return ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                      title: Text(workouts[index].workoutName),
                      subtitle: Text(workouts[index].description),
                    ));
                  });
            } else {
              return const Center(child: Text('No Workouts found'));
            }
          }),
    );
  }
}
