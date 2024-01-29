import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Bottom Navigation Bar Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const Icon(Icons.home),
    const Icon(Icons.search),
    const Icon(Icons.camera),
    const Icon(Icons.person)
  ];

  void onTabTapped(int index) { // on click of icon, update index to what is selected
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ATLAS', style: TextStyle(
            fontFamily: 'Consolas', // Change to your desired font family
            fontSize: 20.0, // Change to your desired font size
            fontWeight: FontWeight.bold, // Change to your desired font weight
          )),
        centerTitle: true
      ),
      body: Center(
        child: _children[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(

        onTap: onTabTapped, // on icon click call click method
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent, // Change the selected label color
        unselectedItemColor: Colors.black12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile'
          )
        ],
      ),
    );
  }
}
