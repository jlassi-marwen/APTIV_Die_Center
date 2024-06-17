import 'package:flutter/material.dart';
import 'package:frontend/login.dart';
import 'package:frontend/screens_and_main/tools.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:provider/provider.dart';

import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
// jareb fazet datetime.now fl assigntool 
class Tool {
  final String NS;
  final DateTime assignedat;

  Tool(this.NS, {required this.assignedat}) ;
}

  TextEditingController namecontroller= TextEditingController();

class MachineProvider extends ChangeNotifier {
 //List<Machine>machines=[];
 List<dynamic>machines=[];
Future<void> fetchMachines() async{
  
  notifyListeners();
  }
 
Future<void>assignTool (String ns,String selectedMachineName)async{
  List<Machine> machines = [];
    if (ns.isEmpty ) {
    print('Error: NS  cannot be empty');
    return;
  } else {
    if( selectedMachineName.isEmpty){
          print('Error: machinename  cannot be empty');
return;
    }
  }
  try {
    final response = await http.post(
      Uri.parse('http://localhost:2000/api/machines/a'),
      headers: {'Content-Type': 'application/json'}, // Set the content-type header
      body: jsonEncode({'tools': ns, 'name': selectedMachineName}), // Encode the data as JSON
   );

    if (response.statusCode == 200) {
      print('tool assigned successfully');
     
  final assignedMachine = machines.firstWhere((m) => m.name == selectedMachineName);
  //assignedMachine.tools.forEach((tool) => tool.assignedat = DateTime.now());
      //assignedMachine.tools.add(Tool.now(ns));
       
        notifyListeners();

    
      
    //subtitle: Text(DateTime.now().toString()), // Display current assignedat
      //var assignmenttime=DateTime;
       

    } else if (response.statusCode == 409) {
      print('error');
    } else {
      print('Failed to post data: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
  }
  
  notifyListeners();
  }  
//Future<void>deletetool()async{notifyListeners();}

}
class Machine  {
  /*final*/ String name;
  final List<Tool> tools;
  Machine(this.name, this.tools);
   
  
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MachineProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Dashboard(),
      ),
    );
  }
}



class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String scannedBarcode = '';
  late Stream<List<Machine>> _stream;
   // late Timer timer;
    //Machine? selectedMachineName;
  String? selectedMachineName;
  List<Machine> machines = [];
  final StreamController<List<Machine>> _machinesStreamController =
      StreamController<List<Machine>>();

  Stream<List<Machine>> get machinesStream => _machinesStreamController.stream;

   TextEditingController NSController = TextEditingController();
   //DropdownButtonController<Machine> MachineController=DropdownButtonController<Machine>();
   TextEditingController nameController=TextEditingController() ;
     TextEditingController searchController = TextEditingController(); // Step 1: Add search controller

  @override
  void initState() {
    super.initState();
    _stream = fetchMachines();
    nameController=TextEditingController();
  
  }
  void refreshMachines() {
    _stream = fetchMachines();
  }
  
   String ns = '';
   String name='';
  @override
Widget build(BuildContext context) {
  return Scaffold(
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        _showAddMachineDialog(context);
      },
      child: Icon(Icons.add),
    ),
    appBar: AppBar(
      title: Text('Machine List'),
      actions: <Widget>[
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
                NSController.text = scannedBarcode;
              } else {
                print('Error during barcode scanning');
              }
            });
          },
        ),
      ],
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: NSController,
                  onChanged: (value) => ns = value,
                  decoration: InputDecoration(
                    hintText: 'Scan or type NS',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 250, 77, 9)),
                    ),
                    prefixIcon: Icon(Icons.barcode_reader),
                  ),
                ),
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedMachineName,
                  hint: Text('Machine'),
                  items: machines.map<DropdownMenuItem<String>>((Machine machine) {
                    return DropdownMenuItem<String>(
                      value: machine.name,
                      child: Text(machine.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedMachineName = val;
                    });
                  },
                ),
              ),
              SizedBox(width: 8.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 250, 77, 9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  await assigntool(NSController.text, selectedMachineName!, context);
                  await adhistory(selectedMachineName!, NSController.text);
                },
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 600 ? 16 : 4;
              return StreamBuilder<List<Machine>>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final machines = snapshot.data ?? [];
                    return GridView.builder(
                      itemCount: machines.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemBuilder: (context, index) {
                        final machine = machines[index];
                        return machineCard(context, machine, machines);
                      },
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}

