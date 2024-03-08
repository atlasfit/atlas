import 'package:flutter/material.dart';
import 'package:atlas/screens/home/workout_page/workout_builder.dart'; // Ensure this import path is correct
import 'package:atlas/screens/home/workout_page/workout_flow.dart';

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
        centerTitle: true, // Horizontally center the title

        title: const Text('Workout Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkoutFlow(),
                  ),
                );
              },
              icon: const Icon(Icons.directions_run),
              label: const Text('Start Workout'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkoutBuilder(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Workout'),
            ),
          ],
        ),
      ),
    );
  }
}
