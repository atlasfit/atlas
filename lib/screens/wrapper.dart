import 'package:flutter/material.dart';
import 'package:atlas/screens/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:atlas/screens/authenticate/authenticate.dart';
import 'package:atlas/models/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    /* Refers to firebase user */
    final atlasUser = Provider.of<AtlasUser?>(context);

    /* return either the Home or Authenticate widget based on if there is a logged in user */
    if (atlasUser == null) {
      return const Authenticate();
    } else {
      return const MyHomePage();
    }
  }
}
