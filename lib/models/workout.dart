import 'package:atlas/models/exercise.dart';
import 'package:atlas/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  AtlasUser createdBy;
  String workoutID;
  String workoutName;
  String description;
  List<Exercise> exercises;

  Workout(
      {required this.createdBy,
      required this.workoutName,
      required this.workoutID,
      this.description = "",
      required this.exercises});
}

class CompletedWorkout extends Workout {
  Timestamp completedTime;
  AtlasUser completedBy;

  CompletedWorkout(
      {required super.createdBy,
      required super.workoutName,
      super.description = "",
      required super.exercises,
      required this.completedTime,
      required this.completedBy,
      required super.workoutID});
}
