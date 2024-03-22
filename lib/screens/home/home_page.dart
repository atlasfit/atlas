import 'package:atlas/models/user.dart';
import 'package:atlas/screens/home/activity_dashboard.dart';
import 'package:atlas/screens/home/profile_page/profile_view.dart';
import 'package:atlas/screens/home/search_page.dart';
import 'package:atlas/screens/home/workout_page/workout_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /* create a variable to store the current index of the bottom navigation bar to display proper page corresponding to icon pressed */
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    /* get the current user */
    final atlasUser = Provider.of<AtlasUser?>(context);
    final userID = atlasUser?.uid ?? '';

    /* create a list of widgets to display on the home page */
    final List<Widget> children = [
      const ActivityDashboard(),
      const SearchPage(),
      const WorkoutPage(),
      ProfileView(userID: userID),
    ];

    /* return the scaffold with the bottom navigation bar */
    return Scaffold(
      body: Center(child: children[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 22, 22, 22),
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}
