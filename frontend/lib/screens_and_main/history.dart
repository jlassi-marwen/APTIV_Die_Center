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
      title: 'Assignment History',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: History(),
    );
  }
}

class History extends StatefulWidget {
  @override
  _HistoryListPageState createState() => _HistoryListPageState();
}

class _HistoryListPageState extends State<History> {
  Stream<List<dynamic>> _stream = Stream.empty();
  TextEditingController searchController = TextEditingController();
  List<dynamic> history = [];
  List<dynamic> filteredHistory = [];
  String scannedBarcode = '';

  @override
  void initState() {
    super.initState();
    _stream = getHistory();
    searchController.addListener(() {
      filterHistory(searchController.text);
    });
  }
Future<void> deleteAllHistory() async {
  try {
    final response = await http.delete(Uri.parse('http://localhost:2000/api/assignment/clear'));
    if (response.statusCode == 200) {
      setState(() {
        history = [];
        filteredHistory = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('History cleared successfully'),
      ));
    } else {
      throw Exception('Failed to clear history');
    }
  } catch (error) {
    print('Error: $error');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error clearing history: $error'),
    ));
  }
}

  Stream<List<dynamic>> getHistory() async* {
    while (true) {
      try {
        final response = await http.get(Uri.parse('http://localhost:2000/api/assignment'));
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          List<dynamic> assignmentHistory = data;
          yield assignmentHistory;
          setState(() {
            history = assignmentHistory;
            filterHistory(searchController.text); // Update filter when data is fetched
          });
        } else {
          throw Exception('Failed to load assignment history');
        }
      } catch (error) {
        print('Error: $error');
      }
      await Future.delayed(Duration(seconds: 2));
    }
  }

  void filterHistory(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        filteredHistory = history;
      } else {
        filteredHistory = history.where((item) {
          final machineName = item['machine']?['name']?.toLowerCase() ?? '';
          final toolNS = item['tool']?['NS']?.toLowerCase() ?? '';
          return machineName.contains(searchTerm.toLowerCase()) || toolNS.contains(searchTerm.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Assignment History'),
        centerTitle: true,
        actions: [
          // Add two buttons here
          ElevatedButton(
            onPressed: () {
              // Handle download CSV functionality
              // Implement logic to download assignment history as CSV
              // Consider using a package like flutter_csv
              // Convert data to CSV format
  List<List<dynamic>> csvData = [
    ['Machine Name', 'Tool NS', 'Date']
  ];
  for (var item in history) {
    csvData.add([
      item['machine']['name'],
      item['tool']['NS'],
      DateTime.parse(item['createdAt']).toString(),
    ]);
  }
  // Generate CSV content
  String csvContent = csv.ListToCsvConverter().convert(csvData);
  
  // Prompt user to download
  final blob = Blob([csvContent]);
  final url = Url.createObjectUrlFromBlob(blob);
  final anchor = AnchorElement(href: url)
    ..setAttribute("download", "assignment_history.csv")
    ..click();
            },
child: Row(
    children: [
      Icon(Icons.download,color: Colors.white,),
      SizedBox(width: 5), // Add some horizontal spacing
      Text('Download csv',style: TextStyle(color: Colors.white)),
    ],
  ),            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min, // Reduce spacing between icons
            children: [
              SizedBox(width: 5), // Add some horizontal spacing
              ElevatedButton(
                onPressed: () {
                  // Handle settings button press
                   deleteAllHistory();
                },
child: Row(
    children: [
      Icon(Icons.delete,color:Colors.white),
      SizedBox(width: 5), // Add some horizontal spacing
      Text('Clear History',style: TextStyle(color: Colors.white)),
    ],
  ),                style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
                  padding: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                ),
                
              ),
            ],
          ),

            ]
          ),*/
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
                      labelText: 'Search History',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          filterHistory(searchController.text);
                        },
                      ),
                    ),
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
                        filterHistory(scannedBarcode);
                      }
                    });
                  },
                ),
              ],
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
                    List<dynamic> dataToShow = searchController.text.isEmpty ? history : filteredHistory;
                    dataToShow = List.from(dataToShow.reversed);
                    return ListView.builder(
                      itemCount: dataToShow.length,
                      itemBuilder: (context, index) {
                        var item = dataToShow[index];
                        if (item['machine'] == null || item['tool'] == null) {
                          return SizedBox.shrink(); // Skip this item if it's null
                        }
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTile(
                            title: Text(item['machine']['name'] ?? 'Unknown Machine'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tool NS: ${item['tool']['NS'] ?? 'Unknown Tool'}'),
                                Text('Date: ${item['createdAt'] != null ? DateTime.parse(item['createdAt']).toString() : 'Unknown Date'}'),
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
}
