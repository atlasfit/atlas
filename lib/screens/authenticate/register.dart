import 'package:flutter/material.dart';
import 'package:atlas/services/auth.dart';
import 'package:atlas/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String _error = '';
  String _email = '';
  String _password = '';
  String _username = ''; // Add this line
  String _fullName = ''; // Add this line

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text('ATLAS'),
              centerTitle: true,
            ),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Create Account',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        cursorColor: Colors.blue,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.mail),
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) => setState(() => _email = val),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        cursorColor: Colors.blue,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter a username' : null,
                        onChanged: (val) => setState(() => _username = val),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        cursorColor: Colors.blue,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter your full name' : null,
                        onChanged: (val) => setState(() => _fullName = val),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        cursorColor: Colors.blue,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (val) => val!.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                        onChanged: (val) => setState(() => _password = val),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _loading = true);
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    _email, _password, _username, _fullName);
                            if (result == null) {
                              setState(() {
                                _error = 'Please supply a valid email';
                                _loading = false;
                              });
                            }
                          }
                        },
                        child: const Text('Register'),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        _error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 1.0),
                        child: Divider(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: 'Have an account? ',
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Sign in',
                                  style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
