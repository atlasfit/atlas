import 'package:atlas/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:atlas/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /* function to create and return our own atlasuser obj based on firebase user */
  Future<AtlasUser?> _userFromFirebaseUser(User? user) async {
    if (user == null) {
      return null;
    }

    /* return atlasuser object from database using the firebase user instance uid */
    return DatabaseService().getAtlasUser(user.uid);
  }

  /* auth change user stream */
  Stream<AtlasUser?> get atlasUser {
    return _auth.authStateChanges().asyncMap((User? user) async {
      return await _userFromFirebaseUser(user);
    });
  }

  /* function to sign in with email and password, if successful returns atlasuser object */
  Future signInWithEmailAndPassword(String input, String password) async {
    String email = input;

    try {
      /* Check if the input is a username (doesn't contain "@") */
      if (!input.contains('@')) {
        /* if not an email, check if the input is a username that exists already */
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: input)
            .limit(1)
            .get();

        /* If a user with that username is found, use the email associated with that user to login */
        if (querySnapshot.docs.isNotEmpty) {
          email = querySnapshot.docs.first.data()['email'];
        } else {
          /* No user found with the given username */
          return null;
        }
      }

      /* Authenticate with the resolved email and the provided password */
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return await _userFromFirebaseUser(user);
    } catch (error) {
      return null;
    }
  }

  /* function to register with email and password */
  Future registerWithEmailAndPassword(
      String email, String password, String username, String fullName) async {
    try {
      /* Check for existing user with the same email */
      final existingEmail = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      /* if there is already an account with that email, return an error message */
      if (existingEmail.docs.isNotEmpty) {
        return null;
      }

      /* Check for existing user with the same username */
      final existingUsername = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      /* if there is already an account with that username, return an error message */
      if (existingUsername.docs.isNotEmpty) {
        return null;
      }

      /* Proceed with creating a new user if email and username are unique */
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        /* Split fullName into firstName and lastName assuming the fullName is in the format "FirstName LastName" */
        List<String> names = fullName.split(' ');
        String firstName = names[0];
        String lastName = names.length > 1
            ? names.sublist(1).join(' ')
            : ''; // Handle cases where there may not be a last name

        /* Add the user to the database */
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'username': username,
          'firstName': firstName,
          'lastName': lastName,
        });
      }

      /* return the atlasuser object of the just registered user */
      return await _userFromFirebaseUser(user);
    } catch (error) {
      return null;
    }
  }

  /* function to sign out */
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      return null;
    }
  }
}
