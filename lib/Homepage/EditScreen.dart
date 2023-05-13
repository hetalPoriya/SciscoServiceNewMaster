import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage/Dashboard.dart';
import 'package:scisco_service/Homepage/changepassword.dart';
import 'package:scisco_service/LoginSignup/Login/login_screen.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/components/rounded_button.dart';
import 'package:scisco_service/components/text_field_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  // AnimationController animationController;
  SharedPreferences prefs;
  bool isLogin;
  var customerid;
  var customername;
  ScrollController _controller;

  //  List<Item> indexList = new List();
  var selectedDate = new DateTime.now();
  final _nameCtrl = TextEditingController();
  final _emailidCtrl = TextEditingController();
  final _mobileNumCtrl = TextEditingController();
  final _wpctrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _orgctrl = TextEditingController();

  int index = 0;

  String _Name = "";
  String _emailAddress = "";
  String _mobileNumber = "";
  String _whatsapp = "";

//  String _address = "";
  String _organization = "";

  @override
  void initState() {
    initPrefs();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    getprofileData();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {});
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {});
    }
  }

  @override
  void dispose() {
//    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppTheme.textcolor, //change your color here
        ),
        elevation: 0,
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
          Padding(padding: EdgeInsets.fromLTRB(0, 5, 20, 0),
            child:
            Ink(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(241, 242, 243, 1.0),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0))),
                child:
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      0, 0, 0.3, 3),
                  child: IconButton(
                    icon: Icon(Icons.logout),
                    //style: ButtonStyle(color: Colors.black,),
                    onPressed: () async {
                      _logoutDialog();
                    },
                  ),
                )
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20),
      child:
      SingleChildScrollView(
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
                      //new WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
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
                Padding(
                  padding: const EdgeInsets.only(top:10.0,bottom: 10),
                  child: Container(
                    child: ButtonTheme(
                      minWidth: 300.0,
                      height: 50.0,
                      buttonColor: AppTheme.chipBackground,
                      child:  ElevatedButton(
                        onPressed: () {
                          navigator.push(
                              MaterialPageRoute(
                                  builder: (BuildContext ctx) =>
                                      ChangePassword(true, customerid, customername)));
                        },
                        child: Text("Change Password"),
                      ),
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
                     // new WhitelistingTextInputFormatter(RegExp("[0-9]")),
                    ],
                    cursorColor: AppTheme.nearlyBlack,
                    decoration: InputDecoration(
                      hintText: "Mobile Number",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 25, top: 10),
                  child: Text(
                    'Enter Whatsapp Number',
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    controller: _wpctrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      //new WhitelistingTextInputFormatter(RegExp("[0-9]")),
                    ],
                    cursorColor: AppTheme.nearlyBlack,
                    decoration: InputDecoration(
                      hintText: "Whatsapp Number",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 25, top: 10),
                  child: Text(
                    'Enter Organization Name',
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    controller: _orgctrl,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      //new WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
                    ],
                    cursorColor: AppTheme.nearlyBlack,
                    decoration: InputDecoration(
                      hintText: "Organization Name",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 25, top: 10),
                  child: Text(
                    'Enter Address',
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    controller: _addressCtrl,
                    cursorColor: AppTheme.nearlyBlack,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    inputFormatters: [
                      //new WhitelistingTextInputFormatter(
                        //  RegExp("[a-zA-Z 0-9]")),
                    ],
                    decoration: InputDecoration(
                      hintText: "Address",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            )),
      )),
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
                    update_personal_profile();
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
          "customer_id": prefs.getString(SharedPrefKey.COSTUMERID),
        };
        print(formData.toString());

        var customerProfile = FormData.fromMap(formData);

        Response response =
            await baseApi.dio.post(editprofile, data: customerProfile);
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
              _whatsapp = parsed["whatsapp_no"];
              _organization = parsed["organization"];

              _nameCtrl.text = _Name;
              _emailidCtrl.text = _emailAddress;
              _mobileNumCtrl.text = _mobileNumber;
              _wpctrl.text = _whatsapp;
              _addressCtrl.text = parsed["address"];
              _orgctrl.text = _organization;
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

  Future<Response> update_personal_profile() async {
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
          "customer_id": prefs.getString(SharedPrefKey.COSTUMERID),
          "mobile": _mobileNumCtrl.text.toString(),
          "name": _nameCtrl.text.toString(),
          "address": _addressCtrl.text.toString(),
          "email": _emailidCtrl.text.toString(),
          "whatsapp_no": _wpctrl.text.toString(),
          "organization": _orgctrl.text.toString()
        };

        var myprofiledit = FormData.fromMap(formData);

        Response response =
            await baseApi.dio.post(edit_profileUrl, data: myprofiledit);
        progressDialog.dismiss();
        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("Response of update profile:" + parsed.toString());
          String error = parsed["error"].toString();
          if (error == "1") {
            prefs.setString(
                SharedPrefKey.CUSTOMERNAME, _nameCtrl.text.toString());
            prefs.setString(
                SharedPrefKey.EMAILID, _emailidCtrl.text.toString());
            prefs.setString(
                SharedPrefKey.MOBILENO, _mobileNumCtrl.text.toString());
            prefs.setString(
                SharedPrefKey.ADDRESS, _addressCtrl.text.toString());
            prefs.setString(SharedPrefKey.WHATSAPP, _wpctrl.text.toString());
            prefs.setString(
                SharedPrefKey.ORGANIZATION, _orgctrl.text.toString());

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

  void _showSuccessMyDialog(BuildContext context, String msg,) {
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
                    Get.back();
                    navigator.pushReplacement(
                        MaterialPageRoute(
                            builder: (BuildContext ctx) =>
                                Dashboard(true, customerid, customername)));

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

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool(SharedPrefKey.ISLOGEDIN);
    if (isLogin == null) {
      isLogin = false;
    }
    setState(() {
      customerid = prefs.getString(SharedPrefKey.COSTUMERID);
      customername = prefs.getString(SharedPrefKey.CUSTOMERNAME);
    });
  }
}
