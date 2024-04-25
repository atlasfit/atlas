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
  //method for show forgot Password
  void _showForgotPasswordDialog() {
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password'),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Enter your email',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                if (email.isNotEmpty) {
                  // Call AuthService method to send password reset email
                  bool result = await _auth.sendPasswordResetEmail(email);
                  if (result) {
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Password reset email sent successfully!'),
                      ),
                    );
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Failed to send password reset email.'),
                      ),
                    );
                  }
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: Text('Reset Password'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            alignment: Alignment(0, 0.5),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'ATLAS',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Username or Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
                filled: true,
                fillColor: Color.fromRGBO(255, 255, 255, 0.1),
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
                filled: true,
                fillColor: Color.fromRGBO(255, 255, 255, 0.1),
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
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.9, // Set width to 75% of the screen width
                child: ElevatedButton(
                  onPressed:
                      _signIn, // when pressed sign in the user with the given email and password
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontWeight: FontWeight.w900,
                    ),
                    backgroundColor:
                        const Color.fromRGBO(33, 150, 243, 0.3), //Colors.white
                    //  .withOpacity(0.1), // Slightly transparent background

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(5.0), // Rounded corners
                      // White border
                    ),
                  ),
                  child: const Text('Sign In'),
                ),
              ),
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
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _showForgotPasswordDialog(); // Show forgot password dialog
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
