import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tools List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Tools(),
    );
  }
}

class Tools extends StatefulWidget {
  @override
  _ToolsListPageState createState() => _ToolsListPageState();
}

class _ToolsListPageState extends State<Tools> {
  StreamController<List<dynamic>> _streamController = StreamController();
  TextEditingController NScontroller = TextEditingController();
  TextEditingController refcontroller = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List<dynamic> tools = [];
  List<dynamic> filteredTools = [];
  String scannedBarcode = '';

  @override
  void initState() {
    super.initState();
    fetchTools();
  }

  void fetchTools() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:2000/api/tools'));
      if (response.statusCode == 200) {
        tools = json.decode(response.body)['tools'];
        setState(() {
          filteredTools = List.from(tools);
        });
        _streamController.add(filteredTools);
      } else {
        throw Exception('Failed to load tools');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void runFilter(String query) {
    List<dynamic> filteredList = [];
    if (query.isNotEmpty) {
      filteredList = tools.where((tool) {
        return (tool['NS']?.toString()?.toLowerCase()?.contains(query.toLowerCase()) ?? false);
      }).toList();
    } else {
      filteredList = List.from(tools);
    }
    setState(() {
      filteredTools = filteredList;
      _streamController.add(filteredTools);
    });
  }

  Future<void> postDataToDatabase(String ns, String ref) async {
    if (ns.isEmpty || ref.isEmpty) {
      print('Error: NS and ref cannot be empty');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:2000/api/tools'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'NS': ns, 'ref': ref}),
      );

      if (response.statusCode == 200) {
        print('Data posted successfully');
        fetchTools();
      } else if (response.statusCode == 409) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('NS or ref already exists.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print('Failed to post data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: "Search for a tool",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          runFilter(searchController.text);
                        },
                      ),
                    ),
                    onChanged: (value) => runFilter(value),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.barcode_reader),
                  onPressed: () async {
                    var res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SimpleBarcodeScannerPage(),
                      ),
                    );
                    setState(() {
                      if (res is String) {
                        scannedBarcode = res;
                        searchController.text = scannedBarcode;
                        runFilter(scannedBarcode);
                      }
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<List<dynamic>>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No tools found'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTile(
                            leading: Icon(Icons.settings, color: Colors.grey),
                            title: Text(
                              snapshot.data![index]['NS'] ?? 'No NS',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('Ref: ${snapshot.data![index]['ref'] ?? 'No Ref'}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deletetool(snapshot.data![index]['_id']);
                              },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddToolDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _deletetool(String toolId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:2000/api/tools/$toolId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        fetchTools();
      } else {
        throw Exception('Failed to delete tool');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _showAddToolDialog() {
    String ns = '';
    String ref = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Tool'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: NScontroller,
              decoration: InputDecoration(labelText: 'NS'),
              onChanged: (value) => ns = value,
            ),
            TextField(
              controller: refcontroller,
              decoration: InputDecoration(labelText: 'Ref'),
              onChanged: (value) => ref = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              var res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SimpleBarcodeScannerPage(),
                ),
              );
              setState(() {
                if (res is String) {
                  scannedBarcode = res;
                  NScontroller.text = '$ns $scannedBarcode';
                }
              });
            },
            child: Text('Scan'),
          ),
          TextButton(
            onPressed: () {
              postDataToDatabase(NScontroller.text, refcontroller.text);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
