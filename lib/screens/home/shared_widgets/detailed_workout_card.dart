import 'package:flutter/material.dart';
import 'package:atlas/models/workout.dart';
import 'package:atlas/screens/home/workout_page/workout_flow.dart';

/* A widget that displays a detailed workout card when a workout is clicked on */
class DetailedWorkoutCard extends StatelessWidget {
  final Workout workout;

  /// Constructs a [DetailedWorkoutCard] with the given [workout].
  const DetailedWorkoutCard({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                workout.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold, // Make the text bold
                    ),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutFlow(
                        workout: workout,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.directions_run),
                label: const Text('Start Workout'),
              ),
            ),
            const SizedBox(height: 16.0),
            ListView.builder(
              physics:
                  const NeverScrollableScrollPhysics(), // to disable ListView's own scrolling
              shrinkWrap:
                  true, // necessary to make ListView behave inside Column
              itemCount: workout.exercises.length,
              itemBuilder: (context, index) {
                final exercise = workout.exercises[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}) ${exercise.name}",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold, // Make the text bold
                              fontSize: 18.0, // Increase the font size
                            ),
                      ),
                      Text("Sets: ${exercise.sets}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                fontSize: 18,
                              )), // Use the bodyLarge text style for the set
                      Text("Reps: ${exercise.reps}",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 18,
                                  )),
                      Text("Weight: ${exercise.weight}",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 18,
                                  )),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
