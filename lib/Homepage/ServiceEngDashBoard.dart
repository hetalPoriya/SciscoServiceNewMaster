import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:location/location.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Utils/app_assets.dart';
import 'package:scisco_service/Utils/sizeconfig.dart';
import 'package:scisco_service/googleMapScreen/googleMapsScreen.dart';
import 'package:scisco_service/Homepage/installationreqdone.dart';
import 'package:scisco_service/Homepage/installationreqpending.dart';
import 'package:scisco_service/Homepage/servicerequestdone.dart';
import 'package:scisco_service/Homepage/servicerequestpending.dart';
import 'package:scisco_service/LoginSignup/Login/login_screen.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/models/CustomerList.dart';
import 'package:scisco_service/models/getCustomer.dart';
import 'package:scisco_service/models/reasonList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceEngDashboard extends StatefulWidget {
  bool isLogin;
  String serviceengineerid;
  String serviceengineername;
  String installationpending;
  String installationdone;
  String servicepending;
  String servicedone;

  ServiceEngDashboard(
      this.isLogin,
      this.serviceengineerid,
      this.serviceengineername,
      this.installationpending,
      this.installationdone,
      this.servicepending,
      this.servicedone);

  @override
  _ServiceEngDashboardState createState() => _ServiceEngDashboardState(
      this.isLogin,
      this.serviceengineerid,
      this.serviceengineername,
      this.installationpending,
      this.installationdone,
      this.servicepending,
      this.servicedone);
}

class _ServiceEngDashboardState extends State<ServiceEngDashboard> {
  bool checkOut = true;
  SharedPreferences prefs;
  bool isLogin;
  bool startday = false;
  bool finishday = false;
  bool markedin = false;
  bool markedout = false;
  var serviceengineerid;
  var serviceengineername;
  String installationpending;
  String installationdone;
  String servicepending;
  String servicedone;
  List<String> customerList = [];
  List<Customerss> newCustomerList = [];
  List nameCustomer = [];
  List reasonList = [];
  String selectedReason;

  int count = 0;
  String selectedcustomer;
  List<Customers> getcustomerlist = [];
  Location location;
  LocationData currentLocation;
  double _latitude = 0;
  double _longitude = 0;

  // int markin = 0;
  // int markout = 0;
  int shiftended = 0;
  final msgCtrl = TextEditingController();

  _ServiceEngDashboardState(
      this.isLogin,
      this.serviceengineerid,
      this.serviceengineername,
      this.installationpending,
      this.installationdone,
      this.servicepending,
      this.servicedone);

  @override
  void initState() {
    initPrefs();
    // markinapi();
    getLocationPermision();
    getReason();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    precacheImage(AssetImage(AppAssets.installationPending), context);
    precacheImage(AssetImage(AppAssets.servicePending), context);
    precacheImage(AssetImage(AppAssets.installationDone), context);
    precacheImage(AssetImage(AppAssets.serviceDone), context);
    precacheImage(AssetImage(AppAssets.punchIn), context);
    super.didChangeDependencies();
  }

