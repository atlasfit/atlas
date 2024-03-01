import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // If you're using Firestore
import 'package:atlas/models/exercise.dart'; // Ensure this path is correct
import 'package:atlas/screens/home/workout_page/exercise_selection_page.dart'; // Verify the path
import 'package:atlas/services/database.dart'; // Verify the path
import 'package:atlas/models/user.dart';
import 'package:atlas/models/workout.dart';
import 'package:provider/provider.dart';

class WorkoutBuilder extends StatefulWidget {
  const WorkoutBuilder({Key? key}) : super(key: key);

  @override
  _WorkoutBuilderState createState() => _WorkoutBuilderState();
}

class _WorkoutBuilderState extends State<WorkoutBuilder> {
  String workoutName = '';
  String workoutDescription = '';
  List<Exercise> selectedExercises = [];

  @override
  Widget build(BuildContext context) {
    final atlasUser = Provider.of<AtlasUser?>(context);
    final userId = atlasUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Builder'),
        centerTitle: true, // Center the title text
        actions: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
                vertical:
                    8), // Adjusts the button's vertical positioning and size
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                  255, 19, 69, 109), // Background color of the butt  on
              borderRadius: BorderRadius.circular(
                  4), // Adjusts the roundness of button corners to make it rectangular
            ),
            child: TextButton(
              onPressed: () async {
                if (atlasUser != null) {
                  // Ensure there is a logged-in user
                  Workout newWorkout = Workout(
                    createdBy:
                        atlasUser.uid, // Use the user ID from the Provider
                    workoutName: workoutName,
                    description: workoutDescription,
                    exercises: selectedExercises,
                  );

                  await DatabaseService().saveWorkout(newWorkout,
                      userId); // Call the saveWorkout method with the new Workout object
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Workout Saved!')));
                  Navigator.pop(
                      context); // Optionally navigate back or reset the form
                } else {
                  // Handle the case where there is no logged-in user
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No user logged in.')));
                }
              },
              child: Text('Save', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                backgroundColor: Colors
                    .transparent, // Makes the TextButton's background transparent
                padding: EdgeInsets.symmetric(
                    horizontal: 16), // Horizontal padding within the button
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Workout Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => workoutName = value,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Workout Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => workoutDescription = value,
              ),
              SizedBox(height: 20),
              ...selectedExercises.asMap().entries.map((entry) {
                int idx = entry.key;
                Exercise exercise = entry.value;
                return ExerciseTile(
                  exercise: exercise,
                  onDelete: () =>
                      setState(() => selectedExercises.removeAt(idx)),
                  onEdit: () => _showEditExerciseDialog(exercise, idx),
                  index: idx, // Pass the index to ExerciseTile
                );
              }).toList(),
              Center(
                child: ElevatedButton(
                  onPressed: () => _navigateAndDisplaySelection(context),
                  child: Text('Add Exercise'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final Exercise? selectedExercise = await Navigator.push<Exercise>(
      context,
      MaterialPageRoute(builder: (context) => ExerciseSelectionPage()),
    );

    if (selectedExercise != null) {
      _showAddExerciseDetailsDialog(selectedExercise);
    }
  }

  Future<void> _showAddExerciseDetailsDialog(Exercise exercise) async {
    TextEditingController setsController = TextEditingController();
    TextEditingController repsController = TextEditingController();
    TextEditingController weightController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Details for ${exercise.name}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: setsController,
                  decoration: InputDecoration(labelText: 'Sets'),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: repsController,
                  decoration: InputDecoration(labelText: 'Reps'),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: weightController,
                  decoration: InputDecoration(labelText: 'Weight (lbs)'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  selectedExercises.add(Exercise(
                    name: exercise.name,
                    sets: setsController.text,
                    reps: repsController.text,
                    weight: weightController.text,
                  ));
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditExerciseDialog(Exercise exercise, int index) async {
    TextEditingController setsController =
        TextEditingController(text: exercise.sets);
    TextEditingController repsController =
        TextEditingController(text: exercise.reps);
    TextEditingController weightController =
        TextEditingController(text: exercise.weight);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Details for ${exercise.name}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: setsController,
                  decoration: InputDecoration(labelText: 'Sets'),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: repsController,
                  decoration: InputDecoration(labelText: 'Reps'),
                  keyboardType: TextInputType.text,
                ),
                TextField(
                  controller: weightController,
                  decoration: InputDecoration(labelText: 'Weight (lbs)'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  selectedExercises[index] = Exercise(
                    name: exercise.name,
                    sets: setsController.text,
                    reps: repsController.text,
                    weight: weightController.text,
                  );
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final int index;

  const ExerciseTile({
    Key? key,
    required this.exercise,
    required this.onDelete,
    required this.onEdit,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('${index + 1}) ',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                    child: Text(exercise.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
              ],
            ),
            Text(
                'Sets: ${exercise.sets}, Reps: ${exercise.reps}, Weight: ${exercise.weight}lbs'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: onEdit),
                IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
