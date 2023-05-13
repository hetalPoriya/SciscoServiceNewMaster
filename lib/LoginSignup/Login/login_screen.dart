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
import 'package:scisco_service/LoginSignup/Signup/signup_screen.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/components/already_have_an_account_acheck.dart';
import 'package:scisco_service/components/rounded_button.dart';
import 'package:scisco_service/components/text_field_container.dart';
import 'package:scisco_service/models/LoginRespoModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailAddressCtrl = new TextEditingController();
  final TextEditingController _passwordCtrl = new TextEditingController();
  bool _passwordVisible = false;
  // GetStorage box = GetStorage();

  @override
  void initState() {
    _passwordVisible = false;
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
                "LOGIN",
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
                  controller: _emailAddressCtrl,
                  keyboardType: TextInputType.number,
                  cursorColor: AppTheme.nearlyBlack,
                  decoration: InputDecoration(
                    hintText: "Mobile Number",
                    border: InputBorder.none,
                  ),
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
              InkWell(
                child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                        padding:
                            EdgeInsets.only(right: 20, bottom: 10, top: 10),
                        child: Text(
                          'Forgot password',
                          style: TextStyle(fontFamily: AppTheme.fontName),
                          textAlign: TextAlign.right,
                        ))),
                onTap: () {
                  navigator.push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ForgetPassword();
                      },
                    ),
                  );
                },
              ),
              RoundedButton(
                text: "LOGIN",
                color: AppTheme.appColor,
                press: () {
                  if (_emailAddressCtrl.text.toString().isEmpty) {
                    _showMyDialog(context, "Please Enter Your mobile number");
                  } else if (!validateEmail(
                      _emailAddressCtrl.text.toString())) {
                    _showMyDialog(context, "Please Enter Valid mobile number");
                  } else if (_passwordCtrl.text.toString().isEmpty) {
                    _showMyDialog(context, "Please Enter Password");
                  } else {
                    loginreq();
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

  Future<Response> loginreq() async {
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
          "mobile": _emailAddressCtrl.text.toString(),
          "password": _passwordCtrl.text.toString(),
        };

        var loginrespo = FormData.fromMap(formData);

        print(formData.toString());
        Response response = await baseApi.dio.post(loginapi, data: loginrespo);
        print(loginrespo.toString());
        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE of login:" + parsed.toString());
          // String error = parsed["error"].toString();
          //print("Status: "+parsed["status"]);
          String status = parsed["status"];
          if (status == "Customer exist") {
            LoginRespoModel loginRespoModel = LoginRespoModel.fromJson(parsed);
            print(loginRespoModel);
            print("Status " + loginRespoModel.engineer_status);
            print("engineer_name " + loginRespoModel.engineer_name);
            print("engineer_email " + loginRespoModel.engineer_email);
            print("engineer_mobile " + loginRespoModel.engineer_mobile);
            progressDialog.dismiss();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool(SharedPrefKey.ISLOGEDIN, true);
            prefs.setString(
                SharedPrefKey.COSTUMERID, loginRespoModel.customer_id);
            prefs.setString(
                SharedPrefKey.CUSTOMERNAME, loginRespoModel.customer_name);

            if (loginRespoModel.engineer_status ==
                "Service Engineer Assigned") {
              print("inside service engineer assigned");
              prefs.setString(
                  SharedPrefKey.ENGINEER_NAME, loginRespoModel.engineer_name);
              print("Service Engineer: " + loginRespoModel.engineer_name);
              prefs.setString(
                  SharedPrefKey.ENGINEER_EMAIL, loginRespoModel.engineer_email);
              prefs.setString(SharedPrefKey.ENGINEER_MOBILE,
                  loginRespoModel.engineer_mobile);
            }
            setState(() {
              Get.offUntil(
                  GetPageRoute(
                    page: () => new Dashboard(
                      true,
                      loginRespoModel.customer_id,
                      loginRespoModel.customer_name,
                    ),
                  ),
                  (route) => false);
              // navigator.pushAndRemoveUntil(
              //   context,
              //   (route) => false,
              // );
            });
          } else if (status == "Service Engineer exist") {
            LoginRespoModel loginRespoModel = LoginRespoModel.fromJson(parsed);
            progressDialog.dismiss();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool(SharedPrefKey.ISLOGEDIN, true);
            prefs.setString(SharedPrefKey.SERVICEENGINEERID,
                loginRespoModel.service_engineer_id);
            prefs.setString(SharedPrefKey.SERVICEENGINEERNAME,
                loginRespoModel.service_engineer_name);
            prefs.setString(SharedPrefKey.INSTALLATIONPENDING,
                loginRespoModel.installations_pending);
            prefs.setString(SharedPrefKey.INSTALLATIONDONE,
                loginRespoModel.installations_done);
            prefs.setString(
                SharedPrefKey.SERVICEPENDING, loginRespoModel.services_pending);
            prefs.setString(
                SharedPrefKey.SERVICEDONE, loginRespoModel.services_done);
            prefs.setInt(SharedPrefKey.ISPUNCHEDIN, 0);
            // box.write('isPunchIn', 1);
            // print("isPunchIn");
            // print(box.read('isPunchIn'));
            setState(() {
              Get.offUntil(
                  GetPageRoute(
                      page: () => new ServiceEngDashboard(
                            true,
                            loginRespoModel.service_engineer_id,
                            loginRespoModel.service_engineer_name,
                            loginRespoModel.installations_pending,
                            loginRespoModel.installations_done,
                            loginRespoModel.services_pending,
                            loginRespoModel.services_done,
                          )),
                  (route) => false);
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
}
