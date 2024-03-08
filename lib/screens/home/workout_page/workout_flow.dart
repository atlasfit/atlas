import 'package:atlas/models/user.dart';
import 'package:flutter/material.dart';
import 'package:atlas/models/exercise.dart';
import 'package:atlas/screens/home/workout_page/timer.dart';
import 'package:atlas/models/workout.dart';
import 'package:atlas/services/database.dart';
import 'package:provider/provider.dart';
import 'package:atlas/screens/home/profile_page/profile_page.dart';

class WorkoutFlow extends StatefulWidget {
  final Workout workout;

  const WorkoutFlow({super.key, required this.workout});

  @override
  State<WorkoutFlow> createState() => _WorkoutFlowState();
}

class _WorkoutFlowState extends State<WorkoutFlow> {
  late List<Exercise> exercises;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    exercises = widget.workout.exercises;
  }

  @override
  Widget build(BuildContext context) {
    final atlasUser = Provider.of<AtlasUser?>(context);
    final userId = atlasUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.workout.workoutName,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              widget.workout.description,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: exercises.length + 1,
              controller: PageController(viewportFraction: 0.8),
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                if (index == exercises.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      elevation: 4,
                      color: Colors
                          .green[400], // Changed color to indicate completion
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Colors.black, width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center the content vertically
                        children: [
                          const Text(
                            'Complete!',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                              height: 20), // Space between text and button
                          ElevatedButton(
                            onPressed: () {
                              DatabaseService()
                                  .saveCompletedWorkout(widget.workout, userId);
                              //navigate to the profile page
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfilePage()), // Assuming ProfilePage is your destination page
                                (Route<dynamic> route) =>
                                    false, // This predicate always returns false, removing all routes
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5), // Makes the button rectangular
                                // For slight roundness, use: borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      elevation: 4,
                      color: Colors.blueGrey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Colors.black, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              // Wrap the Text widget with a Center widget
                              child: Text(
                                exercises[index]
                                    .name, // Use index instead of currentIndex
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                                textAlign: TextAlign
                                    .center, // Center text horizontally
                              ),
                            ),
                            const SizedBox(
                                height:
                                    16), // Add some space between the exercise name and details
                            Text(
                              'Sets: ${exercises[index].sets}', // Use index to avoid issues during swiping
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Reps: ${exercises[index].reps}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              //add an if statement that checks if the weight has the word "body" in it. If it does, do not display "lbs" after the weight
                              exercises[index].weight.contains(
                                      'b') // Check if the weight contains 'b' (for body weight)
                                  ? 'Weight: ${exercises[index].weight}'
                                  : 'Weight: ${exercises[index].weight} lbs',
                              style: const TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 16), // Space between the Card and TimerWidget
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: TimerWidget(), // The TimerWidget
          ),
          const SizedBox(height: 16), // Space below the TimerWidget
        ],
      ),
    );
  }
}
