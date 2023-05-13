import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage/Dashboard.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/components/rounded_button.dart';
import 'package:scisco_service/components/text_field_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  bool isLogin;
  String customerid;
  String customername;

  ChangePassword(this.isLogin, this.customerid, this.customername);

  @override
  _ChangePasswordState createState() =>
      _ChangePasswordState(this.isLogin, this.customerid, this.customername);
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldpassword = new TextEditingController();
  final TextEditingController _passwordCtrl = new TextEditingController();
  final TextEditingController _cnfpassword = new TextEditingController();

  bool _oldpass = false;
  bool _passwordVisible = false;
  bool _cnfpass = false;

  SharedPreferences prefs;
  bool isLogin;
  var customerid;
  var customername;
  var customeremail;
  var customermobile;
  var customeraddress;
  var customerwhatsapp;
  var customerorganization;

  _ChangePasswordState(this.isLogin, this.customerid, this.customername);

  @override
  void initState() {
    _passwordVisible = false;
    initPrefs();
    print(customerid);
    print(customername);
    super.initState();
  }

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
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              Get.back();
              // navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext ctx) => Dashboard(
              //             true, customerid, customername)));
            }),
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
                    'Enter Old Password',
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    inputFormatters: [
                      // new BlacklistingTextInputFormatter(
                      //     new RegExp('[\\.|\\,;={}()<>]')),
                    ],
                    controller: _oldpassword,
                    obscureText: !_oldpass,
                    cursorColor: AppTheme.nearlyBlack,
                    decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _oldpass ? Icons.visibility : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _oldpass = !_oldpass;
                          });
                        },
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 25, top: 10),
                  child: Text(
                    'Enter New Password',
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    inputFormatters: [
                      // new BlacklistingTextInputFormatter(
                      //     new RegExp('[\\.|\\,;={}()<>]')),
                    ],
                    controller: _passwordCtrl,
                    obscureText: !_passwordVisible,
                    cursorColor: AppTheme.nearlyBlack,
                    decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 25, top: 10),
                  child: Text(
                    'Confirm New Password',
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    inputFormatters: [
                      // new BlacklistingTextInputFormatter(
                      //     new RegExp('[\\.|\\,;={}()<>]')),
                    ],
                    controller: _cnfpassword,
                    obscureText: !_cnfpass,
                    cursorColor: AppTheme.nearlyBlack,
                    decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _cnfpass ? Icons.visibility : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _cnfpass = !_cnfpass;
                          });
                        },
                      ),
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
                  text: "Submit",
                  press: () {
                    if (_oldpassword.text.toString().isEmpty) {
                      _showDialog(context, "Please Enter Old Password");
                    } else if (_passwordCtrl.text.toString().isEmpty) {
                      _showDialog(context, "Please Enter New Password");
                    } else if (_cnfpassword.text.toString().isEmpty) {
                      _showDialog(context, "Please Confirm Password");
                    } else if (_passwordCtrl.text.toString() !=
                        _cnfpassword.text.toString()) {
                      _showDialog(context, "Password does not match");
                    } else {
                      changepassword();
                    }
                  },
                ),
              ],
            ),
          )),
    );
  }

  Future<Response> changepassword() async {
    bool isDeviceOnline = true;
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      ArsProgressDialog progressDialog = ArsProgressDialog(context,
          blur: 2,
          backgroundColor: Color(0x33000000),
          animationDuration: Duration(milliseconds: 500));
      progressDialog.show();
      try {
        BaseApi baseApi = new BaseApi();

        Map<String, dynamic> formData = {
          "customer_id": customerid,
          "old_password": _oldpassword.text.toString(),
          "password": _passwordCtrl.text.toString(),
          "confirm_password": _cnfpassword.text.toString()
        };

        var passwordrespo = FormData.fromMap(formData);
        print(formData.toString());

        Response response =
            await baseApi.dio.post(customerchangepassword, data: passwordrespo);

        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE of change password:" + parsed.toString());
          String error = parsed["error"].toString();
          if (error == "1") {
            progressDialog.dismiss();
            setState(() {
              _showMyDialog(context, parsed["status"].toString());
            });
          } else {
            progressDialog.dismiss();
            String error_msg = parsed["status"].toString();
            _showMyDialog(context, error_msg);
          }
        }

        // return response;
      } catch (e) {
        print("RESPOONSE:" + e.toString());
        progressDialog.dismiss();
        displayToast("Something went wrong", context);
        return null;
      }
      // } else {
//      displayToast("Please connect to internet", context);
      return null;
    }
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
      customeremail = prefs.getString(SharedPrefKey.EMAILID);
      customeraddress = prefs.getString(SharedPrefKey.ADDRESS);
      customermobile = prefs.getString(SharedPrefKey.MOBILENO);
      customerwhatsapp = prefs.getString(SharedPrefKey.WHATSAPP);
      customerorganization = prefs.getString(SharedPrefKey.ORGANIZATION);
    });
  }

  void _showDialog(BuildContext context, String msg) {
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
              CupertinoDialogAction(
                  textStyle: TextStyle(
                      color: Colors.red, fontFamily: AppTheme.fontName),
                  isDefaultAction: true,
                  onPressed: () async {
                    Get.back();
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

  void _showMyDialog(BuildContext context, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Password Update"),
            content: Padding(
              padding: EdgeInsets.all(10),
              child: Text(msg),
            ),
            actions: <Widget>[
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
}
