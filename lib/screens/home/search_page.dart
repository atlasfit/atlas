import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Search Page
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool showSuggestions = false;

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    // query users
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    setState(() {
      users = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = users
          .where((user) => user['username']
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
      showSuggestions = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find Friends, Workouts, and Groups',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),

      // contains search bar and filtered user list
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                filterUsers(value);
              },
              onTap: () {
                setState(() {
                  showSuggestions = false;
                });
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...',
              ),
            ),
          ),
          if (showSuggestions)
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredUsers[index]['username']),
                    // Add functionality for when you tap on a result
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
