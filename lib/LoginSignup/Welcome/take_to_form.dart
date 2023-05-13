// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get/route_manager.dart';
// import 'package:scisco_service/Homepage/Dashboard.dart';
// import 'package:scisco_service/Homepage/ServiceEngDashBoard.dart';
// import 'package:scisco_service/LoginSignup/Login/login_screen.dart';
// import 'package:scisco_service/Utils/CommonStrings.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// class TakeToForm extends StatefulWidget {
//   @override
//   _TakeToFormState createState() => _TakeToFormState();
// }

// class _TakeToFormState extends State<TakeToForm> {
//   SharedPreferences prefs;
//   GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
//   bool isLogin = false;
//   var customerid;
//   var customername;
//   var serviceengineerid;
//   var serviceengineername;
//   String installationpending;
//   String installationdone;
//   String servicepending;
//   String servicedone;

//   void showSnack(String text) {
//     if (_scaffoldKey.currentContext != null) {
//       ScaffoldMessenger.of(_scaffoldKey.currentContext)
//           .showSnackBar(SnackBar(content: Text(text)));
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(milliseconds: 3000), () {
//       doSomeAsyncStuff();
//     });
//   }

//   Future<void> doSomeAsyncStuff() async {
//     prefs = await SharedPreferences.getInstance();
//     isLogin = prefs.getBool(SharedPrefKey.ISLOGEDIN);
//     if (isLogin == null) {
//       isLogin = false;
//     }
//     customerid = prefs.getString(SharedPrefKey.COSTUMERID);
//     customername = prefs.getString(SharedPrefKey.CUSTOMERNAME);
//     serviceengineerid = prefs.getString(SharedPrefKey.SERVICEENGINEERID);
//     serviceengineername = prefs.getString(SharedPrefKey.SERVICEENGINEERNAME);
//     installationpending = prefs.getString(SharedPrefKey.INSTALLATIONPENDING);
//     installationdone = prefs.getString(SharedPrefKey.INSTALLATIONDONE);
//     servicepending = prefs.getString(SharedPrefKey.SERVICEPENDING);
//     servicedone = prefs.getString(SharedPrefKey.SERVICEDONE);
//     redirectTo();
//   }

//   void redirectTo() {
//     if (prefs.getBool(SharedPrefKey.ISLOGEDIN) != null) {
//       if (prefs.getString(SharedPrefKey.SERVICEENGINEERID) != null) {
//         setState(() {
//           Get.to(() =>ServiceEngDashboard(
//                       isLogin,
//                       serviceengineerid,
//                       serviceengineername,
//                       installationpending,
//                       installationdone,
//                       servicepending,
//                       servicedone))
//         });
//       } else if (prefs.getString(SharedPrefKey.COSTUMERID) != null) {
//         setState(() {
//           navigator.pushReplacement(
//               MaterialPageRoute(
//                   builder: (BuildContext context) =>
//                       new Dashboard(isLogin, customerid, customername)));
//         });
//       }
//     } else {
//       navigator.pushReplacement(
//           MaterialPageRoute(
//               builder: (BuildContext context) => new LoginScreen()));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text("Press back to return to the map"),
//       ),
//     );
//   }
// }
