import 'package:flutter/material.dart';
import 'package:atlas/services/auth.dart';

/* A screen widget for user sign-in. */
class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

/* The state class for the SignIn widget. */
class _SignInState extends State<SignIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  String _errorMessage = '';

  /* Signs in the user with the provided email and password. */
  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      var result = await _auth.signInWithEmailAndPassword(email, password);
      if (result != null) {
        /* if the user is successfully signed in, the atlasuser provider stream will be updated and user will be redirected to home page */
      } else {
        setState(() {
          _errorMessage =
              'User or Password not recognized'; // Update the error message
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Sign in failed. '; // Update the error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ATLAS'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Username or Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            if (_errorMessage
                .isNotEmpty) // if there is an error with the sign in, display the error message
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _signIn, // when pressed sign in the user with the givne email and password
              child: const Text('Sign In'),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Divider(),
            ),
            TextButton(
              onPressed: () {
                widget.toggleView(); // when pressed switch to register view
              },
              child: RichText(
                text: const TextSpan(
                  text: 'New to Atlas? ',
                  style: TextStyle(color: Colors.white),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Register Now',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