FormField<String> buildDropdown() {
  return DropdownButtonFormField<String>(
    value: selectedMachineName,
    decoration: InputDecoration(
      hintText: 'Select a machine',
      labelText: 'Machine',
    ),
    items: machines.map((Machine machine) {
      return DropdownMenuItem<String>(
        value: machine.name,
        child: Text(machine.name),
      );
    }).toList(),
    onChanged: (val) {
      setState(() {
        selectedMachineName = val;
      });
    },
    onSaved: (val) {
      setState(() {
        selectedMachineName = val;
      });
    },
    validator: (val) {
      if (val == null || val.isEmpty) {
        return 'Please select a machine';
      }
      return null;
    },
  );
}
  @override
  void dispose() {
    _machinesStreamController.close();
   // searchController.removeListener(_onSearchChanged); // Step 1: Remove listener to avoid memory leaks
    searchController.dispose(); // Step 1: Dispose search controller
    super.dispose();
  }


       

  Stream<List<Machine>> fetchMachines() async* {
    while (true) {
      try {
        final response =
            await http.get(Uri.parse('http://localhost:2000/api/machines'));
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          List<Machine> fetchedMachines = data
              .where((machine) => machine.containsKey('name'))
              .map((machine) {
                        final  DateTime currentassignedat = DateTime.now();

            List<Tool> machineTools = (machine['tools'] as List)
    .map((toolData) => Tool(toolData, assignedat: currentassignedat ))
    .toList();

            return Machine(machine['name'], machineTools);
          }).toList();

          yield fetchedMachines;
          setState(() {
        machines = fetchedMachines;
      });
      //refreshMachines();
        } else {
          throw Exception('Failed to load machines');
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }
  
 

}

void setState4(Null Function() param0) {
}

Future<void> adhistory(String selectedMachineName, String ns) async {
    

  final response = await http.post(
    Uri.parse('http://localhost:2000/api/assignment'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'toolNS': ns, 'machineName': selectedMachineName}),
  );
  if (response.statusCode == 200) {
    print('history recorded');
    
  }
}
Future<void> adhistory2(String selectedMachineName, String ns) async {
    

  final response = await http.post(
    Uri.parse('http://localhost:2000/api/assignment/2'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'toolNS': ns, 'machineName': selectedMachineName}),
  );
  if (response.statusCode == 200) {
    print('history recorded');
    
  }
}
Future<void> assigntool(String ns, String selectedMachineName, BuildContext context) async {
      List<Machine> machines = [];

  if (ns.isEmpty || selectedMachineName.isEmpty) {
    print('Error: NS or machine name cannot be empty');
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('http://localhost:2000/api/machines/a'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'tools': [ns], 'name': selectedMachineName}), // Ensure tools is an array
    );

    if (response.statusCode == 200) {
      print('Tool assigned successfully');
      final data = jsonDecode(response.body);

      // Find the assigned machine in the local list
      final assignedMachine = machines.firstWhere(
        (m) => m.name == selectedMachineName,
        orElse: () => Machine('', []),
      );
      final assignedTool = Tool(ns, assignedat: DateTime.now()); // Set current time as assignedat

      // Update the machine's tools if not already assigned
      if (!assignedMachine.tools.any((tool) => tool.NS == ns)) {
        assignedMachine.tools.add(assignedTool);
      } else {
        print('Tool $ns is already assigned to machine $selectedMachineName');
      }
    } else if (response.statusCode == 409) {
      /*final data = jsonDecode(response.body);
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to assign tool'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );*/
      print('error');
    } else {
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to assign tool'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  } catch (error) {
    print('Error: $error');
  }
}

/*Future<void> assigntool(String ns, String selectedMachineName, BuildContext context) async {
    List<Machine> machines = [];

  if (ns.isEmpty || selectedMachineName.isEmpty) {
    print('Error: NS or machine name cannot be empty');
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('http://localhost:2000/api/machines/a'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'tools': [ns], 'name': selectedMachineName}), // Ensure tools is an array
    );

    if (response.statusCode == 200) {
      print('Tool assigned successfully');
      final data = jsonDecode(response.body);
      final assignedMachine = machines.firstWhere((m) => m.name == selectedMachineName, orElse: () => Machine('', []));
      final assignedTool = Tool(ns, assignedat: DateTime.now()); // Set current time as assignedat

      if (!assignedMachine.tools.any((tool) => tool.NS == ns)) {
        assignedMachine.tools.add(assignedTool);
        //assignedMachine.isRed = assignedMachine.hasOverdueTool();
      } else {
        print('Tool $ns is already assigned to machine $selectedMachineName');
      }
    } else if (response.statusCode == 409) {
      final data = jsonDecode(response.body);
      print('Some tools already assigned to another machine:' );/*${data['alreadyAssignedTools']} assigned to ${data['assignedMachines']}'*/ 
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Some tools already assigned to another machine: '),/*${data['alreadyAssignedTools']} assigned to ${data['assignedMachines']}'*/ 
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      print('Failed to assign tool: ${response.statusCode}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to assign tool'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  } catch (error) {
    print('Error: $error');
  }
}*/

