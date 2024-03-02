import 'package:firebase_auth/firebase_auth.dart';
import 'package:atlas/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  Future<AtlasUser?> _userFromFirebaseUser(User? user) async {
    if (user == null) {
      return null;
    }

    // Fetch user details from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      return AtlasUser(
        uid: user.uid,
        email: data['email'] ?? '',
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        username: data['username'] ?? '',
      );
    } else {
      // Handle the case where the user document does not exist (should not happen normally)
      return null;
    }
  }

  // auth change user stream
  Stream<AtlasUser?> get atlasUser {
    return _auth.authStateChanges().asyncMap((User? user) async {
      return await _userFromFirebaseUser(user);
    });
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String input, String password) async {
    String email = input;

    try {
      // Check if the input is a username (doesn't contain "@")
      if (!input.contains('@')) {
        // Query your database to find the user document with the matching username
        // This example assumes you have a 'users' collection and each document has a 'username' field
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: input)
            .limit(1)
            .get();

        // If a user is found, use the email associated with that user
        if (querySnapshot.docs.isNotEmpty) {
          email = querySnapshot.docs.first.data()['email'];
        } else {
          // No user found with the given username
          return 'User not found';
        }
      }

      // Authenticate with the resolved email and the provided password
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return await _userFromFirebaseUser(user);
    } catch (error) {
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String username, String fullName) async {
    try {
      // Check for existing user with the same email
      final existingEmail = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (existingEmail.docs.isNotEmpty) {
        return 'Email already in use';
      }

      // Check for existing user with the same username
      final existingUsername = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (existingUsername.docs.isNotEmpty) {
        return 'Username already taken';
      }

      // Proceed with creating a new user if email and username are unique
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Split fullName into firstName and lastName assuming the fullName is in the format "FirstName LastName"
        List<String> names = fullName.split(' ');
        String firstName = names[0];
        String lastName = names.length > 1
            ? names.sublist(1).join(' ')
            : ''; // Handle cases where there may not be a last name

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'username': username,
          'firstName': firstName,
          'lastName': lastName,
          'followers': [],
          'following': [],
        });
      }

      return await _userFromFirebaseUser(user);
    } catch (error) {
      return null;
    }
  }

// Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      return null;
    }
  }
}
