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
      title: 'Repairs Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Repairs(),
    );
  }
}

class Repairs extends StatefulWidget {
  @override
  _RepairsListPageState createState() => _RepairsListPageState();
}

class _RepairsListPageState extends State<Repairs> {
  Stream<List<dynamic>> _stream = Stream.empty();
  TextEditingController searchController = TextEditingController();
  List<dynamic> Repairs = [];
  List<dynamic> filteredRepairs = [];

  @override
  void initState() {
    super.initState();
    _stream = getRepairs();
  }

  Stream<List<dynamic>> getRepairs() async* {
    while (true) {
      try {
        final response = await http.get(Uri.parse('http://localhost:2000/api/repair'));
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body)['repairs'];
          yield data;
          Repairs = data;
        } else {
          throw Exception('Failed to load Repairs');
        }
      } catch (error) {
        print('Error: $error');
      }
      await Future.delayed(Duration(seconds: 2));
    }
  }

  void filterRepairs(String searchTerm) {
    filteredRepairs.clear();
    if (searchTerm.isEmpty) {
      filteredRepairs = List.from(Repairs);
    } else {
      for (var item in Repairs) {
        if (item['Machine_name'].toString().toLowerCase().contains(searchTerm.toLowerCase())) {
          filteredRepairs.add(item);
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
        title: Text('Repairs Management'),
        centerTitle: true,
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRepairDialog();
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
                  labelText: 'Search Repairs',
                  icon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  filterRepairs(value);
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
                    List<dynamic> dataToShow = filteredRepairs.isEmpty ? Repairs : filteredRepairs;
                    return ListView.builder(
  itemCount: dataToShow.length,
  itemBuilder: (context, index) {
    var item = dataToShow[index];

    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Icon(Icons.build), // Replace with repair icon
        title: Text(item['Machine_name'] as String),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item['description'] as String),
            Text('Date: ${DateTime.parse(item['createdAt'].toString())}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                _showEditRepairDialog(item['_id'], item['Machine_name'], item['description']);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _deleteRepair(item['_id']);
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

  void _showAddRepairDialog() {
    String machineName = '';
    String description = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Repair'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Machine name'),
              onChanged: (value) => machineName = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
              onChanged: (value) => description = value,
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
              _addRepair(machineName, description);
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _addRepair(String machineName, String description) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:2000/api/repair'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Machine_name': machineName,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        // Refresh repair list
        setState(() {
          _stream = getRepairs();
        });
      } else {
        throw Exception('Failed to add repair');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

void _updateRepair(String repairId, String Machine_name, String description) async {
  try {
    final response = await http.put(
      Uri.parse('http://localhost:2000/api/repair/$repairId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Machine_name': Machine_name,
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      // Refresh repair list
      setState(() {
        _stream = getRepairs();
      });
    } else {
      throw Exception('Failed to update repair');
    }
  } catch (error) {
    print('Error: $error');
  }
}

void _deleteRepair(String repairId) async {
  try {
    final response = await http.delete(
      Uri.parse('http://localhost:2000/api/repair/$repairId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Refresh repair list
      setState(() {
        _stream = getRepairs();
      });
    } else {
      throw Exception('Failed to delete repair');
    }
  } catch (error) {
    print('Error: $error');
  }
}

void _showEditRepairDialog(String repairId, String currentMachineName, String currentDescription) {
  String newMachineName = currentMachineName;
  String newDescription = currentDescription;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Edit Repair'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'New Machine Name'),
            onChanged: (value) => newMachineName = value,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'New Description'),
            onChanged: (value) => newDescription = value,
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
            _updateRepair(repairId, newMachineName, newDescription);
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Save'),
        ),
      ],
    ),
  );
}
}