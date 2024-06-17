

import 'package:flutter/material.dart';
import 'package:frontend/controllers/sidebar_controller.dart';
import 'package:frontend/login.dart';
import 'package:frontend/screens_and_main/users.dart';
import 'package:get/get.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/user_model.dart';

class sider_page extends StatelessWidget {
  const sider_page({super.key});
  Widget build(BuildContext context) {
        Sidebar_controller sidebar_controller= Get.put(Sidebar_controller());
            user_model user = Provider.of<user_model>(context);

    return Scaffold(
      
      appBar: AppBar(
        title:  SizedBox(
    width: 100, // Set the width of the image
    height: 50, // Set the height of the image
    child: Image.asset('image/APTIV_logo.PNG'),
  ),
        backgroundColor: Colors.black, // Set app bar background color to black
       actions: [
        Consumer<user_model>(
          builder: (context, user_model, child) {
            return Row(
              children: [
                ...[
                  /* CircleAvatar(
                  backgroundImage: AssetImage('avatar_image.png'),
                ),*/
Icon(Icons.supervised_user_circle),
                Text(
                  //"admin",
                  user_model.username,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                SizedBox(width: 10),
               
                SizedBox(width: 10),
              ],
              ],
            );
          },
        ),
              ],
      ),

      
      drawer: Drawer(
  backgroundColor: Colors.black,
  child: ListView(
    shrinkWrap: true,
    children: [
      ListTile(
        leading: IconButton(
  icon: Icon(
    Icons.home,
    color: Colors.white, // Change the color to white
  ),
  onPressed: () {
    // Your onPressed code here
  },
),

        onTap: () {
          sidebar_controller.index.value = 0;
          Navigator.pop(context); // Close the drawer
        },
        selected: sidebar_controller.index.value == 0,
        title: Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
      ),
      ListTile(
        leading: IconButton(
  icon: Icon(
    Icons.settings,
    color: Colors.white, // Change the color to white
  ),
  onPressed: () {
    // Your onPressed code here
  },
),
        onTap: () {
          sidebar_controller.index.value = 1;
          Navigator.pop(context); // Close the drawer
        },
        selected: sidebar_controller.index.value == 1,
        title: Text(
          "Tool Management",
          style: TextStyle(color: Colors.white),
        ),
      ),
      ListTile(
        leading: IconButton(
  icon: Icon(
    Icons.history,
    color: Colors.white, // Change the color to white
  ),
  onPressed: () {
    // Your onPressed code here
  },
),
        onTap: () {
          sidebar_controller.index.value = 2;
          Navigator.pop(context); // Close the drawer
        },
        selected: sidebar_controller.index.value == 2,
        title: Text(
          "Assignment History",
          style: TextStyle(color: Colors.white),
        ),
      ),
      ListTile(
        leading: IconButton(
  icon: Icon(
    Icons.build,
    color: Colors.white, // Change the color to white
  ),
  onPressed: () {
    // Your onPressed code here
  },
),
        onTap: () {
          sidebar_controller.index.value = 3;
          Navigator.pop(context); // Close the drawer
        },
        selected: sidebar_controller.index.value == 3,
        title: Text(
          "Repairs",
          style: TextStyle(color: Colors.white),
        ),
      ),
      ListTile(
        leading: IconButton(
  icon: Icon(
    Icons.pie_chart,
    color: Colors.white, // Change the color to white
  ),
  onPressed: () {
    // Your onPressed code here
  },
),
        onTap: () {
          sidebar_controller.index.value = 4;
          Navigator.pop(context); // Close the drawer
        },
        selected: sidebar_controller.index.value == 4,
        title: Text(
          "Statistics",
          style: TextStyle(color: Colors.white),
        ),
      ),
      if (user.username == 'admin') ...[
              ListTile(
                leading: IconButton(
  icon: Icon(
    Icons.supervised_user_circle,
    color: Colors.white, // Change the color to white
  ),
  onPressed: () {
    // Your onPressed code here
  },
),
                title: Text('Manage Users',style: TextStyle(color: Colors.white),),
                onTap: () {
                  sidebar_controller.index.value = 5;
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Users()),
                  );
                },
                 selected: sidebar_controller.index.value == 5,

              ),
            ],
      ListTile(
        leading: IconButton(
  icon: Icon(
    Icons.logout,
    color: Colors.white, // Change the color to white
  ),
  onPressed: () {
    // Your onPressed code here
  },
),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => login_screen(),
            ),
          );
        },
        title: Text(
          "Log out",
          style: TextStyle(color: Colors.white),
        ),
      ),
    ],
  ),
),

      body:Column(
        children: [Expanded(
        //flex: 5, // Flex for the main content area
        child: Obx(() => sidebar_controller.pages[sidebar_controller.index.value]),
      ),],
      ),
    );
}
}