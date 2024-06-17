import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Users Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Users(),
    );
  }
}

class Users extends StatefulWidget {
  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<Users> {
  Stream<List<dynamic>> _stream = Stream.empty();
  TextEditingController searchController = TextEditingController();
  List<dynamic> users = [];
  List<dynamic> filteredUsers = [];
  String loggedInUsername = 'admin';

  @override
  void initState() {
    super.initState();
    _stream = getUsers();
    loggedInUsername = 'admin';
  }

  Stream<List<dynamic>> getUsers() async* {
    while (true) {
      try {
        final response = await http.get(Uri.parse('http://localhost:2000/api/users'));
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body)['users']; // Extract 'users' from the response
          List<dynamic> assignmentUsers = data;
          yield assignmentUsers;
          users = assignmentUsers;
        } else {
          throw Exception('Failed to load users');
        }
      } catch (error) {
        print('Error: $error');
      }
      await Future.delayed(Duration(seconds: 2));
    }
  }

  void filterUsers(String searchTerm) {
    filteredUsers.clear();
    if (searchTerm.isEmpty) {
      filteredUsers = List.from(users);
    } else {
      for (var item in users) {
        if (item['username'].toString().toLowerCase().contains(searchTerm.toLowerCase())) {
          filteredUsers.add(item);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        title: Text('Users Management'),
        centerTitle: true,
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserDialog();
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0), // Reduce padding around search bar
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search Users',
                  icon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  filterUsers(value);
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<List<dynamic>>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<dynamic> dataToShow = filteredUsers.isEmpty ? users : filteredUsers;
                    return ListView.builder(
                      itemCount: dataToShow.length,
                      itemBuilder: (context, index) {
                        var item = dataToShow[index];
                        bool isCurrentUserAdmin = item['username'] == loggedInUsername;

                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTile(
                            leading: Icon(Icons.supervised_user_circle),
                            title: Text(item['username'] as String),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               // Text('Date: ${DateTime.parse(item['password'].toString())}'),
                               Text(item['password'] as String),
                              ],
                            ),
                            trailing: isCurrentUserAdmin
                                ? null
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () {
                                          _showEditUserDialog(item['_id'], item['username']);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          _deleteUser(item['_id']);
                                        },
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddUserDialog() {
    String username = '';
    String password = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Username'),
              onChanged: (value) => username = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              onChanged: (value) => password = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _addUser(username, password);
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _addUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:2000/api/users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Refresh user list
        setState(() {
          _stream = getUsers();
        });
      } else {
        throw Exception('Failed to add user');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _updateUser(String userId, String username, String password) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:2000/api/users/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Refresh user list
        setState(() {
          _stream = getUsers();
        });
      } else {
        throw Exception('Failed to update user');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _deleteUser(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:2000/api/users/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Refresh user list
        setState(() {
          _stream = getUsers();
        });
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _showEditUserDialog(String userId, String currentUsername) {
    String newUsername = currentUsername;
    String newPassword = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'New Username'),
              onChanged: (value) => newUsername = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'New Password'),
              onChanged: (value) => newPassword = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _updateUser(userId, newUsername, newPassword);
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
