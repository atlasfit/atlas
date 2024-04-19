import 'package:atlas/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atlas/models/exercise.dart';
import 'package:atlas/models/workout.dart';
import 'package:firebase_storage/firebase_storage.dart';
//IMAGE PICKING IMPORTS
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class DatabaseService {
  /* Firestore initialization */
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /* Firebase Storage initialization */
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /* GENERAL FUNCTIONS */

  /* Function to create a new document id */
  String createDocID(String collection) {
    /* get reference to collection to add document to */
    DocumentReference ref = firestore.collection(collection).doc();

    /* get the id of the document */
    String myId = ref.id;

    /* return the id */
    return myId;
  }

  /* USER FUNCTIONS */

  /* Function to get user's and return them as a list of AtlasUser objects */
  Future<List<AtlasUser>> getUsers() async {
    QuerySnapshot querySnapshot = await firestore.collection('users').get();

    /* Use Future.wait to wait for all the getAtlasUser futures to complete */
    List<AtlasUser> users =
        await Future.wait(querySnapshot.docs.map((doc) async {
      return await getAtlasUser(doc.id);
    }));

    return users;
  }

  /* Function to get user from userid and return them as an AtlasUser object */
  Future<AtlasUser> getAtlasUser(String userId) async {
    /* get the user document from the database */
    var doc = await firestore.collection('users').doc(userId).get();

    /* if the document exists, return a new AtlasUser object with the data from the document */
    if (doc.exists) {
      return AtlasUser(
          uid: userId,
          email: doc.data()?['email'] ?? '',
          firstName: doc.data()?['firstName'] ?? '',
          lastName: doc.data()?['lastName'] ?? '',
          username: doc.data()?['username'] ?? '',
          followerCount: doc.data()?['followerCount'] ?? 0,
          followingCount: doc.data()?['followingCount'] ?? 0,
          workoutCount: doc.data()?['workoutCount'] ?? 0);
    } else {
      /* if the document does not exist, throw an exception */
      throw Exception('User: $userId not found');
    }
  }

  /* WORKOUT FUNCTIONS */

  /* Function that gets created workout id from a user by taking in their userid and returning them as a list of strings */
  Future<List<String>> getWorkoutIDsByUser(String userId) async {
    /* get the workoutIDs from the user */
    var doc = await firestore.collection('workoutsByUser').doc(userId).get();

    /* create an empty list of workoutIDs */
    List<String> workoutIDs = [];

    /* if the document exists, return the workoutIDs as a list of strings */
    if (doc.exists) {
      /* get the workoutIDs from the document */
      List<dynamic> workoutIDsDynamic = doc.data()?['workoutIDs'] ?? [];

      /* Explicitly cast each element in the list to String */
      workoutIDs = workoutIDsDynamic.map((e) => e.toString()).toList();
    }

    /* return the list of workoutIDs */
    return workoutIDs;
  }

  /* Function that takes workout id and returns the workout object corresponding to that id */
  Future<Workout> getWorkoutFromWorkoutID(String workoutID) async {
    /* get the workout document from the database */
    var doc = await firestore.collection("workouts").doc(workoutID).get();

    AtlasUser createdBy = await getAtlasUser(doc['createdBy']);

    /* if the document exists, return a new Workout object with the data from the document */
    if (doc.exists) {
      return Workout(
          /* save createdBy as an AtlasUser object */
          createdBy: createdBy,
          workoutID: doc['workoutID'],
          workoutName: doc['workoutName'],
          description: doc['description'],
          exercises: doc['exercises']
              .map<Exercise>((exercise) => Exercise(
                  name: exercise['exerciseName'],
                  sets: exercise['sets'],
                  reps: exercise['reps'],
                  weight: exercise['weight']))
              .toList());
    } else {
      /* if the document does not exist, throw an exception */
      throw Exception('Workout with ID $workoutID not found.');
    }
  }

  /* a function that returns a list of workouts from a list of workoutIDs */
  Future<List<Workout>> getCreatedWorkoutsByUser(String userId) async {
    /* get the workoutIDs from the user */
    List<String> workoutIDs = await getWorkoutIDsByUser(userId);
    List<Workout> workouts = [];

    for (var workoutID in workoutIDs) {
      try {
        /* get the workout from the workoutID and add it to the workouts list */
        Workout workout = await getWorkoutFromWorkoutID(workoutID);
        workouts.add(workout);
      } catch (e) {
        /* if there is an error, throw an exception */
        throw Exception('Error fetching workout with ID $workoutID: $e');
      }
    }

    return workouts;
  }

  Future<List<CompletedWorkout>> getCompletedWorkoutsByUser(
      String userId) async {
    /* Pair workout IDs with timestamps */
    List<CompletedWorkout> completedWorkouts = [];

    /* get the completedWorkoutIDs from the user */
    var doc = await firestore.collection('completedWorkouts').doc(userId).get();

    if (doc.exists) {
      List workoutIDs = doc.data()?['workoutIDs'] ?? [];
      List timestamps = doc.data()?['timestamps'] ?? [];
      List photoURLs = doc.data()?['photoURLs'] ?? [];

      for (int i = 0; i < workoutIDs.length; i++) {
        /* get the workoutID */
        String workoutID = workoutIDs[i];
        String photoURL = photoURLs[i];

        /* get timestamp of workout completion */
        Timestamp timestamp = timestamps[i];

        /* Fetch workout for the workout ID */
        Workout workout = await getWorkoutFromWorkoutID(workoutID);

        /* fetch user data */
        AtlasUser completedUser = await getAtlasUser(userId);

        /* Pair workout with timestamp */
        completedWorkouts.add(CompletedWorkout(
          createdBy: workout.createdBy,
          description: workout.description,
          workoutName: workout.workoutName,
          exercises: workout.exercises,
          completedTime: timestamp,
          completedBy: completedUser,
          photoURL: photoURL,
          workoutID: workoutID,
        ));
      }
    }
    return completedWorkouts;
  }

  /* function that takes in a workout object and a userid and saves the workout to the database */
  Future<void> saveCreatedWorkout(Workout workout) async {
    /* Add the workout to the workouts collection with the specified workoutID */
    DocumentReference workoutRef =
        firestore.collection("workouts").doc(workout.workoutID);
    await workoutRef.set({
      'createdBy': workout.createdBy.uid,
      'workoutID': workout.workoutID,
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
        firestore.collection('workoutsByUser').doc(workout.createdBy.uid);
    var userWorkoutsDoc = await userWorkoutsRef.get();
    if (!userWorkoutsDoc.exists) {
      // If the document doesn't exist, create a new one with the workout ID
      await userWorkoutsRef.set({
        'workoutIDs': [workout.workoutID],
      });
      await firestore.collection('users').doc(workout.createdBy.uid).update({
        'workoutCount': 1,
      });
    } else {
      // If the document exists, get the current workoutIDs list
      List workouts = userWorkoutsDoc.get('workoutIDs');

      // If the document exists, update it with the new workout ID
      await userWorkoutsRef.update({
        'workoutIDs': FieldValue.arrayUnion([workout.workoutID]),
      });
      await firestore.collection('users').doc(workout.createdBy.uid).update({
        'workoutCount': workouts.length + 1,
      });
    }
  }

  Future<void> updateCreatedWorkout(Workout workout) async {
    /* Add the workout to the workouts collection with the specified workoutID */
    DocumentReference workoutRef =
        firestore.collection("workouts").doc(workout.workoutID);
    await workoutRef.set({
      'createdBy': workout.createdBy.uid,
      'workoutID': workout.workoutID,
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
  }

  /* function that takes in a workout object and a userid of the user that finished the workout and saves the workout to the database */
  Future<void> saveCompletedWorkout(
      Workout workout, String completedUserId, XFile? image) async {
    DocumentReference docRef =
        firestore.collection("completedWorkouts").doc(completedUserId);

    // Get the current document
    DocumentSnapshot docSnapshot = await docRef.get();

    String photoURL = '';
    if (image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('postpictures') // specify the folder name
          .child(completedUserId)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(File(image.path));
      photoURL = await ref.getDownloadURL();
    }

    // Check if the document exists
    if (docSnapshot.exists) {
      // Extract the current workoutIDs and timestamps lists
      List<dynamic> workoutIDs = List.from(docSnapshot['workoutIDs'] ?? []);
      List<dynamic> timestamps = List.from(docSnapshot['timestamps'] ?? []);
      List<dynamic> photoURLs = List.from(docSnapshot['photoURLs'] ?? []);

      // Append the new workoutID and timestamp
      workoutIDs.add(workout.workoutID);
      timestamps.add(Timestamp.now());
      photoURLs.add(photoURL);

      // Update the document with the new lists
      await docRef.update({
        'workoutIDs': workoutIDs,
        'timestamps': timestamps,
        "photoURLs": photoURLs,
      });
    } else {
      // If the document doesn't exist, create it with the initial data
      await docRef.set({
        'workoutIDs': [workout.workoutID],
        'timestamps': [Timestamp.now()],
        "photoURLs": [photoURL],
      });
    }
  }

  /* FOLLOWING FUNCTIONS */

  /* Function to get user's followers ids and return them as a list */
  Future<List<String>> getFollowerIDs(String userId) async {
    /* get the followers doc from the user */
    var doc = await firestore.collection('followers').doc(userId).get();
    if (doc.exists) {
      /* get the followers from the document */
      List<dynamic> followersDynamic = doc.data()?['followers'] ?? [];

      /* Explicitly cast each element in the list to String */
      List<String> followers =
          followersDynamic.map((e) => e.toString()).toList();
      return followers;
    }
    return [];
  }

  /* Function to get user's following ids and return them as a list */
  Future<List<String>> getFollowingIDs(String userId) async {
    /* get the following doc from the user */
    var doc = await firestore.collection('following').doc(userId).get();

    if (doc.exists) {
      /* get the following from the document */
      List<dynamic> followingDynamic = doc.data()?['following'] ?? [];

      /* Explicitly cast each element in the list to String */
      List<String> following =
          followingDynamic.map((e) => e.toString()).toList();
      return following;
    }
    return [];
  }

  /* Function to follow other user with current user */
  Future<void> followUser(String userIDCurrUser, String userIDOther) async {
    /* get references to the following and followers collections */
    DocumentReference userFollowingRef =
        firestore.collection('following').doc(userIDCurrUser);
    DocumentReference otherUserFollowersRef =
        firestore.collection('followers').doc(userIDOther);

    /* Transaction for userIDCurrUser's following update */
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot userFollowingSnapshot =
          await transaction.get(userFollowingRef);

      /* if the document exists, update the following list */
      if (userFollowingSnapshot.exists) {
        List following = userFollowingSnapshot.get('following');
        if (!following.contains(userIDOther)) {
          following.add(userIDOther);
          transaction.update(userFollowingRef, {'following': following});
          transaction.update(firestore.collection('users').doc(userIDCurrUser),
              {'followingCount': following.length});
        }
      } else {
        transaction.set(userFollowingRef, {
          'following': [userIDOther],
        });
        transaction.update(firestore.collection('users').doc(userIDCurrUser),
            {'followingCount': 1});
      }
    });

    /* Transaction for userIDOther's followers update */
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot otherUserFollowersSnapshot =
          await transaction.get(otherUserFollowersRef);

      /* if the document exists, update the followers list */
      if (otherUserFollowersSnapshot.exists) {
        List followers = otherUserFollowersSnapshot.get('followers');
        if (!followers.contains(userIDCurrUser)) {
          followers.add(userIDCurrUser);
          transaction.update(otherUserFollowersRef, {'followers': followers});
          transaction.update(firestore.collection('users').doc(userIDOther),
              {'followerCount': followers.length});
        }
      } else {
        transaction.set(otherUserFollowersRef, {
          'followers': [userIDCurrUser],
        });
        transaction.update(firestore.collection('users').doc(userIDOther),
            {'followerCount': 1});
      }
    });
  }

  /* Function to unfollow other user with current user */
  Future<void> unfollowUser(String userIDCurrUser, String userIDOther) async {
    /* get references to the following and followers collections */
    DocumentReference userFollowingRef =
        firestore.collection('following').doc(userIDCurrUser);
    DocumentReference otherUserFollowersRef =
        firestore.collection('followers').doc(userIDOther);

    /* Transaction for removing from userIDCurrUser's following */
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot userFollowingSnapshot =
          await transaction.get(userFollowingRef);

      /* if the document exists, update the following list */
      if (userFollowingSnapshot.exists) {
        List following = userFollowingSnapshot.get('following');
        if (following.contains(userIDOther)) {
          following.remove(userIDOther);
          transaction.update(userFollowingRef, {'following': following});
          transaction.update(firestore.collection('users').doc(userIDCurrUser),
              {'followingCount': following.length});
        }
      }
    });

    /* Transaction for removing from userIDOther's followers */
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot otherUserFollowersSnapshot =
          await transaction.get(otherUserFollowersRef);

      /* if the document exists, update the followers list */
      if (otherUserFollowersSnapshot.exists) {
        List followers = otherUserFollowersSnapshot.get('followers');
        if (followers.contains(userIDCurrUser)) {
          followers.remove(userIDCurrUser);
          transaction.update(otherUserFollowersRef, {'followers': followers});
          transaction.update(firestore.collection('users').doc(userIDOther),
              {'followerCount': followers.length});
        }
      }
    });
  }

  /* Function to check if current user is following other user */
  Future<bool> isFollowing(String userIDCurrUser, String userIDOther) async {
    DocumentSnapshot followingDoc =
        await firestore.collection('following').doc(userIDCurrUser).get();

    /* if the document exists, check if the following list contains the other user's id */
    if (followingDoc.exists) {
      List followingList = followingDoc.get('following');
      return followingList.contains(userIDOther);
    }
    /* if the document does not exist, or the user does not follow the other */
    return false;
  }

  /* SEARCH FUNCTIONS */
  Future<List<AtlasUser>> searchUsers(String query) async {
    var querySnapshot = await firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThan: '${query}z')
        .get();
    List<AtlasUser> users = querySnapshot.docs.map((doc) {
      return AtlasUser(
          uid: doc.id,
          email: doc.data()['email'],
          firstName: doc.data()['firstName'],
          lastName: doc.data()['lastName'],
          username: doc.data()['username'],
          followerCount: doc.data()['followerCount'],
          followingCount: doc.data()['followingCount'],
          workoutCount: doc.data()['workoutCount']);
    }).toList();
    return users;
  }

  Future<bool> deleteWorkout(String workoutId, String userId) async {
    try {
      // Delete the workout document from the "createdWorkouts" collection
      DocumentReference userDocRef =
          firestore.collection('workoutsByUser').doc(userId);
      var userWorkoutsDoc = await userDocRef.get();
      List workouts = userWorkoutsDoc.get('workoutIDs');

      // Remove the workoutId from the array field in the document
      await userDocRef.update({
        "workoutIDs": FieldValue.arrayRemove([workoutId])
      });

      //Update User Object
      await firestore.collection('users').doc(userId).update({
        'workoutCount': workouts.length - 1,
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  /* FIREBASE STORAGE FUNCTIONS */

  /* Function to fetch profile picture */
  Future<String> getProfilePicture(String userid) async {
    try {
      /* Attempt to get the user's profile picture URL document from Firestore */
      DocumentSnapshot snapshot =
          await firestore.collection('profilePictureURLs').doc(userid).get();

      String fileUrl;
      if (snapshot.exists && snapshot.data() is Map) {
        final data = snapshot.data() as Map<String, dynamic>;
        /* If the document exists and has a URL, use it */
        fileUrl = data['url'];
      } else {
        /* If the document does not exist, use the default profile picture URL */
        fileUrl = 'defaultpfp.jpeg';
      }

      /* Get the download URL for the profile picture from Firebase Storage */
      String imageUrl =
          await _storage.ref('profilepictures/$fileUrl').getDownloadURL();
      return imageUrl;
    } catch (e) {
      /* In case of any errors, log them and return the default profile picture URL */
      return await _storage
          .ref('profilepictures/defaultpfp.jpeg')
          .getDownloadURL();
    }
  }

  Future<String> fetchProfilePicture(String userId) async {
    // Assuming you have a method in your database service to get the profile picture URL
    final url = await getProfilePicture(userId);
    return url;
  }

  Future<void> pickAndUploadImage(String userId, String storageBucket) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      //setState(() {
      // _image = image;
      //});
      await uploadImage(userId, image, storageBucket);
      //   await _fetchProfilePicture(); // Refresh profile picture after uploading
    }
  }

  Future<void> uploadImage(
      String userId, File image, String storageBucket) async {
    String fileExtension = path.extension(image.path);
    String fileName = "$userId$fileExtension";
    Reference storageRef =
        FirebaseStorage.instance.ref('$storageBucket/$fileName');
    await storageRef.putFile(image);
    // Update Firestore with the new file name
    await FirebaseFirestore.instance
        .collection('profilePictureURLs')
        .doc(userId)
        .set({
      'url': fileName,
    });
  }
}
