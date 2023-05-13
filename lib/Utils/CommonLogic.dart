// import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import '../app_theme.dart';

// Future<bool> checkConnection() async {
//   var connectivityResult = await (Connectivity().checkConnectivity());
//   if (connectivityResult == ConnectivityResult.mobile ||
//       connectivityResult == ConnectivityResult.wifi) {
//     return true;
//   }
//   return false;
// }
bool validateEmail(String email) {
  String p =
      //r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
      r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(email);
}

void displayToast(String msg, BuildContext context) {
  Toast.show(msg, duration: Toast.lengthLong, gravity: Toast.bottom);
}

Future<bool> storagePermission() async {
  if (await Permission.storage.request().isGranted) return true;
  return false;
}

Future<bool> cameraPermission() async {
  if (await Permission.camera.request().isGranted) return true;
  return false;
}

Future<bool> locationPermission() async {
  if (await Permission.location.request().isGranted) return true;
  return false;
}

Future<bool> getLocationPermision() async {
// You can request multiple permissions at once.
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
  ].request();
  print(statuses[Permission.location]);
}

void _showMyDialogError(
  BuildContext context,
  String msg,
) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Error"),
          content: Padding(
            padding: EdgeInsets.all(10),
            child: Text(msg),
          ),
          actions: <Widget>[
            /*CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: (){
                Get.back();
              },
              child: Text("Cancel")
          ),*/
            CupertinoDialogAction(
                textStyle: TextStyle(color: Colors.red),
                isDefaultAction: true,
                onPressed: () async {
                  Get.back();
                  // SharedPreferences prefs = await SharedPreferences.getInstance();
                  // prefs.remove('isLogin');
                  // navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (BuildContext ctx) => Login()));
                },
                child: Text(
                  "Okay",
                  style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      color: AppTheme.buttoncolor),
                )),
          ],
        );
      });
}
