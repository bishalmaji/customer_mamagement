// import 'package:customer_managment/screens/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// void main() {
//   runApp(const AppMain());
// }
//
// class AppMain extends StatefulWidget {
//   const AppMain({Key? key}) : super(key: key);
//
//   @override
//   _AppMainState createState() => _AppMainState();
// }
//
// class _AppMainState extends State<AppMain> with WidgetsBindingObserver {
//   @override
//   Widget build(BuildContext context) {
//     return const GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Customer Management',
//       home: LoginScreen(),
//     );
//   }
// }


import 'package:customer_managment/screens/customer_list.dart';
import 'package:customer_managment/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/user_controller.dart';

void main() {
  runApp(const AppMain());
}

class AppMain extends StatelessWidget {
  const AppMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Customer Management',
      home: Root(),
    );
  }
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<UserController>(
      init: UserController(),
      builder: (UserController userController) {
        return userController.isLoggedIn.value ? CustomerListPage() : LoginScreen();
      },
    );
  }
}
