import 'package:flutter/material.dart';

class ActivityDashboard extends StatefulWidget {
  const ActivityDashboard({super.key});

  @override
  State<ActivityDashboard> createState() => _ActivityDashboardState();
}

class _ActivityDashboardState extends State<ActivityDashboard> {
  @override
  Widget build(BuildContext context) {
    //Add a button to sign out of firebase
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Dashboard'),
        actions: const <Widget>[],
      ),
    );
  }
}
