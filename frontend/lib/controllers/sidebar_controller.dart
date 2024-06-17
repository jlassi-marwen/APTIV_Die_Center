import 'package:frontend/screens_and_main/dashboard.dart';
import 'package:frontend/screens_and_main/tools.dart';
import 'package:frontend/screens_and_main/history.dart';
import 'package:frontend/screens_and_main/users.dart';
import 'package:frontend/screens_and_main/repairs.dart';
import 'package:frontend/screens_and_main/stats.dart';

import 'package:get/get.dart';

class Sidebar_controller extends GetxController{
  RxInt index=0.obs;
    var pages=[
    MainScreen(),
    Tools(),
    History(),
    Repairs(),
    ToolDashboard(),
    Users()
    ];
    void updateIndex(int newIndex) {
    index.value = newIndex;
  }
}  
