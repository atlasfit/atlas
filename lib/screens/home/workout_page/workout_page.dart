import 'package:flutter/material.dart';
import 'package:atlas/screens/home/workout_page/workout_builder.dart'; // Ensure this import path is correct

// Workout Page
class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Page'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const WorkoutBuilder()), // Ensure the class name is correct
            );
          },
          icon: const Icon(Icons.add), // "+" Icon
          label: const Text('Create Workout'), // Button text
        ),
      ),
    );
  }
}