void setState3(Null Function() param0) {
}

Future<void> deletetool(String ns, String selectedMachineName, List<Machine> machines) async {
  if (ns.isEmpty) {
    print('Error: NS cannot be empty');
    return;
  }

  try {
    final response = await http.delete(
      Uri.parse('http://localhost:2000/api/machines/'),
      headers: {'Content-Type': 'application/json'}, // Set the content-type header
      body: jsonEncode({'tools': ns, 'name': selectedMachineName}), // Encode the data as JSON
    );

    if (response.statusCode == 200) {
      print('Tool removed successfully');
      final machine = machines.firstWhere((m) => m.name == selectedMachineName, orElse: () => Machine('', []));
      setState5(() {
        machine.tools.removeWhere((tool) => tool.NS == ns);
      });
      
      // Update history after tool is removed
      await adhistory2(selectedMachineName!, ns);
    } else if (response.statusCode == 409) {
      print('Error');
    } else {
      print('Failed to delete data: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

void setState5(Null Function() param0) {
}

/*Future<bool> deletetool(String ns, String selectedMachineName, List<Machine> machines) async {
  if (ns.isEmpty) {
    print('Error: NS cannot be empty');
    return false;
  }

  try {
    final response = await http.delete(
      Uri.parse('http://localhost:2000/api/machines/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'tools': ns, 'name': selectedMachineName}),
    );

    if (response.statusCode == 200) {
      print('Tool removed successfully');
      final machine = machines.firstWhere((m) => m.name == selectedMachineName, orElse: () => Machine('', []));
      setState3(() {
        machine.tools.removeWhere((tool) => tool.NS == ns);
      });
       await adhistory(selectedMachineName, ns);
      return true;
    } else {
      print('Failed to delete data: ${response.statusCode}');
      return false;
    }
  } catch (error) {
    print('Error: $error');
    return false;
  }
}*/




Widget machineCard(BuildContext context, Machine machine,List<Machine> machines) {


  return GestureDetector(
    onTap: () {
      _showToolsDialog(context, machine,machines);
    },
    child: Card(
      elevation: 3,
      
      margin: EdgeInsets.all(5.0),
      child: Stack(
        children: [
          ListTile(
            title: Text(machine.name),
          ),
          
          Positioned(
            top: 0,
            right: 0,
            child: Container(

              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color:machine.tools.length>3 ?  Colors.red: Colors.green, 
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                machine.tools.length.toString(), 
                style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                ),
              ),  
            ),
          ),
        ],
      ),
    ),
  );
}
void _showAddMachineDialog(BuildContext context) {
    String name = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Machine'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namecontroller,
              decoration: InputDecoration(labelText: 'Machine name'),
              onChanged: (value) => name = value,
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
              // Call the function to post data to the database
              postmachine(name,context);
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
 Future <void> postmachine(String name,BuildContext context) async{
    if (name.isEmpty) {
    print('Name cant be empty');
    return;
  }
  try {
    final response = await http.post(
      Uri.parse('http://localhost:2000/api/machines'),
      headers: {'Content-Type': 'application/json'}, // Set the content-type header
      body: jsonEncode({'name': name}), // Encode the data as JSON
    );

    if (response.statusCode == 200) {
      print('Data posted successfully');
    } else if (response.statusCode == 409) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Name could be already existing.'),
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
  
void _showToolsDialog(BuildContext context, Machine machine,List<Machine> machines) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Tools in ${machine.name}'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: machine.tools.map((tool) {
                return _buildToolCard(context, tool, machine, () {
                  // Callback function to remove the tool from the machine
                  setState(() {
                    machine.tools.remove(tool);
                    //machine.isRed = machine.tools.any((t) => DateTime.now().difference(t.assignedat).inSeconds > 10);
                  
                  });
                },machines);
              }).toList(),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _buildToolCard( BuildContext context, Tool tool, Machine machine, VoidCallback onDelete, List<Machine> machines) {
  final now = DateTime.now();
  
  

  return Card(
    
    elevation: 3,
    margin: EdgeInsets.symmetric(vertical: 4.0),
    child: ListTile(
      title: Text(tool.NS),
      subtitle: Text(tool.assignedat.toString()),
        // subtitle:text('assignedat':${access['date']}
      trailing: IconButton(
        icon: Icon(Icons.delete, color:Colors.red),
        onPressed: () async {
          onDelete();
          await deletetool(tool.NS, machine.name, machines);
          
        },
      ),
    ),
  );
}


void setState2(Null Function() param0) {
}


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MachineProvider(),
      child: MainScreen(),
    ),
  );
}

