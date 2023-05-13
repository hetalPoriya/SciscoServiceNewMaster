import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:location/location.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage/ServiceEngDashBoard.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EngineerLocation extends StatefulWidget {
  @override
  _EngineerLocationState createState() => _EngineerLocationState();
}

class _EngineerLocationState extends State<EngineerLocation> {
  SharedPreferences prefs;
  bool isLogin;
  var serviceengineerid;
  var serviceengineername;
  String installationpending;
  String installationdone;
  String servicepending;
  String servicedone;
  Location location;
  LocationData currentLocation;
  double _latitude = 0;
  double _longitude = 0;

  @override
  void initState() {
    initPrefs();
    setInitialLocation();
//    serviceform();
    super.initState();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppTheme.textcolor,
        ),
        title: Text(
          "Location",
          textAlign: TextAlign.start,
          maxLines: 2,
          style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 19,
              color: Colors.black,
              fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              Get.back();
              // navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext ctx) => ServiceEngDashboard(isLogin, serviceengineerid, serviceengineername, installationpending, installationdone, servicepending, servicedone)));
            }),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
    );
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

  void setInitialLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    var platform = "Android";
    if (Platform.isAndroid) {
      // Android-specific code
      platform = "Android";
    } else if (Platform.isIOS) {
      // iOS-specific code
      platform = "IOS";
    }
    _locationData = await location.getLocation();
    location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      _latitude = currentLocation.latitude;
      _longitude = currentLocation.longitude;
      driver_location_change(currentLocation.latitude.toString(),
          currentLocation.longitude.toString());
      // print("CURRENTLOCATION : "+currentLocation.latitude.toString()+""+currentLocation.longitude.toString());
    });
  }

  Future<Response> driver_location_change(
      String latitude, String longitude) async {
    bool isDeviceOnline = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();
        Map<String, dynamic> formData = {
          "service_engineer_id":
              prefs.getString(SharedPrefKey.SERVICEENGINEERID),
          "latitude": latitude,
          "longitude": longitude,
        };
        var changelocation = FormData.fromMap(formData);

        print(formData);
        Response response =
            await baseApi.dio.post(engineerLocationUrl, data: changelocation);

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE service form :" + parsed.toString());
          String error = parsed["error"].toString();

          if (error == "1") {
            // displayToast("You are Online Now",context);

            // setState(() {
            //   if (commonResponse.live_status == "0") {
            //     prefs.setBool(SharedPrefKey.ISONLINE, false);
            //     switch_status = false;
            //     live_statusStr = 'Offline';
            //   } else {
            //     prefs.setBool(SharedPrefKey.ISONLINE, true);
            //     switch_status = true;
            //     live_statusStr = 'Online';
            //   }
            //   /* if (commonResponse.live_status == "0") {
            //     prefs.setBool(SharedPrefKey.ISONLINE, false);
            //   } else {
            //     prefs.setBool(SharedPrefKey.ISONLINE, true);
            //   }*/
            // });
          } else {
            // String errorMsg = commonResponse.error_msg;
            //  displayToast(errorMsg.toString(), context);
          }
        }

        return response;
      } catch (e) {
        //   print("RESPOONSE:" + e.toString());

        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }
}
