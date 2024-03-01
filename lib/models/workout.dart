import 'package:atlas/models/exercise.dart';

class Workout {
  String createdBy;
  String workoutName;
  String description;
  List<Exercise> exercises;

  Workout(
      {required this.createdBy,
      required this.workoutName,
      this.description = "",
      required this.exercises});
}
