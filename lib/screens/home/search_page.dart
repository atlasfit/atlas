import 'package:atlas/models/user.dart';
import 'package:flutter/material.dart';
import 'package:atlas/screens/home/profile_page/profile_wrapper.dart';
import 'package:atlas/services/database.dart';

// Search Page
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<AtlasUser> users = [];
  List<AtlasUser> filteredUsers = [];
  bool showSuggestions = false;

  @override
  void initState() {
    super.initState();
    DatabaseService().getUsers().then((value) {
      setState(() {
        users = value;
        filteredUsers = value;
      });
    });
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = users
          .where((user) =>
              user.username.toLowerCase().contains(query.toLowerCase()))
          .toList();
      showSuggestions = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
                      title: Text(filteredUsers[index].username),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileWrapper(
                                userID: filteredUsers[index]
                                    .uid), //NEED TO FIX THIS!!
                          ),
                        );
                      });
                },
              ),
            ),
        ],
      ),
    );
  }
}
