import 'dart:convert';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage/ServiceEngDashBoard.dart';
import 'package:scisco_service/LoginSignup/Login/login_screen.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/components/rounded_button.dart';
import 'package:scisco_service/components/text_field_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditEngProfile extends StatefulWidget {
  @override
  _EditEngProfileState createState() => _EditEngProfileState();
}

class _EditEngProfileState extends State<EditEngProfile> {
  SharedPreferences prefs;
  bool isLogin;
  var serviceengineerid;
  var serviceengineername;
  String installationpending;
  String installationdone;
  String servicepending;
  String servicedone;
//  ScrollController _controller;

  var selectedDate = new DateTime.now();
  final _nameCtrl = TextEditingController();
  final _emailidCtrl = TextEditingController();
  final _mobileNumCtrl = TextEditingController();
  //int index = 0;

  String _Name = "";
  String _emailAddress = "";
  String _mobileNumber = "";

  @override
  void initState() {
    initPrefs();
    getprofileData();
  }

  // @override
  // void dispose() {
//    animationController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppTheme.textcolor, //change your color here
        ),
        title: Text(
          "Edit your Profile",
          style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        actions: [
          // RaisedButton(
          //   color: AppTheme.appColor,
          //   onPressed: () async {
          //     _logoutDialog();
          //   },
          //   child: Icon(Icons.logout),
          // )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 25, top: 10),
                  child: Text(
                    'Enter Name',
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    controller: _nameCtrl,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      //      new WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
                    ],
                    cursorColor: AppTheme.nearlyBlack,
                    decoration: InputDecoration(
                      hintText: "Name",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 25, top: 10),
                  child: Text(
                    'Enter Email Id',
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    controller: _emailidCtrl,
                    enabled: false,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: AppTheme.nearlyBlack,
                    decoration: InputDecoration(
                      hintText: "Your Email",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 25, top: 10),
                  child: Text(
                    'Enter Mobile Number',
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    controller: _mobileNumCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      //new WhitelistingTextInputFormatter(RegExp("[0-9]")),
                    ],
                    cursorColor: AppTheme.nearlyBlack,
                    decoration: InputDecoration(
                      hintText: "Mobile Number",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            )),
      ),
      bottomNavigationBar: Visibility(
          visible: true,
          child: Container(
            alignment: Alignment.center,
            height: size.height * 0.12,
            color: AppTheme.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RoundedButton(
                  color: AppTheme.appColor,
                  text: "Update Profile",
                  press: () {
                    update_engineer_profile();
                  },
                ),
              ],
            ),
          )),
    );
  }

  Future<Response> getprofileData() async {
    bool isDeviceOnline = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // bool isDeviceOnline = await checkConnection();
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();

        Map<String, dynamic> formData = {
          "service_engineer_id": serviceengineerid,
        };
        print(formData.toString());

        var engineerProfile = FormData.fromMap(formData);

        Response response = await baseApi.dio
            .post(serviceengineerdetails, data: engineerProfile);
        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("PROFILE Response: " + parsed.toString());
          String error = parsed["error"].toString();
          progressDialog.dismiss();
          if (error == "1") {
            setState(() {
              _Name = parsed["name"];
              _emailAddress = parsed["email"];
              _mobileNumber = parsed["mobile"];

              _nameCtrl.text = _Name;
              _emailidCtrl.text = _emailAddress;
              _mobileNumCtrl.text = _mobileNumber;
            });
          } else {
            //     String error_msg = customerProfile.error_msg;
            //   displayToast(error_msg.toString(), context);
          }
        }

        return response;
      } catch (e) {
//        print("RESPOONSE:" + e);
//        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }

  Future<Response> update_engineer_profile() async {
    bool isDeviceOnline = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isDeviceOnline = await checkConnection();
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();

        Map<String, dynamic> formData = {
          "service_engineer_id":
              prefs.getString(SharedPrefKey.SERVICEENGINEERID),
          "name": _nameCtrl.text.toString(),
          "email": _emailidCtrl.text.toString(),
          "mobile": _mobileNumCtrl.text.toString()
        };

        var engineerprofiledit = FormData.fromMap(formData);
        print(formData);

        Response response =
            await baseApi.dio.post(updateengineer, data: engineerprofiledit);
        progressDialog.dismiss();
        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("Response of update profile:" + parsed.toString());
          String error = parsed["error"].toString();
          if (error == "1") {
            prefs.setString(
                SharedPrefKey.SERVICEENGINEERNAME, _nameCtrl.text.toString());
            prefs.setString(
                SharedPrefKey.EMAILID, _emailidCtrl.text.toString());
            prefs.setString(
                SharedPrefKey.MOBILENO, _mobileNumCtrl.text.toString());
            _showSuccessMyDialog(context, parsed["status"].toString());
          } else {
//            String error_msg = commonRespo.error_msg;
            //          displayToast(error_msg.toString(), context);
          }
        }
        return response;
      } catch (e) {
//        print("RESPOONSE:" + e.toString());
        progressDialog.dismiss();
        //      displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }

  void _showSuccessMyDialog(
    BuildContext context,
    String msg,
  ) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Profile Updated"),
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
                  textStyle: TextStyle(
                      color: Colors.red, fontFamily: AppTheme.fontName),
                  isDefaultAction: true,
                  onPressed: () async {
                    Get.to(
                      () => ServiceEngDashboard(
                        true,
                        serviceengineerid,
                        serviceengineername,
                        installationpending,
                        installationdone,
                        servicepending,
                        servicedone,
                      ),
                    );
                    // Get.back();
                    // navigator.pushReplacement(
                    //     context,));

                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // prefs.remove('isLogin');
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

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool(SharedPrefKey.ISLOGEDIN);
    if (isLogin == null) {
      isLogin = false;
    }
    setState(() {
      serviceengineerid = prefs.getString(SharedPrefKey.SERVICEENGINEERID);
      serviceengineername = prefs.getString(SharedPrefKey.SERVICEENGINEERNAME);
      installationpending = prefs.getString(SharedPrefKey.INSTALLATIONPENDING);
      installationdone = prefs.getString(SharedPrefKey.INSTALLATIONDONE);
      servicepending = prefs.getString(SharedPrefKey.SERVICEPENDING);
      servicedone = prefs.getString(SharedPrefKey.SERVICEDONE);
    });
    print("this is service engineer id:" + serviceengineerid);
  }

  Future<void> _logoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure? you want to logout'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('No'),
              onPressed: () {
                navigator.pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Yes'),
              onPressed: () async {
                navigator.pop();

                SharedPreferences prefs = await SharedPreferences.getInstance();

                prefs.remove(SharedPrefKey.SERVICEENGINEERID);
                prefs.remove(SharedPrefKey.SERVICEENGINEERNAME);
                prefs.remove(SharedPrefKey.ISLOGEDIN);
                navigator.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
