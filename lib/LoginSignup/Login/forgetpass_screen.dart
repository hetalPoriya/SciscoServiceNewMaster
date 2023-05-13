import 'dart:convert';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage/Dashboard.dart';
import 'package:scisco_service/Homepage/ServiceEngDashBoard.dart';
import 'package:scisco_service/LoginSignup/Login/components/background.dart';
import 'package:scisco_service/LoginSignup/Login/forgetpass_screen.dart';
import 'package:scisco_service/LoginSignup/Login/login_screen.dart';
import 'package:scisco_service/LoginSignup/Signup/signup_screen.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/components/already_have_an_account_acheck.dart';
import 'package:scisco_service/components/rounded_button.dart';
import 'package:scisco_service/components/text_field_container.dart';
import 'package:scisco_service/models/LoginRespoModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api/BaseApi.dart';

class ForgetPassword extends StatefulWidget {

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailCtrl = new TextEditingController();
  //final TextEditingController _cnfpasswordCtrl = new TextEditingController();
  bool _passwordVisible = false;
  bool _visible = false;

  @override
  void initState() {
    _passwordVisible = false;
    _visible = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Forget Password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(height: size.height * 0.03),
              Image.asset(
                "assets/images/scisco.png",
                fit: BoxFit.contain,
                height: 100,
                width: 200,
                alignment: Alignment.center,
              ),
              SizedBox(height: size.height * 0.03),
              TextFieldContainer(
                child: TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: AppTheme.nearlyBlack,
                  decoration: InputDecoration(
                    hintText: "Your Email Id",
                    border: InputBorder.none,
                  ),
                ),
              ),
              RoundedButton(
                text: "Request For Password",
                color: AppTheme.appColor,
                press: () {
                  if (_emailCtrl.text.toString().isEmpty) {
                    _showMyDialog(context, "Please Enter Email Id");
                  } else if (!validateEmail(
                      _emailCtrl.text.toString())) {
                    _showMyDialog(context, "Please Enter Valid email Id");
                  } else {
                    passwordreq();
                  }
                },
              ),
              SizedBox(height: size.height * 0.03),
              /*AlreadyHaveAnAccountCheck(
                press: () {
                  navigator.push(
                    MaterialPageRoute(
                      builder: (context) {
                        //    print(selectedProducts);
                        return SignUpScreen();
                      },
                    ),
                  );
                },
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  void _showMyDialog(BuildContext context, String msg) {
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

  Future<Response> passwordreq() async {
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
          "email": _emailCtrl.text.toString(),
        };

        var passwordrespo = FormData.fromMap(formData);

        print(formData.toString());
        Response response = await baseApi.dio.post(reqpasswordapi, data: passwordrespo);
        print(passwordrespo.toString());
        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE of password:" + parsed.toString());
          // String error = parsed["error"].toString();
          //print("Status: "+parsed["status"]);
          String status = parsed["status"];
          print(status);
          if(parsed["error"] == 1){
            progressDialog.dismiss();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text("Error"),
                    content: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(status),
                    ),
                    actions: <Widget>[
                      CupertinoDialogAction(
                          textStyle: TextStyle(
                              color: Colors.red, fontFamily: AppTheme.fontName),
                          isDefaultAction: true,
                          onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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

}
