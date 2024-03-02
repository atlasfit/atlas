import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atlas/models/exercise.dart';
import 'package:atlas/models/workout.dart';

// Firestore initialization
FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference exercisesCollection = firestore.collection('exercises');
CollectionReference workoutsCollection = firestore.collection('workouts');
CollectionReference completedWorkoutsCollection =
    firestore.collection("completedWorkouts");

class DatabaseService {
  /* Function to get user's followers ids and return them as a list */
  Future<List> getFollowers(String userId) async {
    var doc = await firestore.collection('followers').doc(userId).get();
    if (doc.exists) {
      List followers = doc.data()?['followers'] ?? [];
      return followers;
    }
    return [];
  }

  /* Function to get user's following ids and return them as a list */
  Future<List> getFollowing(String userId) async {
    var doc = await firestore.collection('following').doc(userId).get();
    if (doc.exists) {
      List following = doc.data()?['following'] ?? [];
      return following;
    }
    return [];
  }

  //Function to get username, firstname and lastname from userid. Used in followers and following page
  Future<Map<String, dynamic>> getUserData(String userId) async {
    var doc = await firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return {
        'username': doc.data()?['username'] ?? '',
        'firstName': doc.data()?['firstName'] ?? '',
        'lastName': doc.data()?['lastName'] ?? ''
      };
    }
    return {};
  }

  Future<List> getWorkoutIDsByUser(String userId) async {
    var doc = await firestore.collection('workoutsByUser').doc(userId).get();
    if (doc.exists) {
      List workoutIDs = doc.data()?['workoutIDs'] ?? [];
      return workoutIDs;
    }
    return [];
  }

  //return a Workout object from a workout id

  Future<void> saveWorkout(Workout workout, String userId) async {
    DocumentReference workoutRef = await workoutsCollection.add({
      'createdBy': userId,
      'workoutName': workout.workoutName,
      'description': workout.description,
      'exercises': workout.exercises
          .map((exercise) => {
                'exerciseName': exercise.name,
                'sets': exercise.sets,
                'reps': exercise.reps,
                'weight': exercise.weight,
                'description': exercise.description,
                'equipment': exercise.equipment,
                'targetMuscle': exercise.targetMuscle,
              })
          .toList(),
    });

    // Update the workoutsByUser collection
    DocumentReference userWorkoutsRef =
        firestore.collection('workoutsByUser').doc(userId);
    await userWorkoutsRef.update({
      'workoutIDs': FieldValue.arrayUnion([workoutRef.id])
    });
  }

  //Write a function that returns a list of workouts from a list of workoutIDs
  Future<List<Workout>> getWorkoutsByUser(String userId) async {
    List workoutIDs = await getWorkoutIDsByUser(userId);
    List<Workout> workouts = [];
    for (var workoutID in workoutIDs) {
      DocumentSnapshot workoutDoc =
          await workoutsCollection.doc(workoutID).get();
      if (workoutDoc.exists) {
        workouts.add(Workout(
            createdBy: workoutDoc['createdBy'],
            workoutName: workoutDoc['workoutName'],
            description: workoutDoc['description'],
            exercises: workoutDoc['exercises']
                .map<Exercise>((exercise) => Exercise(
                    name: exercise['exerciseName'],
                    sets: exercise['sets'],
                    reps: exercise['reps'],
                    weight: exercise['weight']))
                .toList()));
      }
    }
    return workouts;
  }

  Future<List<Workout>> getCompletedWorkoutsByUser(String userId) async {
    List workoutIDs = await getWorkoutIDsByUser(userId);
    List<Workout> workouts = [];
    for (var workoutID in workoutIDs) {
      DocumentSnapshot workoutDoc =
          await completedWorkoutsCollection.doc(workoutID).get();
      if (workoutDoc.exists) {
        workouts.add(Workout(
            createdBy: workoutDoc['createdBy'],
            workoutName: workoutDoc['workoutName'],
            description: workoutDoc['description'],
            exercises: workoutDoc['exercises']
                .map<Exercise>((exercise) => Exercise(
                    name: exercise['exerciseName'],
                    sets: exercise['sets'],
                    reps: exercise['reps'],
                    weight: exercise['weight']))
                .toList()));
      }
    }
    return workouts;
  }
}
