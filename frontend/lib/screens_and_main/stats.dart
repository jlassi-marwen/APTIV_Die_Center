import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tool Management Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tool Management Dashboard'),
        ),
        backgroundColor: Colors.white, // Set background color to white
        body: ToolDashboard(),
      ),
    );
  }
}

class ToolDashboard extends StatefulWidget {
  @override
  _ToolDashboardState createState() => _ToolDashboardState();
}

class _ToolDashboardState extends State<ToolDashboard> {
  int totalTools = 0;
  int unusedTools=0;
  int assignedTools = 0; // New variable for assigned tools
  
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await ApiService.fetchToolCount();
      setState(() {
        totalTools = data['totalTools'];
        unusedTools= data['unusedTools'];
        assignedTools = data['assignedTools']; // Update assigned tools count
         //unusedTools = totalTools - assignedTools;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    
  return isLoading
      ? Center(child: CircularProgressIndicator())
      : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tool Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Tools',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                totalTools.toString(),
                                style: TextStyle(
                                  fontSize: 22,
                                 color: Color.fromARGB(255, 241, 74, 8),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 50,
                            width: 3,
                            color: Colors.grey[300], // Add a separating line
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assigned Tools',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                assignedTools.toString(),
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Color.fromARGB(255, 32, 32, 32),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: DoughnutChart(
                            //totalTools: totalTools,
                            unusedTools: unusedTools,
                            assignedTools: assignedTools,
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Indicator(
                              color: Color.fromARGB(255, 241, 74, 8),
                              text: 'Available Tools',
                              isSquare: true,
                            ),
                            SizedBox(height: 8),
                            Indicator(
                              color: Color.fromARGB(255, 32, 32, 32),
                              text: 'Assigned Tools',
                              isSquare: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
}

}

class DoughnutChart extends StatelessWidget {
  final int unusedTools;
  final int assignedTools;

  DoughnutChart({required this.unusedTools, required this.assignedTools});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: unusedTools.toDouble(),
            color: Color.fromARGB(255, 241, 74, 8),
            //title: '$totalTools\nTotal Tools',
            radius: 40,
            titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: assignedTools.toDouble(),
            color: Color.fromARGB(255, 32, 32, 32),
            //title: '$assignedTools\nAssigned Tools',
            radius: 40,
            titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
        sectionsSpace: 0,
        centerSpaceRadius: 40,
       
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    this.isSquare = true,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}

/*class ApiService {
  static const String baseUrl = 'http://localhost:2000/api';

  static Future<Map<String, dynamic>> fetchToolCount() async {
    final response = await http.get(Uri.parse('$baseUrl/stats/tool-usage'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load tool count');
    }
  }
}*/
class ApiService {
  static const String baseUrl = 'http://localhost:2000/api';

  static Future<Map<String, dynamic>> fetchToolCount() async {
    final response = await http.get(Uri.parse('$baseUrl/stats'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load tool count');
    }
  }
}