  Future<Response> getCustomerList(String reason) async {
    bool isDeviceOnline = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //   bool isDeviceOnline = await checkConnection();
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    // progressDialog.show();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();
        Map<String, dynamic> formData = {
          "service_engineer_id":
              prefs.getString(SharedPrefKey.SERVICEENGINEERID),
          "reason": reason,
        };
        var CustomerFormData = FormData.fromMap(formData);

        print(formData);

        Response response =
            await baseApi.dio.post(oncustomerlist, data: CustomerFormData);

        var data = json.decode(response.data);
        var message = data["error"];
        var jsonResults = data['customers'] as List;

        if (response != null) {
          newCustomerList =
              jsonResults.map((place) => Customerss.fromJson(place)).toList();
          for (int i = 0; i < newCustomerList.length; i++) {
            var customernames = newCustomerList[i].name;

            nameCustomer.add(customernames);
          }
          print(nameCustomer.toList().toString());
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

  Future<Response> getReason() async {
    bool isDeviceOnline = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();

        Response response = await baseApi.dio.post(markin_reason);

        var data = json.decode(response.data);
        var message = data["error"];
        setState(() {
          reasonList = data['reasons'] as List;
        });

        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPONSE of get Reason list:" + parsed.toString());
        }
        return response;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = SizeConfig.safeBlockVertical * 55;
    final double itemWidth = size.width / 1.2;

    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          content: Text('Do you really want to exit'),
          actions: [
            TextButton(
              child: Text('Yes'),
              onPressed: () => Navigator.pop(c, true),
            ),
            TextButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppTheme.textcolor, //change your color here
          ),
          elevation: 0,
          title: Text(
            "Service Engineer Dashboard",
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
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 20, 0),
              child: Ink(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(241, 242, 243, 1.0),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0.3, 3),
                    child: IconButton(
                      icon: Icon(Icons.logout),
                      //style: ButtonStyle(color: Colors.black,),
                      onPressed: () async {
                        _logoutDialog();
                      },
                    ),
                  )),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            BaseApi baseApi = new BaseApi();
            Map<String, dynamic> formData = {
              "service_engineer_id":
                  prefs.getString(SharedPrefKey.SERVICEENGINEERID),
            };
            var getCount = FormData.fromMap(formData);
            Response response = await baseApi.dio
                .post(getEngineerHomescreenCount, data: getCount);
            print('response $response');
            if (response != null) {
              final parsed = json.decode(response.data).cast<String, dynamic>();

              prefs.setString(SharedPrefKey.INSTALLATIONPENDING,
                  parsed['installations_pending'].toString());
              prefs.setString(SharedPrefKey.INSTALLATIONDONE,
                  parsed['installations_done'].toString());
              prefs.setString(SharedPrefKey.SERVICEPENDING,
                  parsed['services_pending'].toString());
              prefs.setString(SharedPrefKey.SERVICEDONE,
                  parsed['services_done'].toString());

              initPrefs();
              setState(() {});
            }
          },
          child: Container(
              child: Padding(
            padding: const EdgeInsets.all(15),
            child: GridView(
              scrollDirection: Axis.vertical,
              children: [
                InkWell(
                  onTap: () {
                    navigator.push(
                      MaterialPageRoute(
                        builder: (context) {
                          return InstallationRequestPending();
                        },
                      ),
                    );
                  },
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 0.0),
                      child: DashboardCard(
                        imageUrl: AppAssets.installationPending,
                        text: "Installation Pending",
                        number: installationpending,
                      )),
                ),
                InkWell(
                  onTap: () {
                    navigator.push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ServiceRequestPending();
                        },
                      ),
                    );
                  },
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 15.0, 0.0),
                      child: DashboardCard(
                        imageUrl: AppAssets.servicePending,
                        text: "Service Pending",
                        number: servicepending,
                      )),
                ),
                InkWell(
                  onTap: () {
                    navigator.push(
                      MaterialPageRoute(
                        builder: (context) {
                          return Installationreq();
                        },
                      ),
                    );
                  },
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 0.0),
                      child: DashboardCard(
                        imageUrl: AppAssets.installationDone,
                        text: "Installation Done",
                        number: installationdone,
                      )),
                ),
                InkWell(
                  onTap: () {
                    navigator.push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ServiceRequest();
                        },
                      ),
                    );
                  },
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 15.0, 0.0),
                      child: DashboardCard(
                        imageUrl: AppAssets.serviceDone,
                        text: "Service Done",
                        number: servicedone,
                      )),
                ),
                // InkWell(
                //   onTap: () {
                //     navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) {
                //           return EditEngProfile();
                //         },
                //       ),
                //     );
                //   },
                //   child: DashboardCard(
                //     imageUrl: "assets/images/dashboard/userprofile.png",
                //     text: "Edit your Profile",
                //   ),
                // ),
                InkWell(
                  onTap: () {
                    // Get.to(() => MapsScreen());
                    navigator.push(MaterialPageRoute(
                        builder: (BuildContext ctx) => MapsScreen()));
                    setInitialLocation();
                    setState(() => startday = !startday);
                    setState(() => finishday = !finishday);
                  },
                  child: SizedBox(
                    width: Get.width,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 0.0),
                        child: DashboardCard(
                          imageUrl: AppAssets.punchIn,
                          text: "Punch In",
                        )),
                  ),
                ),
              ],
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: (itemWidth / itemHeight)),
            ),
          )),
        ),
      ),
    );
  }

  Future<Response> markinapi() async {
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
          "service_engineer_id":
              prefs.getString(SharedPrefKey.SERVICEENGINEERID),
          "reason": "Service",
        };
        var CustomerFormData = FormData.fromMap(formData);

        print(formData);

        Response response =
            await baseApi.dio.post(oncustomerlist, data: CustomerFormData);

        if (response != null) {
          progressDialog.dismiss();
          final parsed = json.decode(response.data).cast<String, dynamic>();

          print("RESPONSE of get customers list:" + parsed.toString());
          String error = parsed["error"];

          if (error == "1") {
            CustomerList getcustomerrespo = CustomerList.fromJson(parsed);
            setState(() {
              getcustomerlist = getcustomerrespo.customers;
            });
            for (int i = 0; i < getcustomerlist.length; i++) {
              var customernames = getcustomerlist[i].name;
              print(customernames);
              customerList.add(customernames);
            }
            print(customerList);
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
    location.changeSettings(
        //     interval: 1,
        //     //interval: 10,
        //     accuracy: LocationAccuracy.high,
        //     distanceFilter: 30
        //     //distanceFilter: 200000
        );

    location.onLocationChanged.listen((LocationData cLoc) async {
      count = count + 1;
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it

      currentLocation = cLoc;
      _latitude = currentLocation.latitude;
      _longitude = currentLocation.longitude;

      if (shiftended == 0 && prefs.getInt(SharedPrefKey.ISPUNCHEDIN) == 1) {
        if (count == 30) {
          print('COUNT $count');
          count = 0;

          if (lastMapLatitude != mapLatitude)
            await driver_location_change(currentLocation.latitude.toString(),
                currentLocation.longitude.toString());
        } else {
          lastMapLatitude = cLoc.latitude;
          lastMapLongitude = cLoc.longitude;
        }
      }
    });
    // Timer.periodic(Duration(seconds: 30), (Timer t) =>     location.onLocationChanged.listen((LocationData cLoc) {
    //   // cLoc contains the lat and long of the
    //   // current user's position in real time,
    //   // so we're holding on to it
    //
    //   currentLocation = cLoc;
    //   _latitude = currentLocation.latitude;
    //   _longitude = currentLocation.longitude;
    //
    //   print('LAT $_latitude');
    //   print('LAT $_longitude');
    //   if (shiftended == 0 && prefs.getInt(SharedPrefKey.ISPUNCHEDIN) == 1) {
    //     driver_location_change(currentLocation.latitude.toString(),
    //         currentLocation.longitude.toString());
    //   }
    // }););
  }

  Future<Response> driver_location_change(
      String latitude, String longitude) async {
    bool isDeviceOnline = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();
        if (shiftended == 0) {
          Map<String, dynamic> formData = {
            "service_engineer_id":
                prefs.getString(SharedPrefKey.SERVICEENGINEERID),
            "latitude": latitude,
            "longitude": longitude,
            "mark_in": 0,
            "mark_out": 0,
            "message": msgCtrl.text.toString(),
            "shift_ended": shiftended
          };

          var changelocation = FormData.fromMap(formData);

          print(formData);

          Response response =
              await baseApi.dio.post(engineerLocationUrl, data: changelocation);
          print('Resonse ${response}');

          if (response != null) {
            // List<dynamic> body = jsonDecode(response.data);

            final parsed = json.decode(response.data).cast<String, dynamic>();
            //        print("RESPOONSE service form :" + parsed.toString());
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
              //    String errorMsg = commonResponse.error_msg;
              //  displayToast(errorMsg.toString(), context);
            }
          }

          return response;
        }
      } catch (e) {
        //   print("RESPOONSE:" + e.toString());

        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      //  displayToast("Please connect to internet", context);
      return null;
    }
  }

  Future<Response> onmarkin(String latitude, String longitude) async {
    bool isDeviceOnline = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();
        if (shiftended == 0) {
          Map<String, dynamic> formData = {
            "service_engineer_id":
                prefs.getString(SharedPrefKey.SERVICEENGINEERID),
            "latitude": latitude,
            "longitude": longitude,
            "mark_in": 1,
            "mark_out ": 0,
            "message ": msgCtrl.text.toString(),
            "shift_ended": shiftended
          };
          var changelocation = FormData.fromMap(formData);

          print(formData);
          Response response =
              await baseApi.dio.post(engineerLocationUrl, data: changelocation);
          print(response);
          if (response != null) {
            // List<dynamic> body = jsonDecode(response.data);

            final parsed = json.decode(response.data).cast<String, dynamic>();
            //        print("RESPOONSE service form :" + parsed.toString());
            String error = parsed["error"].toString();

            if (error == "1") {
            } else {
              //    String errorMsg = commonResponse.error_msg;
              //  displayToast(errorMsg.toString(), context);
            }
          }

          return response;
        }
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

  Future<Response> onfinishday(String latitude, String longitude) async {
    bool isDeviceOnline = true;
    shiftended = 1;
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
          "mark_in": 0,
          "mark_out ": 0,
          "message ": msgCtrl.text.toString(),
          "shift_ended": shiftended
        };
        var changelocation = FormData.fromMap(formData);

        print(formData);
        Response response =
            await baseApi.dio.post(engineerLocationUrl, data: changelocation);
        print(response);
        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);

          final parsed = json.decode(response.data).cast<String, dynamic>();
          //        print("RESPOONSE service form :" + parsed.toString());
          String error = parsed["error"].toString();
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
                navigator..pop();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove(SharedPrefKey.SERVICEENGINEERID);
                prefs.remove(SharedPrefKey.SERVICEENGINEERNAME);
                prefs.remove(SharedPrefKey.ISLOGEDIN);
                prefs.remove(SharedPrefKey.ISPUNCHEDIN);
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

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    Key key,
    @required this.imageUrl,
    @required this.text,
    this.number,
  }) : super(key: key);

  final String imageUrl;
  final String text;
  final String number;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        //height: 500,
        //height: SizeConfig.safeBlockVertical*100,
        child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppTheme.white,
              boxShadow: [
                new BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: SizeConfig.safeBlockVertical * 15,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(imageUrl))),
                    // child: Image.asset(
                    //   imageUrl,
                    // ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                      child: Text(
                        text.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontFamily: "PriximaNova",
                            fontWeight: FontWeight.bold,
                            //overflow: TextOverflow.ellipsis,
                            height: 1.2),
                      ))
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: number != null
                ? Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 108, 98),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    // color: Colors.redAccent,
                    child: Text(
                      " " + number,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Text(""),
          ),
        ],
      ),
    ));
  }
}
