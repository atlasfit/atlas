import 'package:flutter/material.dart';
import 'package:atlas/models/workout.dart'; // Import your Workout model
import 'package:atlas/screens/home/shared_widgets/detailed_workout_card.dart'; // Import the DetailedWorkoutCard

class DetailedWorkoutPage extends StatelessWidget {
  final Workout workout;

  const DetailedWorkoutPage({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.workoutName),
        centerTitle: true, // Horizontally center the title
      ),
      body: SingleChildScrollView(
        child: DetailedWorkoutCard(workout: workout),
      ),
    );
  }
}
