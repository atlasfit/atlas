import 'package:flutter/material.dart';
import 'package:atlas/models/exercise.dart';
import 'package:atlas/screens/home/workout_page/timer.dart';

class WorkoutFlow extends StatefulWidget {
  const WorkoutFlow({super.key});

  @override
  State<WorkoutFlow> createState() => _WorkoutFlowState();
}

class _WorkoutFlowState extends State<WorkoutFlow> {
  List<Exercise> exercises = [
    Exercise(name: 'Push-ups', sets: "3", reps: "10"),
    Exercise(name: 'Squats', sets: "3", reps: "12"),
    Exercise(name: 'Plank', sets: "3", reps: "30"),
    // Add more exercises here
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Flow'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Workout Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              exercises[currentIndex].name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: exercises.length,
              controller: PageController(viewportFraction: 0.8),
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 4, // Add elevation for a defined border
                    color: Colors.blueGrey[800], // Set a darker color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Add rounded corners
                      side: const BorderSide(
                          color: Colors.black, width: 1), // Add a border
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sets: ${exercises[currentIndex].sets}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Reps: ${exercises[currentIndex].reps}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
              height: 16), // Add space between the Card and TimerWidget
          const Padding(
            padding: EdgeInsets.all(16.0),
            child:
                TimerWidget(), // Replace the empty space with the TimerWidget
          ),
          const SizedBox(height: 16), // Add space below the TimerWidget
        ],
      ),
    );
  }
}
