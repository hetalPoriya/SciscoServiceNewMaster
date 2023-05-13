import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/route_manager.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage/ServiceEngDashBoard.dart';
import 'package:scisco_service/Homepage/servicerequestpending.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebServiceForm extends StatefulWidget {
  var product_id = "";
  var service_request_id = "";
  var customer_id = "";

  WebServiceForm(this.customer_id, this.product_id, this.service_request_id);

  @override
  _WebServiceFormState createState() => _WebServiceFormState(
      this.customer_id, this.product_id, this.service_request_id);
}

class _WebServiceFormState extends State<WebServiceForm> {
  _WebServiceFormState(
      this.customer_id, this.product_id, this.service_request_id);
  var currentUrl;
  InAppWebViewController _webViewController;
  String selectedups;
  var selectedRadio;
  String date = "";
  DateTime selectedDate = DateTime.now();
  File file;
  List<File> files = List<File>();
  List<String> onlineupsList = new List();
  List<String> radiolist = new List();

//  List<String> radiolabel = new List();
  String customfieldurl;
  var customValues = new List();
  var counter = 0;
  var customer_id = "";
  var product_id = "";
  var service_request_id = "";
  var label;
  var customdata;
  List<String> labellist = new List();
  List<String> customdatalist = new List();
  var labelsplit;
  var customdatasplit;
  final _servicepartCtrl = TextEditingController();
  final _servicegivenCtrl = TextEditingController();

  // final _inputCtrl = TextEditingController();
  TextEditingController _inputCtrl = new TextEditingController();
  SharedPreferences prefs;
  bool isLogin;
  var serviceengineerid;
  var serviceengineername;
  String installationpending;
  String installationdone;
  String servicepending;
  String servicedone;

  // static List<String> friendsList = [null];
  List<Asset> images = List<Asset>();
  String _error;
  List<File> fileitems = List<File>();
  List<String> fileitemsStr = List<String>();
  List<String> fileitemsServer = List<String>();
  var _values = [];

//  List<Map<String, dynamic>> _values;
  var _photo;
  var _reportFile;
  String photo;
  String report;
  bool datepicker = false;

  @override
  void initState() {
    //customValues = List.generate(customfieldlist.length, (value) => 1);
    initPrefs();
    serviceform();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new WillPopScope(
        onWillPop: () async => Navigator.push(context,
            MaterialPageRoute(builder: (context) => ServiceRequestPending())),
        child: Scaffold(
            backgroundColor: AppTheme.white,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: AppTheme.textcolor, //change your color here
              ),
              automaticallyImplyLeading: true,
              backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
              brightness: Brightness.light,
              elevation: 0,
              title: Text(
                "Service Form",
                style:
                    TextStyle(fontFamily: "PriximaNova", color: Colors.black),
              ),
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(23.0, 5.0, 0.0, 0.0),
                child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () async {
                      Get.offAll(ServiceEngDashboard(
                          isLogin,
                          serviceengineerid,
                          serviceengineername,
                          installationpending,
                          installationdone,
                          servicepending,
                          servicedone));
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceRequestPending()));
                    }),
              ),
              actions: [
                /*Padding(
              padding: EdgeInsets.only(
                  top: 20, right: SizeConfig.safeBlockHorizontal * 30),
              child: Text(
                "Installation Requests Done", style: TextStyle(
                  color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold, fontFamily: "PriximaNova"),),
          )*/
              ],
            ),
            body: Column(children: [
              Expanded(
                  child: InAppWebView(
                initialUrlRequest: URLRequest(
                    url: Uri.parse(
                        "https://synramtechnology.com/service/assets/loading_image/loading.jpg")),
                onWebViewCreated: (controller) async {
                  _webViewController = controller;
                },
              ))
            ])));
  }

  // Get.back();
  // BaseApi baseApi = new BaseApi();
  // Map<String, dynamic> formData = {
  //   "service_engineer_id":
  //   prefs.getString(SharedPrefKey.SERVICEENGINEERID),
  // };
  // var getCount = FormData.fromMap(formData);
  // Response response = await baseApi.dio
  //     .post(getEngineerHomescreenCount, data: getCount);
  // print('response $response');
  // if (response != null) {
  // final parsed =
  // json.decode(response.data).cast<String, dynamic>();
  //
  // prefs.setString(SharedPrefKey.INSTALLATIONPENDING,
  // parsed['installations_pending'].toString());
  // prefs.setString(SharedPrefKey.INSTALLATIONDONE,
  // parsed['installations_done'].toString());
  // prefs.setString(SharedPrefKey.SERVICEPENDING,
  // parsed['services_pending'].toString());
  // prefs.setString(SharedPrefKey.SERVICEDONE,
  // parsed['services_done'].toString());
  // Navigator.pushAndRemoveUntil(
  // context,
  // MaterialPageRoute(
  // builder: (context) => ServiceRequest()),
  // (route) => false);
  // }
  Future<Response> serviceform() async {
    bool isDeviceOnline = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //   bool isDeviceOnline = await checkConnection();
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    progressDialog.show();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();

        Map<String, dynamic> formData = {
          "product_id": product_id,
          "service_request_id": service_request_id
        };
        print('FORM DATAA ${formData.toString()}');

        var productrespo = FormData.fromMap(formData);

        Response response =
            await baseApi.dio.post(onwebserviceform, data: productrespo);

        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPONSE of service form list:" + parsed.toString());
          String error = parsed["error"].toString();
          if (error == "1") {
            //CustomFieldModel servicerespo = CustomFieldModel.fromJson(parsed);
            setState(() {
              customfieldurl = parsed["service_form_link"].toString();
              _webViewController.loadUrl(
                  urlRequest: URLRequest(url: Uri.parse("$customfieldurl")));
              print(customfieldurl);
            });
            progressDialog.dismiss();
          } else {
            //       AllocatedProdListModel allocatedrespo = AllocatedProdListModel.fromJson(parsed);
            //          String error_msg = allocatedrespo.error_msg;
            //        displayToast(error_msg.toString(), context);
          }
        }
        return response;
      } catch (e) {
        // print("RESPOONSE:" + e);
//        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      //   displayToast("Please connect to internet", context);
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
      serviceengineerid = prefs.getString(SharedPrefKey.SERVICEENGINEERID);
      serviceengineername = prefs.getString(SharedPrefKey.SERVICEENGINEERNAME);
      installationpending = prefs.getString(SharedPrefKey.INSTALLATIONPENDING);
      installationdone = prefs.getString(SharedPrefKey.INSTALLATIONDONE);
      servicepending = prefs.getString(SharedPrefKey.SERVICEPENDING);
      servicedone = prefs.getString(SharedPrefKey.SERVICEDONE);
    });
    print("this is service engineer id");
    print(serviceengineerid);
  }
}
