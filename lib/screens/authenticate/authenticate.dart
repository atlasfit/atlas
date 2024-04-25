import 'package:flutter/material.dart';
import 'package:atlas/screens/authenticate/register.dart';
import 'package:atlas/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  /* Function to toggle between sign in and register views */
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

    //don't know where to put this method.
    /* Registers a new user with the provided email and password. */
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print('Error registering user: $e');
      return null;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true; // Password reset email sent successfully
    } catch (e) {
      print('Error sending password reset email: $e');
      return false; // Failed to send password reset email
    }
  }

  @override
  Widget build(BuildContext context) {
    /* Display sign in view if showSignIn is true, otherwise display register view */
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
