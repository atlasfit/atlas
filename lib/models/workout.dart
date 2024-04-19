import 'package:atlas/models/exercise.dart';
import 'package:atlas/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/* Represents a workout created by a user. */
class Workout {
  AtlasUser createdBy; // The user who created the workout.
  String workoutID; // The unique ID of the workout.
  String workoutName; // The name of the workout.
  String description; // The description of the workout.
  List<Exercise> exercises; // The list of exercises in the workout.

  /// Constructs a new instance of the [Workout] class.
  Workout({
    required this.createdBy,
    required this.workoutName,
    required this.workoutID,
    required this.description,
    required this.exercises,
  });
}

/* Represents a completed workout by a user. */
class CompletedWorkout extends Workout {
  Timestamp completedTime; // The timestamp when the workout was completed.
  AtlasUser completedBy; // The user who completed the workout.
  String photoURL; // The URL of the photo of the completed workout.

  /// Constructs a new instance of the [CompletedWorkout] class.
  CompletedWorkout({
    required super.createdBy,
    required super.workoutName,
    required super.description,
    required super.exercises,
    required this.completedTime,
    required this.completedBy,
    required this.photoURL,
    required super.workoutID,
  });
}
