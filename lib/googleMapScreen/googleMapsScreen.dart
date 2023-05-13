// import 'dart:async';
// import 'dart:convert';
//
// import 'package:ars_progress_dialog/ars_progress_dialog.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/route_manager.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:location/location.dart';
// import 'package:scisco_service/Api/BaseApi.dart';
// import 'package:scisco_service/Homepage//ServiceEngDashBoard.dart';
// import 'package:scisco_service/Homepage/installationform.dart';
// import 'package:scisco_service/Homepage/preinstallationform.dart';
// import 'package:scisco_service/Homepage/servicereqdetail.dart';
// import 'package:scisco_service/Homepage/servicerequestdone.dart';
// import 'package:scisco_service/Homepage/webserviceform.dart';
// import 'package:scisco_service/LoginSignup/Welcome/welcome_screen.dart';
// import 'package:scisco_service/Utils/CommonLogic.dart';
// import 'package:scisco_service/Utils/CommonStrings.dart';
// import 'package:scisco_service/app_theme.dart';
// import 'package:scisco_service/markinMarkout/markInScreen.dart';
// import 'package:scisco_service/models/ServicereqDetail.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
//
// import '../Homepage/installationdetails.dart';
//
// class MapsScreen extends StatefulWidget {
//   MapsScreen({
//     Key key,
//   }) : super(key: key);
//
//   @override
//   State<MapsScreen> createState() => _MapsScreenState();
// }
//
// class _MapsScreenState extends State<MapsScreen> {
//   GoogleMapController _controller;
//   Location location = new Location();
//   LocationData currentLocation;
//   int shiftended = 0;
//   final msgCtrl = TextEditingController();
//   bool isPunchedIn = false;
//   bool startPunchIn = false;
//   int punchInOrNot = 0;
//   bool isLoading = false;
//   bool markInProcessing = false;
//   BitmapDescriptor yellowMapMarker;
//   BitmapDescriptor blueMapMarker;
//   BitmapDescriptor magentaMapMarker;
//   BitmapDescriptor greenMapMarker;
//   bool _serviceEnabled;
//   PermissionStatus _permissionGranted;
//   LocationData _locationData;
//   LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
//   Set<Marker> markers = {};
//   Set<Polyline> polylines = {};
//   List<LatLng> polylineCoordinates = [];
//   PolylinePoints polylinePoints;
//   SharedPreferences prefs;
//   var isPunchIn;
//
//   bool isLogin;
//   var serviceengineerid;
//   var serviceengineername;
//   String installationpending;
//   String installationdone;
//   String servicepending;
//   String servicedone;
//
//   Future<void> initPrefs() async {
//     prefs = await SharedPreferences.getInstance();
//     isLogin = prefs.getBool(SharedPrefKey.ISLOGEDIN);
//     if (isLogin == null) {
//       isLogin = false;
//     }
//     setState(() {
//       print('pucnh ${prefs.getInt(SharedPrefKey.ISPUNCHEDIN)}');
//       punchInOrNot = prefs.getInt(SharedPrefKey.ISPUNCHEDIN);
//       serviceengineerid = prefs.getString(SharedPrefKey.SERVICEENGINEERID);
//       serviceengineername = prefs.getString(SharedPrefKey.SERVICEENGINEERNAME);
//       installationpending = prefs.getString(SharedPrefKey.INSTALLATIONPENDING);
//       installationdone = prefs.getString(SharedPrefKey.INSTALLATIONDONE);
//       servicepending = prefs.getString(SharedPrefKey.SERVICEPENDING);
//       servicedone = prefs.getString(SharedPrefKey.SERVICEDONE);
//       prefs.setInt(SharedPrefKey.MARKER_COUNTS, 2);
//     });
//     print("this is service engineer id:" + serviceengineerid);
//   }
//
//   void setCustomMarker() {
//     yellowMapMarker = BitmapDescriptor.defaultMarkerWithHue(
//       BitmapDescriptor.hueYellow,
//     );
//
//     blueMapMarker = BitmapDescriptor.defaultMarkerWithHue(
//       BitmapDescriptor.hueBlue,
//     );
//
//     greenMapMarker = BitmapDescriptor.defaultMarkerWithHue(
//       BitmapDescriptor.hueGreen,
//     );
//
//     magentaMapMarker = BitmapDescriptor.defaultMarkerWithHue(
//       BitmapDescriptor.hueMagenta,
//     );
//   }
//
//   void setPolylines(polyLati, polyLongi) async {
//     if (!isPunchedIn) {
//       return;
//     }
//     polylineCoordinates.add(LatLng(polyLati, polyLongi));
//
//     if (this.mounted) {
//       setState(() {
//         polylines.add(Polyline(
//           polylineId: PolylineId('polyline'),
//           color: Color(0xff00ff00),
//           points: polylineCoordinates,
//         ));
//       });
//     }
//   }
//
//   void _onMapCreated(GoogleMapController _cntlr) async {
//     setState(() {
//       isLoading = true;
//     });
//     _controller = _cntlr;
//
//     // _locationData = await location.getLocation();
//     // print('Location $_locationData');
//     // var time =
//     // DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString();
//     location.changeSettings(
//         interval: 200000,
//         //interval: 10,
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 10
//         //distanceFilter: 200000
//         );
//     location.onLocationChanged.listen((LocationData cLoc) async {
//       currentLocation = cLoc;
//       setPolylines(currentLocation.latitude, currentLocation.longitude);
//       mapLatitude = currentLocation.latitude;
//       mapLongitude = currentLocation.longitude;
//
//       await _controller.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(target: LatLng(mapLatitude, mapLongitude), zoom: 15),
//         ),
//       );
//       print(
//         "Engineer id " + prefs.getString(SharedPrefKey.SERVICEENGINEERID),
//       );
//       setState(() {
//         isLoading = false;
//       });
//
//       // box.read('isPunchIn') == 0
//       //     ? setState(() {
//       //         markers.addAll({
//       //           ...markers,
//       //           Marker(
//       //             icon: magentaMapMarker,
//       //             markerId: MarkerId('1'),
//       //             position: LatLng(mapLatitude, mapLongitude),
//       //             infoWindow: InfoWindow(
//       //               title: 'Punch In today',
//       //               // snippet: 'time: $time',
//       //             ),
//       //           ),
//       //         });
//       //         onPunchInApi(mapLatitude.toString(), mapLongitude.toString());
//       //         box.write('isPunchIn', 1);
//       //         print("isPunchIn");
//       //         print(box.read('isPunchIn'));
//       //         Get.snackbar(
//       //           "Punched In",
//       //           "time: ${0}" + box.read('isPunchIn'),
//       //           duration: Duration(seconds: 6),
//       //           backgroundColor: Colors.blue,
//       //           colorText: Colors.white,
//       //           margin: EdgeInsets.all(10),
//       //           padding: EdgeInsets.all(30),
//       //           snackPosition: SnackPosition.BOTTOM,
//       //         );
//       //       })
//       //     : null;
//     });
//     location.enableBackgroundMode(enable: true);
//   }
//
//   markOutOnTheMap(int currentCount) {
//     print('mark out ${prefs.getString(SharedPrefKey.MARK_IN_REASON)}');
//     //if (this.mounted) {
//     setState(() {
//       markers.addAll({
//         ...markers,
//         Marker(
//           markerId: MarkerId(currentCount.toString()),
//           icon: greenMapMarker,
//           position: LatLng(mapLatitude, mapLongitude),
//           infoWindow: InfoWindow(
//             title: 'Mark' + currentCount.toString() + '(OUT)',
//             snippet:
//                 //"Completed "
//                 "Completed " + prefs.getString(SharedPrefKey.MARK_IN_REASON),
//           ),
//         ),
//       });
//       print("map markers" + markers.toString());
//       _onMapCreated(_controller);
//     });
//     // }
//   }
//
//   void punchOutOnTheMap(currentCount) {
//     if (this.mounted) {
//       setState(() {
//         markers.addAll({
//           ...markers,
//           Marker(
//             markerId: MarkerId(currentCount.toString()),
//             icon: blueMapMarker,
//             position: LatLng(mapLatitude, mapLongitude),
//             infoWindow: InfoWindow(
//               title: 'Punch Out',
//               snippet: 'Time' +
//                   DateTime.now().hour.toString() +
//                   ":" +
//                   DateTime.now().minute.toString(),
//             ),
//           ),
//         });
//         print("The markers are" + markers.toString());
//       });
//     }
//   }
//
//   markInOnTheMap(int currentCount) {
//     if (this.mounted) {
//       setState(() {
//         markers.addAll({
//           ...markers,
//           Marker(
//             markerId: MarkerId(currentCount.toString()),
//             icon: yellowMapMarker,
//             position: LatLng(mapLatitude, mapLongitude),
//             infoWindow: InfoWindow(
//               title: 'Mark' + currentCount.toString() + '(IN)',
//               snippet: "Started Work",
//             ),
//           ),
//         });
//         print("The markers are" + markers.toString());
//       });
//     }
//   }
//
//   Future<Response> getDetailsApi(var mapLatitude, var mapLongitude) async {
//     bool isDeviceOnline = true;
//
//     if (isDeviceOnline) {
//       try {
//         BaseApi baseApi = new BaseApi();
//         print('iisPunchedIn ${isPunchedIn}');
//         Map<String, dynamic> formData = isPunchedIn
//             ? {
//                 "service_engineer_id":
//                     prefs.getString(SharedPrefKey.SERVICEENGINEERID),
//                 "latitude": mapLatitude,
//                 "longitude": mapLongitude,
//               }
//             : {
//                 "service_engineer_id":
//                     prefs.getString(SharedPrefKey.SERVICEENGINEERID),
//               };
//         var getData = FormData.fromMap(formData);
//
//         Response response =
//             await baseApi.dio.post(engineerLocationUrl, data: getData);
//
//         print('PUNCINAPI ${response.data}');
//
//         if (response != null) {
//           // List<dynamic> body = jsonDecode(response.data);
//           final parsed = json.decode(response.data).cast<String, dynamic>();
//           setState(() {
//             if (parsed["punched_in"] == 0 && parsed["punched_out"] == 0) {
//               setState(() {
//                 isPunchedIn = false;
//                 startPunchIn = true;
//               });
//             } else if (parsed["punched_in"] == 1 &&
//                 parsed["punched_out"] == 0) {
//               setState(() {
//                 isPunchedIn = true;
//                 startPunchIn = true;
//               });
//             } else {
//               setState(() {
//                 startPunchIn = false;
//               });
//             }
//             if (parsed["marked_in"] == 0) {
//               setState(() {
//                 markInProcessing = false;
//               });
//             } else {
//               setState(() {
//                 markInProcessing = true;
//               });
//             }
//           });
//
//           print("Get API Details");
//           print('isPunch In or not $isPunchedIn');
//           print(markInProcessing);
//         }
//         return response;
//       } catch (e) {
//         // print("RESPOONSE:" + e.toString());
//         displayToast("Something went wrong", context);
//         return null;
//       }
//     } else {
//       displayToast("Please connect to internet", context);
//       return null;
//     }
//   }
//
//   Future<Response> onPunchInApi(String latitude, String longitude) async {
//     bool isDeviceOnline = true;
//     print("inside punch in");
//     var time =
//         DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString();
//     if (isDeviceOnline) {
//       try {
//         BaseApi baseApi = new BaseApi();
//         if (shiftended == 0) {
//           Map<String, dynamic> formData = {
//             "service_engineer_id":
//                 prefs.getString(SharedPrefKey.SERVICEENGINEERID),
//             "latitude": latitude,
//             "longitude": longitude,
//             "shift_ended": shiftended
//           };
//           var changelocation = FormData.fromMap(formData);
//
//           Response response =
//               await baseApi.dio.post(engineerLocationUrl, data: changelocation);
//           print(response);
//           markers.addAll({
//             ...markers,
//             Marker(
//               icon: magentaMapMarker,
//               markerId: MarkerId('1'),
//               position: LatLng(mapLatitude, mapLongitude),
//               infoWindow: InfoWindow(
//                 title: 'Punch In today',
//                 snippet: 'time: $time',
//               ),
//             ),
//           });
//           if (response != null) {
//             // List<dynamic> body = jsonDecode(response.data);
//             final parsed = json.decode(response.data).cast<String, dynamic>();
//             print("RESPOONSE punch in service form :" + parsed.toString());
//             String error = parsed["error"].toString();
//             print('satus ${parsed["status"]}');
//
//             if (parsed['status'] == "You've already punched out today.") {
//               Fluttertoast.showToast(msg: "You've already punched out today.");
//               Get.back();
//               Get.offAll(() => ServiceEngDashboard(
//                   prefs.getBool(SharedPrefKey.ISLOGEDIN),
//                   prefs.getString(SharedPrefKey.SERVICEENGINEERID),
//                   prefs.getString(SharedPrefKey.SERVICEENGINEERNAME),
//                   prefs.getString(SharedPrefKey.INSTALLATIONPENDING),
//                   prefs.getString(SharedPrefKey.INSTALLATIONDONE),
//                   prefs.getString(SharedPrefKey.SERVICEPENDING),
//                   prefs.getString(SharedPrefKey.SERVICEDONE)));
//             } else {
//               Get.back();
//               await getDetailsApi(mapLatitude, mapLongitude);
//               setState(() {
//                 prefs.setInt(SharedPrefKey.ISPUNCHEDIN, 1);
//                 punchInOrNot = prefs.getInt(SharedPrefKey.ISPUNCHEDIN);
//               });
//               Get.snackbar(
//                 "Punched In",
//                 "Click on 'Punch out' for punch out",
//                 duration: Duration(seconds: 6),
//                 backgroundColor: Colors.blue,
//                 colorText: Colors.white,
//                 margin: EdgeInsets.all(10),
//                 padding: EdgeInsets.all(30),
//                 snackPosition: SnackPosition.BOTTOM,
//               );
//               Get.offAll(() => ServiceEngDashboard(
//                   prefs.getBool(SharedPrefKey.ISLOGEDIN),
//                   prefs.getString(SharedPrefKey.SERVICEENGINEERID),
//                   prefs.getString(SharedPrefKey.SERVICEENGINEERNAME),
//                   prefs.getString(SharedPrefKey.INSTALLATIONPENDING),
//                   prefs.getString(SharedPrefKey.INSTALLATIONDONE),
//                   prefs.getString(SharedPrefKey.SERVICEPENDING),
//                   prefs.getString(SharedPrefKey.SERVICEDONE)));
//             }
//
//             if (error == "1") {
//             } else {
//               //    String errorMsg = commonResponse.error_msg;
//               //  displayToast(errorMsg.toString(), context);
//             }
//           }
//           return response;
//         }
//       } catch (e) {
//         // print("RESPOONSE:" + e.toString());
//         displayToast("Something went wrong", context);
//         return null;
//       }
//     } else {
//       displayToast("Please connect to internet", context);
//       return null;
//     }
//   }
//
//   Future<Response> onmarkinApi(double latitude, double longitude) async {
//     bool isDeviceOnline = true;
//     print('CUSID');
//     print(prefs.getString(SharedPrefKey.COSTUMERID));
//
//     // bool isDeviceOnline = await checkConnection();
//     if (isDeviceOnline) {
//       try {
//         BaseApi baseApi = new BaseApi();
//         if (shiftended == 0) {
//           Map<String, dynamic> formData = {
//             "service_engineer_id":
//                 prefs.getString(SharedPrefKey.SERVICEENGINEERID),
//             "latitude": latitude.toString(),
//             "longitude": longitude.toString(),
//             "mark_in": 1,
//             "customer_id":
//                 prefs.getString(SharedPrefKey.SELECTED_CUSTOMER) ?? "",
//             "message": prefs.getString(SharedPrefKey.MARK_IN_REASON),
//           };
//           var changelocation = FormData.fromMap(formData);
//
//           Response response =
//               await baseApi.dio.post(engineerLocationUrl, data: changelocation);
//           print(response);
//           if (response != null) {
//             var reason = prefs.getString(SharedPrefKey.MARK_IN_REASON);
//             var productId = prefs.getString(SharedPrefKey.PRODUCTID);
//             var customerId = prefs.getString(SharedPrefKey.SELECTED_CUSTOMER);
//             var assignedProductId =
//                 prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID);
//             var serviceReason = prefs.getString(SharedPrefKey.SERVICEREASON);
//             var serviceReqId = prefs.getString(SharedPrefKey.SERVICEREQID);
//
//             // List<dynamic> body = jsonDecode(response.data);
//
//             final parsed = json.decode(response.data).cast<String, dynamic>();
//             print("RESPONSE IS OF THE MARKIN API" + parsed.toString());
//             //        print("RESPOONSE service form :" + parsed.toString());
//             String error = parsed["error"].toString();
//
//             if (reason == 'Pre Installation') {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                     builder: ((context) => PreInstallationForm(
//                         customerId, productId, assignedProductId))),
//                 (route) => false,
//               );
//             }
//             if (reason == 'Installation') {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(
//                     builder: ((context) => InstallationForm(
//                         customerId, productId, assignedProductId))),
//                 (route) => false,
//               );
//             }
//             if (reason == 'Service') {
//               if (serviceReason == 'Resolved on call') {
//                 return Get.dialog(AlertDialog(
//                   title:
//                       Text("Are you sure you want to submit Resolved on call"),
//                   actions: [
//                     ElevatedButton(
//                       onPressed: () async {
//                         Get.back();
//                         // print('Called');
//                         // Get.off(() => ServiceForm(
//                         //     customer_id,
//                         //     product_id,
//                         //     assignedProductId));
//                         // servicereqdetail();
//                         await serviceresponse(serviceReqId, "Resolved on call");
//                         Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ServiceRequest()),
//                             (route) => false);
//                       },
//                       child: Text(
//                         "Yes",
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => {
//                         Get.back(),
//                       },
//                       child: Text(
//                         "No",
//                       ),
//                     )
//                   ],
//                 ));
//               } else {
//                 await serviceresponse(serviceReqId, "Site visit required");
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(
//                       builder: ((context) =>
//                           WebServiceForm(customerId, productId, serviceReqId))),
//                   (route) => false,
//                 );
//               }
//
//               // Navigator.pushAndRemoveUntil(
//               //   context,
//               //   MaterialPageRoute(
//               //       builder: ((context) => WebServiceForm(
//               //           selectedcustomerId,
//               //           selectedProductId,
//               //           prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID)))),
//               //   (route) => false,
//               // );
//             }
//
//             if (error == "1") {
//               print(markInProcessing);
//             } else {
//               //    String errorMsg = commonResponse.error_msg;
//               //  displayToast(errorMsg.toString(), context);
//             }
//           }
//
//           return response;
//         }
//       } catch (e) {
//         //   print("RESPOONSE:" + e.toString());
//
//         displayToast("Something went wrong", context);
//         return null;
//       }
//     } else {
//       displayToast("Please connect to internet", context);
//       return null;
//     }
//   }
//
//   Future<Response> onmarkoutApi(String latitude, String longitude) async {
//     bool isDeviceOnline = true;
//
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//     // bool isDeviceOnline = await checkConnection();
//     if (isDeviceOnline) {
//       try {
//         BaseApi baseApi = new BaseApi();
//         if (shiftended == 0) {
//           Map<String, dynamic> formData = {
//             "service_engineer_id":
//                 prefs.getString(SharedPrefKey.SERVICEENGINEERID),
//             "latitude": latitude,
//             "longitude": longitude,
//             "mark_in": 0,
//             "mark_out": 1,
//             "message":
//                 "Marked out at " + DateFormat('hh:mm').format(DateTime.now()),
//             "shift_ended": shiftended
//           };
//           var changelocation = FormData.fromMap(formData);
//
//           print(formData);
//           Response response =
//               await baseApi.dio.post(engineerLocationUrl, data: changelocation);
//           print(response);
//           if (response != null) {
//             // List<dynamic> body = jsonDecode(response.data);
//
//             final parsed = json.decode(response.data).cast<String, dynamic>();
//             //        print("RESPOONSE service form :" + parsed.toString());
//             String error = parsed["error"].toString();
//             if (this.mounted) {
//               setState(() {
//                 markInProcessing = false;
//               });
//             }
//             if (error == "1") {
//             } else {
//               //    String errorMsg = commonResponse.error_msg;
//               //  displayToast(errorMsg.toString(), context);
//             }
//           }
//
//           return response;
//         }
//       } catch (e) {
//         //   print("RESPOONSE:" + e.toString());
//
//         displayToast("Something went wrong", context);
//         return null;
//       }
//     } else {
//       displayToast("Please connect to internet", context);
//       return null;
//     }
//   }
//
//   Future<Response> onPunchOutApi(String latitude, String longitude) async {
//     bool isDeviceOnline = true;
//     shiftended = 1;
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//     // bool isDeviceOnline = await checkConnection();
//     if (isDeviceOnline) {
//       try {
//         BaseApi baseApi = new BaseApi();
//         Map<String, dynamic> formData = {
//           "service_engineer_id":
//               prefs.getString(SharedPrefKey.SERVICEENGINEERID),
//           "latitude": latitude,
//           "longitude": longitude,
//           "mark_in": 0,
//           "mark_out ": 0,
//           "message ":
//               "PunchedOut " + DateFormat('hh:mm').format(DateTime.now()),
//           "shift_ended": shiftended
//         };
//         var changelocation = FormData.fromMap(formData);
//
//         print(formData);
//         Response response =
//             await baseApi.dio.post(engineerLocationUrl, data: changelocation);
//         print('PunchOur Api Response ${response}');
//         if (response != null) {
//           // List<dynamic> body = jsonDecode(response.data);
//
//           final parsed = json.decode(response.data).cast<String, dynamic>();
//           //        print("RESPOONSE service form :" + parsed.toString());
//           String error = parsed["error"].toString();
//         }
//
//         return response;
//       } catch (e) {
//         //   print("RESPOONSE:" + e.toString());
//
//         displayToast("Something went wrong", context);
//         return null;
//       }
//     } else {
//       displayToast("Please connect to internet", context);
//       return null;
//     }
//   }
//
//   //
//   // void getSharedInstance() async {
//   //   prefs = await SharedPreferences.getInstance();
//   //   prefs.setInt(SharedPrefKey.MARKER_COUNTS, 2);
//   // }
//
//   @override
//   void initState() {
//     getLocationPermision();
//     initPrefs();
//
//     _onMapCreated(_controller);
//     //  setCustomMarker();
//
//     polylinePoints = PolylinePoints();
//     // isPunchIn = prefs.getInt(SharedPrefKey.ISPUNCHEDIN);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: WillPopScope(
//         onWillPop: () => Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => ServiceEngDashboard(
//                     isLogin,
//                     serviceengineerid,
//                     serviceengineername,
//                     installationpending,
//                     installationdone,
//                     servicepending,
//                     servicedone)),
//             (route) => false),
//         child: Scaffold(
//           body: Stack(
//             children: [
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 bottom: 0,
//                 child: GoogleMap(
//                   polylines: polylines,
//                   mapType: MapType.normal,
//                   myLocationEnabled: true,
//                   mapToolbarEnabled: true,
//                   initialCameraPosition:
//                       CameraPosition(target: _initialcameraposition),
//                   onMapCreated: _onMapCreated,
//                   markers: markers,
//                 ),
//               ),
//               SlidingUpPanel(
//                 minHeight: 100,
//                 maxHeight: 100,
//                 panel: Center(
//                     child: isLoading == true
//                         ? Text("Loading..")
//                         : Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   (!markInProcessing && punchInOrNot == 1)
//                                       ? markInButtonPressed()
//                                       : Wrap();
//                                 },
//                                 child: Container(
//                                     width: 125,
//                                     height: 40,
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       color: (markInProcessing)
//                                           ? AppTheme.appColor.withOpacity(0.5)
//                                           : (punchInOrNot == 0)
//                                               ? AppTheme.appColor
//                                                   .withOpacity(0.5)
//                                               : AppTheme.appColor,
//                                     ),
//                                     child: Text(
//                                       "Mark In",
//                                       style: TextStyle(
//                                         fontFamily: AppTheme.fontName,
//                                         fontSize: 18,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w800,
//                                       ),
//                                     )),
//                               ),
//                               markInProcessing
//                                   ? InkWell(
//                                       onTap: () async {
//                                         int currentCount = prefs.getInt(
//                                             SharedPrefKey.MARKER_COUNTS);
//                                         print("Counte $currentCount");
//                                         currentCount++;
//
//                                         if (this.mounted) {
//                                           setState(() {
//                                             markInProcessing = false;
//                                           });
//                                         }
//                                         // TODO: HIT THE API HERE FOR MARKOUT
//                                         await onmarkoutApi(
//                                             mapLatitude.toString(),
//                                             mapLongitude.toString());
//
//                                         Get.dialog(
//                                           AlertDialog(
//                                             title: Text("Marked Out"),
//                                             content: Text(
//                                                 "You have been marked out successfully"),
//                                             actions: [
//                                               ElevatedButton(
//                                                 onPressed: () async {
//                                                   await markOutOnTheMap(
//                                                       currentCount);
//                                                   Get.back();
//                                                   Navigator.pushAndRemoveUntil(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             ServiceEngDashboard(
//                                                                 isLogin,
//                                                                 serviceengineerid,
//                                                                 serviceengineername,
//                                                                 installationpending,
//                                                                 installationdone,
//                                                                 servicepending,
//                                                                 servicedone),
//                                                       ),
//                                                       (route) => false);
//                                                 },
//                                                 child: Text(
//                                                   "OK",
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                       child: Container(
//                                           width: 125,
//                                           height: 40,
//                                           alignment: Alignment.center,
//                                           decoration: BoxDecoration(
//                                             color: (markInProcessing)
//                                                 ? AppTheme.appColor
//                                                 : AppTheme.appColor
//                                                     .withOpacity(0.5),
//                                           ),
//                                           child: Text(
//                                             "Mark Out",
//                                             style: TextStyle(
//                                               fontFamily: AppTheme.fontName,
//                                               fontSize: 18,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w800,
//                                             ),
//                                           )),
//                                     )
//                                   : (punchInOrNot == 1)
//                                       ? InkWell(
//                                           onTap: () {
//                                             var currentCount;
//                                             Get.dialog(AlertDialog(
//                                               title: Text(
//                                                   "Are you sure you want to Punch Out?"),
//                                               actions: [
//                                                 ElevatedButton(
//                                                   onPressed: () async {
//                                                     currentCount = prefs.getInt(
//                                                         SharedPrefKey
//                                                             .MARKER_COUNTS);
//                                                     currentCount++;
//                                                     punchOutOnTheMap(
//                                                         currentCount);
//                                                     await onPunchOutApi(
//                                                         mapLatitude.toString(),
//                                                         mapLongitude
//                                                             .toString());
//                                                     prefs.setInt(
//                                                         SharedPrefKey
//                                                             .ISPUNCHEDIN,
//                                                         0);
//                                                     if (this.mounted) {
//                                                       setState(() {
//                                                         isPunchedIn = false;
//                                                       });
//                                                     }
//                                                     Get.offAll(() => ServiceEngDashboard(
//                                                         prefs.getBool(
//                                                             SharedPrefKey
//                                                                 .ISLOGEDIN),
//                                                         prefs.getString(SharedPrefKey
//                                                             .SERVICEENGINEERID),
//                                                         prefs.getString(SharedPrefKey
//                                                             .SERVICEENGINEERNAME),
//                                                         prefs.getString(SharedPrefKey
//                                                             .INSTALLATIONPENDING),
//                                                         prefs.getString(
//                                                             SharedPrefKey
//                                                                 .INSTALLATIONDONE),
//                                                         prefs.getString(
//                                                             SharedPrefKey
//                                                                 .SERVICEPENDING),
//                                                         prefs.getString(
//                                                             SharedPrefKey
//                                                                 .SERVICEDONE)));
//                                                     // Get.offAll(
//                                                     //     () => WelcomeScreen());
//                                                     // await Get.back();
//                                                     // Get.back();
//                                                     Get.snackbar(
//                                                       "Punched Out",
//                                                       "Click on 'Punch in' for a new punch",
//                                                       duration:
//                                                           Duration(seconds: 6),
//                                                       backgroundColor:
//                                                           Colors.blue,
//                                                       colorText: Colors.white,
//                                                       margin:
//                                                           EdgeInsets.all(10),
//                                                       padding:
//                                                           EdgeInsets.all(30),
//                                                       snackPosition:
//                                                           SnackPosition.BOTTOM,
//                                                     );
//                                                   },
//                                                   child: Text(
//                                                     "Yes",
//                                                   ),
//                                                 ),
//                                                 ElevatedButton(
//                                                   onPressed: () => {
//                                                     Get.back(),
//                                                   },
//                                                   child: Text(
//                                                     "No",
//                                                   ),
//                                                 )
//                                               ],
//                                             ));
//                                           },
//                                           child: Container(
//                                             width: 125,
//                                             height: 40,
//                                             alignment: Alignment.center,
//                                             decoration: BoxDecoration(
//                                               color: Colors.red,
//                                             ),
//                                             child: Text(
//                                               "Punch Out",
//                                               style: TextStyle(
//                                                 fontFamily: AppTheme.fontName,
//                                                 fontSize: 18,
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w800,
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                       : InkWell(
//                                           onTap: () {
//                                             punchInOrNot = prefs.getInt(
//                                                 SharedPrefKey.ISPUNCHEDIN);
//
//                                             Get.dialog(AlertDialog(
//                                               title: Text(
//                                                   "Are you sure you want to Punch In?"),
//                                               actions: [
//                                                 ElevatedButton(
//                                                   onPressed: () async {
//                                                     if (this.mounted) {
//                                                       setState(() async {
//                                                         await onPunchInApi(
//                                                             mapLatitude
//                                                                 .toString(),
//                                                             mapLongitude
//                                                                 .toString());
//                                                         // Get.back();
//                                                         // Get.snackbar(
//                                                         //   "Punched In",
//                                                         //   "Click on 'Punch out' for punch out",
//                                                         //   duration: Duration(
//                                                         //       seconds: 6),
//                                                         //   backgroundColor:
//                                                         //       Colors.blue,
//                                                         //   colorText:
//                                                         //       Colors.white,
//                                                         //   margin:
//                                                         //       EdgeInsets.all(
//                                                         //           10),
//                                                         //   padding:
//                                                         //       EdgeInsets.all(
//                                                         //           30),
//                                                         //   snackPosition:
//                                                         //       SnackPosition
//                                                         //           .BOTTOM,
//                                                         // );
//                                                       });
//                                                     }
//                                                   },
//                                                   child: Text(
//                                                     "Yes",
//                                                   ),
//                                                 ),
//                                                 ElevatedButton(
//                                                   onPressed: () => {
//                                                     Get.back(),
//                                                   },
//                                                   child: Text(
//                                                     "No",
//                                                   ),
//                                                 )
//                                               ],
//                                             ));
//                                           },
//                                           child: Container(
//                                             width: 125,
//                                             height: 40,
//                                             alignment: Alignment.center,
//                                             decoration: BoxDecoration(
//                                               color: Colors.green,
//                                             ),
//                                             child: Text(
//                                               "Punch In",
//                                               style: TextStyle(
//                                                 fontFamily: AppTheme.fontName,
//                                                 fontSize: 18,
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w800,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                             ],
//                           )),
//                 // panel: Center(
//                 //   child: isLoading
//                 //       ? Text("Loading..")
//                 //       : startPunchIn
//                 //           ? Row(
//                 //               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 //               children: [
//                 //                 GestureDetector(
//                 //                   onTap: () {
//                 //                     (!markInProcessing && isPunchedIn)
//                 //                         ? markInButtonPressed()
//                 //                         : Wrap();
//                 //                   },
//                 //                   child: Container(
//                 //                       width: 125,
//                 //                       height: 40,
//                 //                       alignment: Alignment.center,
//                 //                       decoration: BoxDecoration(
//                 //                         color: (markInProcessing)
//                 //                             ? AppTheme.appColor.withOpacity(0.5)
//                 //                             : (!isPunchedIn)
//                 //                                 ? AppTheme.appColor
//                 //                                     .withOpacity(0.5)
//                 //                                 : AppTheme.appColor,
//                 //                       ),
//                 //                       child: Text(
//                 //                         "Mark In",
//                 //                         style: TextStyle(
//                 //                           fontFamily: AppTheme.fontName,
//                 //                           fontSize: 18,
//                 //                           color: Colors.white,
//                 //                           fontWeight: FontWeight.w800,
//                 //                         ),
//                 //                       )),
//                 //                 ),
//                 //                 markInProcessing
//                 //                     ? InkWell(
//                 //                         onTap: () async {
//                 //                           print('ENTER');
//                 //                           int currentCount = prefs.getInt(
//                 //                               SharedPrefKey.MARKER_COUNTS);
//                 //                           print("Counte $currentCount");
//                 //                           currentCount++;
//                 //
//                 //                           if (this.mounted) {
//                 //                             setState(() {
//                 //                               markInProcessing = false;
//                 //                             });
//                 //                           }
//                 //                           // TODO: HIT THE API HERE FOR MARKOUT
//                 //                           await onmarkoutApi(
//                 //                               mapLatitude.toString(),
//                 //                               mapLongitude.toString());
//                 //
//                 //                           Get.dialog(
//                 //                             AlertDialog(
//                 //                               title: Text("Marked Out"),
//                 //                               content: Text(
//                 //                                   "You have been marked out successfully"),
//                 //                               actions: [
//                 //                                 ElevatedButton(
//                 //                                   onPressed: () async {
//                 //                                     await markOutOnTheMap(
//                 //                                         currentCount);
//                 //                                     Get.back();
//                 //                                     Navigator
//                 //                                         .pushAndRemoveUntil(
//                 //                                             context,
//                 //                                             MaterialPageRoute(
//                 //                                               builder: (context) => ServiceEngDashboard(
//                 //                                                   isLogin,
//                 //                                                   serviceengineerid,
//                 //                                                   serviceengineername,
//                 //                                                   installationpending,
//                 //                                                   installationdone,
//                 //                                                   servicepending,
//                 //                                                   servicedone),
//                 //                                             ),
//                 //                                             (route) => false);
//                 //                                   },
//                 //                                   child: Text(
//                 //                                     "OK",
//                 //                                   ),
//                 //                                 )
//                 //                               ],
//                 //                             ),
//                 //                           );
//                 //                         },
//                 //                         child: Container(
//                 //                             width: 125,
//                 //                             height: 40,
//                 //                             alignment: Alignment.center,
//                 //                             decoration: BoxDecoration(
//                 //                               color: (markInProcessing)
//                 //                                   ? AppTheme.appColor
//                 //                                   : AppTheme.appColor
//                 //                                       .withOpacity(0.5),
//                 //                             ),
//                 //                             child: Text(
//                 //                               "Mark Out",
//                 //                               style: TextStyle(
//                 //                                 fontFamily: AppTheme.fontName,
//                 //                                 fontSize: 18,
//                 //                                 color: Colors.white,
//                 //                                 fontWeight: FontWeight.w800,
//                 //                               ),
//                 //                             )),
//                 //                       )
//                 //                     : isPunchedIn
//                 //                         ? InkWell(
//                 //                             onTap: () {
//                 //                               var currentCount;
//                 //                               Get.dialog(AlertDialog(
//                 //                                 title: Text(
//                 //                                     "Are you sure you want to Punch Out?"),
//                 //                                 actions: [
//                 //                                   ElevatedButton(
//                 //                                     onPressed: () async {
//                 //                                       currentCount = prefs
//                 //                                           .getInt(SharedPrefKey
//                 //                                               .MARKER_COUNTS);
//                 //                                       currentCount++;
//                 //                                       punchOutOnTheMap(
//                 //                                           currentCount);
//                 //                                       await onPunchOutApi(
//                 //                                           mapLatitude
//                 //                                               .toString(),
//                 //                                           mapLongitude
//                 //                                               .toString());
//                 //                                       prefs.setInt(
//                 //                                           SharedPrefKey
//                 //                                               .ISPUNCHEDIN,
//                 //                                           0);
//                 //                                       if (this.mounted) {
//                 //                                         setState(() {
//                 //                                           isPunchedIn = false;
//                 //                                         });
//                 //                                       }
//                 //                                       Get.offAll(() => ServiceEngDashboard(
//                 //                                           prefs.getBool(
//                 //                                               SharedPrefKey
//                 //                                                   .ISLOGEDIN),
//                 //                                           prefs.getString(SharedPrefKey
//                 //                                               .SERVICEENGINEERID),
//                 //                                           prefs.getString(SharedPrefKey
//                 //                                               .SERVICEENGINEERNAME),
//                 //                                           prefs.getString(
//                 //                                               SharedPrefKey
//                 //                                                   .INSTALLATIONPENDING),
//                 //                                           prefs.getString(
//                 //                                               SharedPrefKey
//                 //                                                   .INSTALLATIONDONE),
//                 //                                           prefs.getString(
//                 //                                               SharedPrefKey
//                 //                                                   .SERVICEPENDING),
//                 //                                           prefs.getString(
//                 //                                               SharedPrefKey
//                 //                                                   .SERVICEDONE)));
//                 //                                       // Get.offAll(
//                 //                                       //     () => WelcomeScreen());
//                 //                                       // await Get.back();
//                 //                                       // Get.back();
//                 //                                       Get.snackbar(
//                 //                                         "Punched Out",
//                 //                                         "Click on 'Punch in' for a new punch",
//                 //                                         duration: Duration(
//                 //                                             seconds: 6),
//                 //                                         backgroundColor:
//                 //                                             Colors.blue,
//                 //                                         colorText: Colors.white,
//                 //                                         margin:
//                 //                                             EdgeInsets.all(10),
//                 //                                         padding:
//                 //                                             EdgeInsets.all(30),
//                 //                                         snackPosition:
//                 //                                             SnackPosition
//                 //                                                 .BOTTOM,
//                 //                                       );
//                 //                                     },
//                 //                                     child: Text(
//                 //                                       "Yes",
//                 //                                     ),
//                 //                                   ),
//                 //                                   ElevatedButton(
//                 //                                     onPressed: () => {
//                 //                                       Get.back(),
//                 //                                     },
//                 //                                     child: Text(
//                 //                                       "No",
//                 //                                     ),
//                 //                                   )
//                 //                                 ],
//                 //                               ));
//                 //                             },
//                 //                             child: Container(
//                 //                               width: 125,
//                 //                               height: 40,
//                 //                               alignment: Alignment.center,
//                 //                               decoration: BoxDecoration(
//                 //                                 color: Colors.red,
//                 //                               ),
//                 //                               child: Text(
//                 //                                 "Punch Out",
//                 //                                 style: TextStyle(
//                 //                                   fontFamily: AppTheme.fontName,
//                 //                                   fontSize: 18,
//                 //                                   color: Colors.white,
//                 //                                   fontWeight: FontWeight.w800,
//                 //                                 ),
//                 //                               ),
//                 //                             ),
//                 //                           )
//                 //                         : InkWell(
//                 //                             onTap: () {
//                 //                               Get.dialog(AlertDialog(
//                 //                                 title: Text(
//                 //                                     "Are you sure you want to Punch In?"),
//                 //                                 actions: [
//                 //                                   ElevatedButton(
//                 //                                     onPressed: () async {
//                 //                                       var time = DateTime.now()
//                 //                                               .hour
//                 //                                               .toString() +
//                 //                                           ":" +
//                 //                                           DateTime.now()
//                 //                                               .minute
//                 //                                               .toString();
//                 //                                       if (this.mounted) {
//                 //                                         setState(() {
//                 //                                           markers.addAll({
//                 //                                             ...markers,
//                 //                                             Marker(
//                 //                                               icon:
//                 //                                                   magentaMapMarker,
//                 //                                               markerId:
//                 //                                                   MarkerId('1'),
//                 //                                               position: LatLng(
//                 //                                                   mapLatitude,
//                 //                                                   mapLongitude),
//                 //                                               infoWindow:
//                 //                                                   InfoWindow(
//                 //                                                 title:
//                 //                                                     'Punch In today',
//                 //                                                 snippet:
//                 //                                                     'time: $time',
//                 //                                               ),
//                 //                                             ),
//                 //                                           });
//                 //                                           onPunchInApi(
//                 //                                               mapLatitude
//                 //                                                   .toString(),
//                 //                                               mapLongitude
//                 //                                                   .toString());
//                 //                                           // Get.back();
//                 //                                           Get.snackbar(
//                 //                                             "Punched In",
//                 //                                             "Click on 'Punch out' for punch out",
//                 //                                             duration: Duration(
//                 //                                                 seconds: 6),
//                 //                                             backgroundColor:
//                 //                                                 Colors.blue,
//                 //                                             colorText:
//                 //                                                 Colors.white,
//                 //                                             margin:
//                 //                                                 EdgeInsets.all(
//                 //                                                     10),
//                 //                                             padding:
//                 //                                                 EdgeInsets.all(
//                 //                                                     30),
//                 //                                             snackPosition:
//                 //                                                 SnackPosition
//                 //                                                     .BOTTOM,
//                 //                                           );
//                 //                                         });
//                 //                                       }
//                 //                                     },
//                 //                                     child: Text(
//                 //                                       "Yes",
//                 //                                     ),
//                 //                                   ),
//                 //                                   ElevatedButton(
//                 //                                     onPressed: () => {
//                 //                                       Get.back(),
//                 //                                     },
//                 //                                     child: Text(
//                 //                                       "No",
//                 //                                     ),
//                 //                                   )
//                 //                                 ],
//                 //                               ));
//                 //                             },
//                 //                             child: Container(
//                 //                               width: 125,
//                 //                               height: 40,
//                 //                               alignment: Alignment.center,
//                 //                               decoration: BoxDecoration(
//                 //                                 color: Colors.green,
//                 //                               ),
//                 //                               child: Text(
//                 //                                 "Punch In",
//                 //                                 style: TextStyle(
//                 //                                   fontFamily: AppTheme.fontName,
//                 //                                   fontSize: 18,
//                 //                                   color: Colors.white,
//                 //                                   fontWeight: FontWeight.w800,
//                 //                                 ),
//                 //                               ),
//                 //                             ),
//                 //                           ),
//                 //               ],
//                 //             )
//                 //           : Text(
//                 //               "You have been punched out for the day",
//                 //               style: TextStyle(fontFamily: "PriximaNova"),
//                 //             ),
//                 // ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   markInButtonPressed() async {
//     prefs.setString(SharedPrefKey.MARK_IN_REASON, "");
//     prefs.setString(SharedPrefKey.PRODUCTID, "");
//     prefs.setString(SharedPrefKey.SELECTED_CUSTOMER, "");
//     prefs.setString(SharedPrefKey.SERVICEREASON, "");
//     prefs.setString(SharedPrefKey.SERVICEREQID, "");
//     await Get.bottomSheet(
//       MarkinScreen(),
//     );
//     var reason = prefs.getString(SharedPrefKey.MARK_IN_REASON);
//     var productId = prefs.getString(SharedPrefKey.PRODUCTID);
//     var customerId = prefs.getString(SharedPrefKey.SELECTED_CUSTOMER);
//     var assignedProductId = prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID);
//     var serviceReason = prefs.getString(SharedPrefKey.SERVICEREASON);
//     var serviceReqId = prefs.getString(SharedPrefKey.SERVICEREQID);
//     print("Customer id:" + customerId);
//     var serviceId = prefs.getString(SharedPrefKey.SERVICEENGINEERID);
//     if (reason != null &&
//         reason != "" &&
//         productId != null &&
//         productId != "" &&
//         customerId != null &&
//         customerId != "" &&
//         serviceId != null &&
//         serviceId != "") {
// //end of state vars
//
//       if (this.mounted) {
//         setState(() async {
//           markInProcessing = true;
//           await onmarkinApi(mapLatitude, mapLongitude);
//           await getDetailsApi(mapLatitude, mapLongitude);
//         });
//       }
//
//       var currentCount = prefs.getInt(SharedPrefKey.MARKER_COUNTS);
//       currentCount++;
//       await markInOnTheMap(currentCount);
//
//       // setState(() {
//       //   markInProcessing = false;
//       // });
//       // end of state vars
//
//       // if (reason == "Installation") {
//       //   Get.to(
//       //     () => InstallationReqDetails(
//       //       assigned_product_id: assignedProductId,
//       //       customer_id: customerId,
//       //       product_id: productId,
//       //     ),
//       //   );
//       // } else if (reason == "Pre Installation") {
//       //   Get.to(
//       //     () => InstallationReqDetails(
//       //       assigned_product_id: assignedProductId,
//       //       customer_id: customerId,
//       //       product_id: productId,
//       //     ),
//       //   );
//       // } else if (reason == "Service") {
//       //   Get.to(
//       //     () => ServiceReqDetail(
//       //         customer_id: customerId,
//       //         product_id: productId,
//       //         service_request_id: serviceId,
//       //         assignedProductId: assignedProductId),
//       //   );
//       // }
//
//     } else {
//       return;
//     }
//   }
//
//   serviceresponse(String id, String responsedata) async {
//     onserviceresponse(id, responsedata);
//   }
//
//   Future<Response> onserviceresponse(id, responsedata) async {
//     var reason = prefs.getString(SharedPrefKey.MARK_IN_REASON);
//     var productId = prefs.getString(SharedPrefKey.PRODUCTID);
//     var customerId = prefs.getString(SharedPrefKey.SELECTED_CUSTOMER);
//     var assignedProductId = prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID);
//
//     bool isDeviceOnline = true;
//
//     // bool isDeviceOnline = await checkConnection();
//     ArsProgressDialog progressDialog = ArsProgressDialog(context,
//         blur: 2,
//         backgroundColor: Color(0x33000000),
//         animationDuration: Duration(milliseconds: 500));
//     print(id);
//     progressDialog.show();
//     // bool isDeviceOnline = await checkConnection();
//     if (isDeviceOnline) {
//       try {
//         BaseApi baseApi = new BaseApi();
//
//         Map<String, dynamic> formData = {
//           "service_request_id": id,
//           "response": responsedata,
//           "customer_id": customerId,
//           "product_id": productId,
//           'assigned_product_id': assignedProductId
//         };
//
//         var onclickresponse = FormData.fromMap(formData);
//
//         Response response =
//             await baseApi.dio.post(clickserviceresponse, data: onclickresponse);
//
//         progressDialog.dismiss();
//         if (response != null) {
//           final parsed = json.decode(response.data).cast<String, dynamic>();
//           print("RESPOONSE of onserviceresponse :" + parsed.toString());
//           String error = parsed["error"].toString();
//           print(parsed["status"]);
//
//           if (error == "1") {
//             _showMyDialog(context, parsed["status"].toString());
//           } else {
// //            String error_msg = commonRespo.error_msg;
//             displayToast(parsed["status"].toString(), context);
//           }
//         }
//
//         return response;
//       } catch (e) {
// //        print("RESPOONSE:" + e.toString());
//         progressDialog.dismiss();
//         //      displayToast("Something went wrong", context);
//         return null;
//       }
//     } else {
//       displayToast("Please connect to internet", context);
//       return null;
//     }
//   }
//
//   void _showMyDialog(BuildContext context, String msg) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return CupertinoAlertDialog(
//             title: Text("Response"),
//             content: Padding(
//               padding: EdgeInsets.all(10),
//               child: Text(msg),
//             ),
//             actions: <Widget>[
//               CupertinoDialogAction(
//                   textStyle: TextStyle(
//                       color: Colors.red, fontFamily: AppTheme.fontName),
//                   isDefaultAction: true,
//                   onPressed: () async {
//                     Get.back();
//
//                     servicereqdetail();
//                   },
//                   child: Text(
//                     "Okay",
//                     style: TextStyle(
//                         fontFamily: AppTheme.fontName,
//                         color: AppTheme.buttoncolor),
//                   )),
//             ],
//           );
//         });
//   }
//
//   Future<Response> servicereqdetail() async {
//     var reason = prefs.getString(SharedPrefKey.MARK_IN_REASON);
//     var productId = prefs.getString(SharedPrefKey.PRODUCTID);
//     var customerId = prefs.getString(SharedPrefKey.SELECTED_CUSTOMER);
//     var assignedProductId = prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID);
//     var serviceId = prefs.getString(SharedPrefKey.SERVICEENGINEERID);
//     String error;
//     bool isDeviceOnline = true;
//
//     //   bool isDeviceOnline = await checkConnection();
//     ArsProgressDialog progressDialog = ArsProgressDialog(context,
//         blur: 2,
//         backgroundColor: Color(0x33000000),
//         animationDuration: Duration(milliseconds: 500));
//     progressDialog.show();
//     if (isDeviceOnline) {
//       try {
//         BaseApi baseApi = new BaseApi();
//
//         Map<String, dynamic> formData = {
//           'assigned_product_id': assignedProductId,
//           "customer_id": customerId,
//           "product_id": productId,
//           "service_request_id": serviceId,
//         };
//
//         var servicedetailrespo = FormData.fromMap(formData);
//
//         Response response =
//             await baseApi.dio.post(serreqdetail, data: servicedetailrespo);
//
//         if (response != null) {
//           final parsed = json.decode(response.data).cast<String, dynamic>();
//           print("RESPONSE of service req detail:" + parsed.toString());
//           error = parsed["error"].toString();
//           progressDialog.dismiss();
//           if (error == "1") {
//             SerReqDetail detail = SerReqDetail.fromJson(parsed);
//             print('Details ${detail.serviceProduct.response}');
//             // setState(() {
//             //   productId = detail.serviceProduct.productId;
//             //   product_name = detail.serviceProduct.productName;
//             //   product_image = detail.serviceProduct.productImage;
//             //   model_no = detail.serviceProduct.modelNo;
//             //   brand = detail.serviceProduct.brand;
//             //   customerId = detail.serviceProduct.customerId;
//             //   customer_name = detail.serviceProduct.customerName;
//             //   customer_mobile = detail.serviceProduct.customerMobile;
//             //   customer_whatsapp = detail.serviceProduct.customerWhatsapp;
//             //   qr_image = detail.serviceProduct.qrImage;
//             //   service_status = detail.serviceProduct.serviceStatus;
//             //   responses = detail.serviceProduct.response;
//             //   serviceRequestId = detail.serviceProduct.serviceRequestId;
//             // });
//           } else {
// //            AllocatedProdListModel allocatedrespo = AllocatedProdListModel.fromJson(parsed);
//             //          String error_msg = allocatedrespo.error_msg;
//             //        displayToast(error_msg.toString(), context);
//           }
//         }
//         return response;
//       } catch (e) {
//         // print("RESPOONSE:" + e);
//         displayToast("Something went wrong", context);
//         return null;
//       }
//     } else {
//       //   displayToast("Please connect to internet", context);
//       return null;
//     }
//   }
// }
import 'dart:async';
import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage//ServiceEngDashBoard.dart';
import 'package:scisco_service/Homepage/installationform.dart';
import 'package:scisco_service/Homepage/preinstallationform.dart';
import 'package:scisco_service/Homepage/servicereqdetail.dart';
import 'package:scisco_service/Homepage/servicerequestdone.dart';
import 'package:scisco_service/Homepage/webserviceform.dart';
import 'package:scisco_service/LoginSignup/Welcome/welcome_screen.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/markinMarkout/markInScreen.dart';
import 'package:scisco_service/models/ServicereqDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../Homepage/installationdetails.dart';

class MapsScreen extends StatefulWidget {
  MapsScreen({
    Key key,
  }) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController _controller;
  Location location = new Location();
  LocationData currentLocation;
  int shiftended = 0;
  final msgCtrl = TextEditingController();
  bool isPunchedIn = false;
  bool startPunchIn = false;
  int punchInOrNot = 0;
  bool isLoading = false;
  bool markInProcessing = false;
  BitmapDescriptor yellowMapMarker;
  BitmapDescriptor blueMapMarker;
  BitmapDescriptor magentaMapMarker;
  BitmapDescriptor greenMapMarker;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  SharedPreferences prefs;
  var isPunchIn;
  int countForApiCall = 0;
  bool isLogin;
  var serviceengineerid;
  var serviceengineername;
  String installationpending;
  String installationdone;
  String servicepending;
  String servicedone;

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool(SharedPrefKey.ISLOGEDIN);
    if (isLogin == null) {
      isLogin = false;
    }
    setState(() {
      print('pucnh ${prefs.getInt(SharedPrefKey.ISPUNCHEDIN)}');
      punchInOrNot = prefs.getInt(SharedPrefKey.ISPUNCHEDIN);
      serviceengineerid = prefs.getString(SharedPrefKey.SERVICEENGINEERID);
      serviceengineername = prefs.getString(SharedPrefKey.SERVICEENGINEERNAME);
      installationpending = prefs.getString(SharedPrefKey.INSTALLATIONPENDING);
      installationdone = prefs.getString(SharedPrefKey.INSTALLATIONDONE);
      servicepending = prefs.getString(SharedPrefKey.SERVICEPENDING);
      servicedone = prefs.getString(SharedPrefKey.SERVICEDONE);
      prefs.setInt(SharedPrefKey.MARKER_COUNTS, 2);
    });
    print("this is service engineer id:" + serviceengineerid);
  }

  void setCustomMarker() {
    yellowMapMarker = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueYellow,
    );

    blueMapMarker = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueBlue,
    );

    greenMapMarker = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueGreen,
    );

    magentaMapMarker = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueMagenta,
    );
  }

  void setPolylines(polyLati, polyLongi) async {
    if (!isPunchedIn) {
      return;
    }
    polylineCoordinates.add(LatLng(polyLati, polyLongi));

    if (this.mounted) {
      setState(() {
        polylines.add(Polyline(
          polylineId: PolylineId('polyline'),
          color: Color(0xff00ff00),
          points: polylineCoordinates,
        ));
      });
    }
  }

  void _onMapCreated(GoogleMapController _cntlr) async {
    setState(() {
      isLoading = true;
    });
    _controller = _cntlr;

    // _locationData = await location.getLocation();
    // print('Location $_locationData');
    // var time =
    // DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString();
    location.changeSettings(
        // interval: 200000,
        //interval: 10,
        //accuracy: LocationAccuracy.high,
        // distanceFilter: 10
        //distanceFilter: 200000
        );
    location.onLocationChanged.listen((LocationData cLoc) async {
      countForApiCall = countForApiCall + 1;
      currentLocation = cLoc;
      setPolylines(currentLocation.latitude, currentLocation.longitude);
      mapLatitude = currentLocation.latitude;
      mapLongitude = currentLocation.longitude;

      await _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(mapLatitude, mapLongitude), zoom: 15),
        ),
      );
      print(
        "Engineer id " + prefs.getString(SharedPrefKey.SERVICEENGINEERID),
      );
      setState(() {
        isLoading = false;
      });

      if (countForApiCall == 30) {
        countForApiCall = 0;
        print('Counte ${countForApiCall}');
        print('map ${lastMapLatitude}');
        print('map ${mapLatitude}');

        if (lastMapLatitude != mapLatitude)
          await getDetailsApi(mapLatitude, mapLongitude);
      } else {
        print('countForApiCall ${countForApiCall}');
        lastMapLatitude = cLoc.latitude;
        lastMapLongitude = cLoc.longitude;
      }

      // box.read('isPunchIn') == 0
      //     ? setState(() {
      //         markers.addAll({
      //           ...markers,
      //           Marker(
      //             icon: magentaMapMarker,
      //             markerId: MarkerId('1'),
      //             position: LatLng(mapLatitude, mapLongitude),
      //             infoWindow: InfoWindow(
      //               title: 'Punch In today',
      //               // snippet: 'time: $time',
      //             ),
      //           ),
      //         });
      //         onPunchInApi(mapLatitude.toString(), mapLongitude.toString());
      //         box.write('isPunchIn', 1);
      //         print("isPunchIn");
      //         print(box.read('isPunchIn'));
      //         Get.snackbar(
      //           "Punched In",
      //           "time: ${0}" + box.read('isPunchIn'),
      //           duration: Duration(seconds: 6),
      //           backgroundColor: Colors.blue,
      //           colorText: Colors.white,
      //           margin: EdgeInsets.all(10),
      //           padding: EdgeInsets.all(30),
      //           snackPosition: SnackPosition.BOTTOM,
      //         );
      //       })
      //     : null;
    });

    location.enableBackgroundMode(enable: true);
  }

  markOutOnTheMap(int currentCount) {
    print('mark out ${prefs.getString(SharedPrefKey.MARK_IN_REASON)}');
    //if (this.mounted) {
    setState(() {
      markers.addAll({
        ...markers,
        Marker(
          markerId: MarkerId(currentCount.toString()),
          icon: greenMapMarker,
          position: LatLng(mapLatitude, mapLongitude),
          infoWindow: InfoWindow(
            title: 'Mark' + currentCount.toString() + '(OUT)',
            snippet:
                //"Completed "
                "Completed " + prefs.getString(SharedPrefKey.MARK_IN_REASON),
          ),
        ),
      });
      print("map markers" + markers.toString());
      _onMapCreated(_controller);
    });
    // }
  }

  void punchOutOnTheMap(currentCount) {
    if (this.mounted) {
      setState(() {
        markers.addAll({
          ...markers,
          Marker(
            markerId: MarkerId(currentCount.toString()),
            icon: blueMapMarker,
            position: LatLng(mapLatitude, mapLongitude),
            infoWindow: InfoWindow(
              title: 'Punch Out',
              snippet: 'Time' +
                  DateTime.now().hour.toString() +
                  ":" +
                  DateTime.now().minute.toString(),
            ),
          ),
        });
        print("The markers are" + markers.toString());
      });
    }
  }

  markInOnTheMap(int currentCount) {
    if (this.mounted) {
      setState(() {
        markers.addAll({
          ...markers,
          Marker(
            markerId: MarkerId(currentCount.toString()),
            icon: yellowMapMarker,
            position: LatLng(mapLatitude, mapLongitude),
            infoWindow: InfoWindow(
              title: 'Mark' + currentCount.toString() + '(IN)',
              snippet: "Started Work",
            ),
          ),
        });
        print("The markers are" + markers.toString());
      });
    }
  }

  Future<Response> getDetailsApi(var mapLatitude, var mapLongitude) async {
    bool isDeviceOnline = true;

    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();
        print('iisPunchedIn ${isPunchedIn}');
        Map<String, dynamic> formData = isPunchedIn
            ? {
                "service_engineer_id":
                    prefs.getString(SharedPrefKey.SERVICEENGINEERID),
                "latitude": mapLatitude,
                "longitude": mapLongitude,
              }
            : {
                "service_engineer_id":
                    prefs.getString(SharedPrefKey.SERVICEENGINEERID),
              };
        var getData = FormData.fromMap(formData);

        Response response =
            await baseApi.dio.post(engineerLocationUrl, data: getData);

        print('getData ${getData}');
        print('PUNCINAPI ${response.data}');

        if (response != null) {
          // List<dynamic> body = jsonDecode(response.data);
          final parsed = json.decode(response.data).cast<String, dynamic>();
          setState(() {
            if (parsed["punched_in"] == 0 && parsed["punched_out"] == 0) {
              setState(() {
                isPunchedIn = false;
                startPunchIn = true;
              });
            } else if (parsed["punched_in"] == 1 &&
                parsed["punched_out"] == 0) {
              setState(() {
                isPunchedIn = true;
                startPunchIn = true;
              });
            } else {
              setState(() {
                startPunchIn = false;
              });
            }
            if (parsed["marked_in"] == 0) {
              setState(() {
                markInProcessing = false;
              });
            } else {
              setState(() {
                markInProcessing = true;
              });
            }
          });

          print("Get API Details");
          print('isPunch In or not $isPunchedIn');
          print(markInProcessing);
        }
        return response;
      } catch (e) {
        // print("RESPOONSE:" + e.toString());
        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }

  Future<Response> onPunchInApi(String latitude, String longitude) async {
    bool isDeviceOnline = true;
    print("inside punch in");
    var time =
        DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();
        if (shiftended == 0) {
          Map<String, dynamic> formData = {
            "service_engineer_id":
                prefs.getString(SharedPrefKey.SERVICEENGINEERID),
            "latitude": latitude,
            "longitude": longitude,
            "shift_ended": shiftended
          };
          var changelocation = FormData.fromMap(formData);

          Response response =
              await baseApi.dio.post(engineerLocationUrl, data: changelocation);
          print(response);
          markers.addAll({
            ...markers,
            Marker(
              icon: magentaMapMarker,
              markerId: MarkerId('1'),
              position: LatLng(mapLatitude, mapLongitude),
              infoWindow: InfoWindow(
                title: 'Punch In today',
                snippet: 'time: $time',
              ),
            ),
          });
          if (response != null) {
            // List<dynamic> body = jsonDecode(response.data);
            final parsed = json.decode(response.data).cast<String, dynamic>();
            print("RESPOONSE punch in service form :" + parsed.toString());
            String error = parsed["error"].toString();
            print('satus ${parsed["status"]}');

            if (parsed['status'] == "You've already punched out today.") {
              Fluttertoast.showToast(msg: "You've already punched out today.");
              Get.back();
              Get.offAll(() => ServiceEngDashboard(
                  prefs.getBool(SharedPrefKey.ISLOGEDIN),
                  prefs.getString(SharedPrefKey.SERVICEENGINEERID),
                  prefs.getString(SharedPrefKey.SERVICEENGINEERNAME),
                  prefs.getString(SharedPrefKey.INSTALLATIONPENDING),
                  prefs.getString(SharedPrefKey.INSTALLATIONDONE),
                  prefs.getString(SharedPrefKey.SERVICEPENDING),
                  prefs.getString(SharedPrefKey.SERVICEDONE)));
            } else {
              Get.back();
              await getDetailsApi(mapLatitude, mapLongitude);
              setState(() {
                prefs.setInt(SharedPrefKey.ISPUNCHEDIN, 1);
                punchInOrNot = prefs.getInt(SharedPrefKey.ISPUNCHEDIN);
              });
              Get.snackbar(
                "Punched In",
                "Click on 'Punch out' for punch out",
                duration: Duration(seconds: 6),
                backgroundColor: Colors.blue,
                colorText: Colors.white,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(30),
                snackPosition: SnackPosition.BOTTOM,
              );
              Get.offAll(() => ServiceEngDashboard(
                  prefs.getBool(SharedPrefKey.ISLOGEDIN),
                  prefs.getString(SharedPrefKey.SERVICEENGINEERID),
                  prefs.getString(SharedPrefKey.SERVICEENGINEERNAME),
                  prefs.getString(SharedPrefKey.INSTALLATIONPENDING),
                  prefs.getString(SharedPrefKey.INSTALLATIONDONE),
                  prefs.getString(SharedPrefKey.SERVICEPENDING),
                  prefs.getString(SharedPrefKey.SERVICEDONE)));
            }

            if (error == "1") {
            } else {
              //    String errorMsg = commonResponse.error_msg;
              //  displayToast(errorMsg.toString(), context);
            }
          }
          return response;
        }
      } catch (e) {
        // print("RESPOONSE:" + e.toString());
        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      displayToast("Please connect to internet", context);
      return null;
    }
  }

  Future<Response> onmarkinApi(double latitude, double longitude) async {
    bool isDeviceOnline = true;
    print('CUSID');
    print(prefs.getString(SharedPrefKey.COSTUMERID));

    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();
        if (shiftended == 0) {
          Map<String, dynamic> formData = {
            "service_engineer_id":
                prefs.getString(SharedPrefKey.SERVICEENGINEERID),
            "latitude": latitude.toString(),
            "longitude": longitude.toString(),
            "mark_in": 1,
            "customer_id":
                prefs.getString(SharedPrefKey.SELECTED_CUSTOMER) ?? "",
            "message": prefs.getString(SharedPrefKey.MARK_IN_REASON),
          };
          var changelocation = FormData.fromMap(formData);

          Response response =
              await baseApi.dio.post(engineerLocationUrl, data: changelocation);
          print(response);
          if (response != null) {
            var reason = prefs.getString(SharedPrefKey.MARK_IN_REASON);
            var productId = prefs.getString(SharedPrefKey.PRODUCTID);
            var customerId = prefs.getString(SharedPrefKey.SELECTED_CUSTOMER);
            var assignedProductId =
                prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID);
            var serviceReason = prefs.getString(SharedPrefKey.SERVICEREASON);
            var serviceReqId = prefs.getString(SharedPrefKey.SERVICEREQID);

            // List<dynamic> body = jsonDecode(response.data);

            final parsed = json.decode(response.data).cast<String, dynamic>();
            print("RESPONSE IS OF THE MARKIN API" + parsed.toString());
            //        print("RESPOONSE service form :" + parsed.toString());
            String error = parsed["error"].toString();

            if (reason == 'Pre Installation') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: ((context) => PreInstallationForm(
                        customerId, productId, assignedProductId))),
                (route) => false,
              );
            }
            if (reason == 'Installation') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: ((context) => InstallationForm(
                        customerId, productId, assignedProductId))),
                (route) => false,
              );
            }
            if (reason == 'Service') {
              if (serviceReason == 'Resolved on call') {
                return Get.dialog(AlertDialog(
                  title:
                      Text("Are you sure you want to submit Resolved on call"),
                  actions: [
                    ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        // print('Called');
                        // Get.off(() => ServiceForm(
                        //     customer_id,
                        //     product_id,
                        //     assignedProductId));
                        // servicereqdetail();
                        await serviceresponse(serviceReqId, "Resolved on call");
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ServiceRequest()),
                            (route) => false);
                      },
                      child: Text(
                        "Yes",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        Get.back(),
                      },
                      child: Text(
                        "No",
                      ),
                    )
                  ],
                ));
              } else {
                await serviceresponse(serviceReqId, "Site visit required");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                          WebServiceForm(customerId, productId, serviceReqId))),
                  (route) => false,
                );
              }

              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(
              //       builder: ((context) => WebServiceForm(
              //           selectedcustomerId,
              //           selectedProductId,
              //           prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID)))),
              //   (route) => false,
              // );
            }

            if (error == "1") {
              print(markInProcessing);
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

  Future<Response> onmarkoutApi(String latitude, String longitude) async {
    bool isDeviceOnline = true;

    // SharedPreferences prefs = await SharedPreferences.getInstance();
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
            "mark_out": 1,
            "message":
                "Marked out at " + DateFormat('hh:mm').format(DateTime.now()),
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
            if (this.mounted) {
              setState(() {
                markInProcessing = false;
              });
            }
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

  Future<Response> onPunchOutApi(String latitude, String longitude) async {
    bool isDeviceOnline = true;
    shiftended = 1;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
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
          "message ":
              "PunchedOut " + DateFormat('hh:mm').format(DateTime.now()),
          "shift_ended": shiftended
        };
        var changelocation = FormData.fromMap(formData);

        print(formData);
        Response response =
            await baseApi.dio.post(engineerLocationUrl, data: changelocation);
        print('PunchOur Api Response ${response}');
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

  //
  // void getSharedInstance() async {
  //   prefs = await SharedPreferences.getInstance();
  //   prefs.setInt(SharedPrefKey.MARKER_COUNTS, 2);
  // }

  @override
  void initState() {
    getLocationPermision();
    initPrefs();

    _onMapCreated(_controller);
    //  setCustomMarker();

    polylinePoints = PolylinePoints();
    // isPunchIn = prefs.getInt(SharedPrefKey.ISPUNCHEDIN);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ServiceEngDashboard(
                    isLogin,
                    serviceengineerid,
                    serviceengineername,
                    installationpending,
                    installationdone,
                    servicepending,
                    servicedone)),
            (route) => false),
        child: Scaffold(
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: GoogleMap(
                  polylines: polylines,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  mapToolbarEnabled: true,
                  initialCameraPosition:
                      CameraPosition(target: _initialcameraposition),
                  onMapCreated: _onMapCreated,
                  markers: markers,
                ),
              ),
              SlidingUpPanel(
                minHeight: 100,
                maxHeight: 100,
                panel: Center(
                    child: isLoading == true
                        ? Text("Loading..")
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  (!markInProcessing && punchInOrNot == 1)
                                      ? markInButtonPressed()
                                      : Wrap();
                                },
                                child: Container(
                                    width: 125,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: (markInProcessing)
                                          ? AppTheme.appColor.withOpacity(0.5)
                                          : (punchInOrNot == 0)
                                              ? AppTheme.appColor
                                                  .withOpacity(0.5)
                                              : AppTheme.appColor,
                                    ),
                                    child: Text(
                                      "Mark In",
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )),
                              ),
                              markInProcessing
                                  ? InkWell(
                                      onTap: () async {
                                        int currentCount = prefs.getInt(
                                            SharedPrefKey.MARKER_COUNTS);
                                        print("Counte $currentCount");
                                        currentCount++;

                                        if (this.mounted) {
                                          setState(() {
                                            markInProcessing = false;
                                          });
                                        }
                                        // TODO: HIT THE API HERE FOR MARKOUT
                                        await onmarkoutApi(
                                            mapLatitude.toString(),
                                            mapLongitude.toString());

                                        Get.dialog(
                                          AlertDialog(
                                            title: Text("Marked Out"),
                                            content: Text(
                                                "You have been marked out successfully"),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await markOutOnTheMap(
                                                      currentCount);
                                                  Get.back();
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ServiceEngDashboard(
                                                                isLogin,
                                                                serviceengineerid,
                                                                serviceengineername,
                                                                installationpending,
                                                                installationdone,
                                                                servicepending,
                                                                servicedone),
                                                      ),
                                                      (route) => false);
                                                },
                                                child: Text(
                                                  "OK",
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      child: Container(
                                          width: 125,
                                          height: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: (markInProcessing)
                                                ? AppTheme.appColor
                                                : AppTheme.appColor
                                                    .withOpacity(0.5),
                                          ),
                                          child: Text(
                                            "Mark Out",
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          )),
                                    )
                                  : (punchInOrNot == 1)
                                      ? InkWell(
                                          onTap: () {
                                            var currentCount;
                                            Get.dialog(AlertDialog(
                                              title: Text(
                                                  "Are you sure you want to Punch Out?"),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    currentCount = prefs.getInt(
                                                        SharedPrefKey
                                                            .MARKER_COUNTS);
                                                    currentCount++;
                                                    punchOutOnTheMap(
                                                        currentCount);
                                                    await onPunchOutApi(
                                                        mapLatitude.toString(),
                                                        mapLongitude
                                                            .toString());
                                                    prefs.setInt(
                                                        SharedPrefKey
                                                            .ISPUNCHEDIN,
                                                        0);
                                                    if (this.mounted) {
                                                      setState(() {
                                                        isPunchedIn = false;
                                                      });
                                                    }
                                                    Get.offAll(() => ServiceEngDashboard(
                                                        prefs.getBool(
                                                            SharedPrefKey
                                                                .ISLOGEDIN),
                                                        prefs.getString(SharedPrefKey
                                                            .SERVICEENGINEERID),
                                                        prefs.getString(SharedPrefKey
                                                            .SERVICEENGINEERNAME),
                                                        prefs.getString(SharedPrefKey
                                                            .INSTALLATIONPENDING),
                                                        prefs.getString(
                                                            SharedPrefKey
                                                                .INSTALLATIONDONE),
                                                        prefs.getString(
                                                            SharedPrefKey
                                                                .SERVICEPENDING),
                                                        prefs.getString(
                                                            SharedPrefKey
                                                                .SERVICEDONE)));
                                                    // Get.offAll(
                                                    //     () => WelcomeScreen());
                                                    // await Get.back();
                                                    // Get.back();
                                                    Get.snackbar(
                                                      "Punched Out",
                                                      "Click on 'Punch in' for a new punch",
                                                      duration:
                                                          Duration(seconds: 6),
                                                      backgroundColor:
                                                          Colors.blue,
                                                      colorText: Colors.white,
                                                      margin:
                                                          EdgeInsets.all(10),
                                                      padding:
                                                          EdgeInsets.all(30),
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                    );
                                                  },
                                                  child: Text(
                                                    "Yes",
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () => {
                                                    Get.back(),
                                                  },
                                                  child: Text(
                                                    "No",
                                                  ),
                                                )
                                              ],
                                            ));
                                          },
                                          child: Container(
                                            width: 125,
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                            ),
                                            child: Text(
                                              "Punch Out",
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            punchInOrNot = prefs.getInt(
                                                SharedPrefKey.ISPUNCHEDIN);

                                            Get.dialog(AlertDialog(
                                              title: Text(
                                                  "Are you sure you want to Punch In?"),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    if (this.mounted) {
                                                      setState(() async {
                                                        await onPunchInApi(
                                                            mapLatitude
                                                                .toString(),
                                                            mapLongitude
                                                                .toString());
                                                        // Get.back();
                                                        // Get.snackbar(
                                                        //   "Punched In",
                                                        //   "Click on 'Punch out' for punch out",
                                                        //   duration: Duration(
                                                        //       seconds: 6),
                                                        //   backgroundColor:
                                                        //       Colors.blue,
                                                        //   colorText:
                                                        //       Colors.white,
                                                        //   margin:
                                                        //       EdgeInsets.all(
                                                        //           10),
                                                        //   padding:
                                                        //       EdgeInsets.all(
                                                        //           30),
                                                        //   snackPosition:
                                                        //       SnackPosition
                                                        //           .BOTTOM,
                                                        // );
                                                      });
                                                    }
                                                  },
                                                  child: Text(
                                                    "Yes",
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () => {
                                                    Get.back(),
                                                  },
                                                  child: Text(
                                                    "No",
                                                  ),
                                                )
                                              ],
                                            ));
                                          },
                                          child: Container(
                                            width: 125,
                                            height: 40,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                            ),
                                            child: Text(
                                              "Punch In",
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        ),
                            ],
                          )),
                // panel: Center(
                //   child: isLoading
                //       ? Text("Loading..")
                //       : startPunchIn
                //           ? Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                //               children: [
                //                 GestureDetector(
                //                   onTap: () {
                //                     (!markInProcessing && isPunchedIn)
                //                         ? markInButtonPressed()
                //                         : Wrap();
                //                   },
                //                   child: Container(
                //                       width: 125,
                //                       height: 40,
                //                       alignment: Alignment.center,
                //                       decoration: BoxDecoration(
                //                         color: (markInProcessing)
                //                             ? AppTheme.appColor.withOpacity(0.5)
                //                             : (!isPunchedIn)
                //                                 ? AppTheme.appColor
                //                                     .withOpacity(0.5)
                //                                 : AppTheme.appColor,
                //                       ),
                //                       child: Text(
                //                         "Mark In",
                //                         style: TextStyle(
                //                           fontFamily: AppTheme.fontName,
                //                           fontSize: 18,
                //                           color: Colors.white,
                //                           fontWeight: FontWeight.w800,
                //                         ),
                //                       )),
                //                 ),
                //                 markInProcessing
                //                     ? InkWell(
                //                         onTap: () async {
                //                           print('ENTER');
                //                           int currentCount = prefs.getInt(
                //                               SharedPrefKey.MARKER_COUNTS);
                //                           print("Counte $currentCount");
                //                           currentCount++;
                //
                //                           if (this.mounted) {
                //                             setState(() {
                //                               markInProcessing = false;
                //                             });
                //                           }
                //                           // TODO: HIT THE API HERE FOR MARKOUT
                //                           await onmarkoutApi(
                //                               mapLatitude.toString(),
                //                               mapLongitude.toString());
                //
                //                           Get.dialog(
                //                             AlertDialog(
                //                               title: Text("Marked Out"),
                //                               content: Text(
                //                                   "You have been marked out successfully"),
                //                               actions: [
                //                                 ElevatedButton(
                //                                   onPressed: () async {
                //                                     await markOutOnTheMap(
                //                                         currentCount);
                //                                     Get.back();
                //                                     Navigator
                //                                         .pushAndRemoveUntil(
                //                                             context,
                //                                             MaterialPageRoute(
                //                                               builder: (context) => ServiceEngDashboard(
                //                                                   isLogin,
                //                                                   serviceengineerid,
                //                                                   serviceengineername,
                //                                                   installationpending,
                //                                                   installationdone,
                //                                                   servicepending,
                //                                                   servicedone),
                //                                             ),
                //                                             (route) => false);
                //                                   },
                //                                   child: Text(
                //                                     "OK",
                //                                   ),
                //                                 )
                //                               ],
                //                             ),
                //                           );
                //                         },
                //                         child: Container(
                //                             width: 125,
                //                             height: 40,
                //                             alignment: Alignment.center,
                //                             decoration: BoxDecoration(
                //                               color: (markInProcessing)
                //                                   ? AppTheme.appColor
                //                                   : AppTheme.appColor
                //                                       .withOpacity(0.5),
                //                             ),
                //                             child: Text(
                //                               "Mark Out",
                //                               style: TextStyle(
                //                                 fontFamily: AppTheme.fontName,
                //                                 fontSize: 18,
                //                                 color: Colors.white,
                //                                 fontWeight: FontWeight.w800,
                //                               ),
                //                             )),
                //                       )
                //                     : isPunchedIn
                //                         ? InkWell(
                //                             onTap: () {
                //                               var currentCount;
                //                               Get.dialog(AlertDialog(
                //                                 title: Text(
                //                                     "Are you sure you want to Punch Out?"),
                //                                 actions: [
                //                                   ElevatedButton(
                //                                     onPressed: () async {
                //                                       currentCount = prefs
                //                                           .getInt(SharedPrefKey
                //                                               .MARKER_COUNTS);
                //                                       currentCount++;
                //                                       punchOutOnTheMap(
                //                                           currentCount);
                //                                       await onPunchOutApi(
                //                                           mapLatitude
                //                                               .toString(),
                //                                           mapLongitude
                //                                               .toString());
                //                                       prefs.setInt(
                //                                           SharedPrefKey
                //                                               .ISPUNCHEDIN,
                //                                           0);
                //                                       if (this.mounted) {
                //                                         setState(() {
                //                                           isPunchedIn = false;
                //                                         });
                //                                       }
                //                                       Get.offAll(() => ServiceEngDashboard(
                //                                           prefs.getBool(
                //                                               SharedPrefKey
                //                                                   .ISLOGEDIN),
                //                                           prefs.getString(SharedPrefKey
                //                                               .SERVICEENGINEERID),
                //                                           prefs.getString(SharedPrefKey
                //                                               .SERVICEENGINEERNAME),
                //                                           prefs.getString(
                //                                               SharedPrefKey
                //                                                   .INSTALLATIONPENDING),
                //                                           prefs.getString(
                //                                               SharedPrefKey
                //                                                   .INSTALLATIONDONE),
                //                                           prefs.getString(
                //                                               SharedPrefKey
                //                                                   .SERVICEPENDING),
                //                                           prefs.getString(
                //                                               SharedPrefKey
                //                                                   .SERVICEDONE)));
                //                                       // Get.offAll(
                //                                       //     () => WelcomeScreen());
                //                                       // await Get.back();
                //                                       // Get.back();
                //                                       Get.snackbar(
                //                                         "Punched Out",
                //                                         "Click on 'Punch in' for a new punch",
                //                                         duration: Duration(
                //                                             seconds: 6),
                //                                         backgroundColor:
                //                                             Colors.blue,
                //                                         colorText: Colors.white,
                //                                         margin:
                //                                             EdgeInsets.all(10),
                //                                         padding:
                //                                             EdgeInsets.all(30),
                //                                         snackPosition:
                //                                             SnackPosition
                //                                                 .BOTTOM,
                //                                       );
                //                                     },
                //                                     child: Text(
                //                                       "Yes",
                //                                     ),
                //                                   ),
                //                                   ElevatedButton(
                //                                     onPressed: () => {
                //                                       Get.back(),
                //                                     },
                //                                     child: Text(
                //                                       "No",
                //                                     ),
                //                                   )
                //                                 ],
                //                               ));
                //                             },
                //                             child: Container(
                //                               width: 125,
                //                               height: 40,
                //                               alignment: Alignment.center,
                //                               decoration: BoxDecoration(
                //                                 color: Colors.red,
                //                               ),
                //                               child: Text(
                //                                 "Punch Out",
                //                                 style: TextStyle(
                //                                   fontFamily: AppTheme.fontName,
                //                                   fontSize: 18,
                //                                   color: Colors.white,
                //                                   fontWeight: FontWeight.w800,
                //                                 ),
                //                               ),
                //                             ),
                //                           )
                //                         : InkWell(
                //                             onTap: () {
                //                               Get.dialog(AlertDialog(
                //                                 title: Text(
                //                                     "Are you sure you want to Punch In?"),
                //                                 actions: [
                //                                   ElevatedButton(
                //                                     onPressed: () async {
                //                                       var time = DateTime.now()
                //                                               .hour
                //                                               .toString() +
                //                                           ":" +
                //                                           DateTime.now()
                //                                               .minute
                //                                               .toString();
                //                                       if (this.mounted) {
                //                                         setState(() {
                //                                           markers.addAll({
                //                                             ...markers,
                //                                             Marker(
                //                                               icon:
                //                                                   magentaMapMarker,
                //                                               markerId:
                //                                                   MarkerId('1'),
                //                                               position: LatLng(
                //                                                   mapLatitude,
                //                                                   mapLongitude),
                //                                               infoWindow:
                //                                                   InfoWindow(
                //                                                 title:
                //                                                     'Punch In today',
                //                                                 snippet:
                //                                                     'time: $time',
                //                                               ),
                //                                             ),
                //                                           });
                //                                           onPunchInApi(
                //                                               mapLatitude
                //                                                   .toString(),
                //                                               mapLongitude
                //                                                   .toString());
                //                                           // Get.back();
                //                                           Get.snackbar(
                //                                             "Punched In",
                //                                             "Click on 'Punch out' for punch out",
                //                                             duration: Duration(
                //                                                 seconds: 6),
                //                                             backgroundColor:
                //                                                 Colors.blue,
                //                                             colorText:
                //                                                 Colors.white,
                //                                             margin:
                //                                                 EdgeInsets.all(
                //                                                     10),
                //                                             padding:
                //                                                 EdgeInsets.all(
                //                                                     30),
                //                                             snackPosition:
                //                                                 SnackPosition
                //                                                     .BOTTOM,
                //                                           );
                //                                         });
                //                                       }
                //                                     },
                //                                     child: Text(
                //                                       "Yes",
                //                                     ),
                //                                   ),
                //                                   ElevatedButton(
                //                                     onPressed: () => {
                //                                       Get.back(),
                //                                     },
                //                                     child: Text(
                //                                       "No",
                //                                     ),
                //                                   )
                //                                 ],
                //                               ));
                //                             },
                //                             child: Container(
                //                               width: 125,
                //                               height: 40,
                //                               alignment: Alignment.center,
                //                               decoration: BoxDecoration(
                //                                 color: Colors.green,
                //                               ),
                //                               child: Text(
                //                                 "Punch In",
                //                                 style: TextStyle(
                //                                   fontFamily: AppTheme.fontName,
                //                                   fontSize: 18,
                //                                   color: Colors.white,
                //                                   fontWeight: FontWeight.w800,
                //                                 ),
                //                               ),
                //                             ),
                //                           ),
                //               ],
                //             )
                //           : Text(
                //               "You have been punched out for the day",
                //               style: TextStyle(fontFamily: "PriximaNova"),
                //             ),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  markInButtonPressed() async {
    prefs.setString(SharedPrefKey.MARK_IN_REASON, "");
    prefs.setString(SharedPrefKey.PRODUCTID, "");
    prefs.setString(SharedPrefKey.SELECTED_CUSTOMER, "");
    prefs.setString(SharedPrefKey.SERVICEREASON, "");
    prefs.setString(SharedPrefKey.SERVICEREQID, "");
    await Get.bottomSheet(
      MarkinScreen(),
    );
    var reason = prefs.getString(SharedPrefKey.MARK_IN_REASON);
    var productId = prefs.getString(SharedPrefKey.PRODUCTID);
    var customerId = prefs.getString(SharedPrefKey.SELECTED_CUSTOMER);
    var assignedProductId = prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID);
    var serviceReason = prefs.getString(SharedPrefKey.SERVICEREASON);
    var serviceReqId = prefs.getString(SharedPrefKey.SERVICEREQID);
    print("Customer id:" + customerId);
    var serviceId = prefs.getString(SharedPrefKey.SERVICEENGINEERID);
    if (reason != null &&
        reason != "" &&
        productId != null &&
        productId != "" &&
        customerId != null &&
        customerId != "" &&
        serviceId != null &&
        serviceId != "") {
//end of state vars

      if (this.mounted) {
        setState(() async {
          markInProcessing = true;
          await onmarkinApi(mapLatitude, mapLongitude);
          await getDetailsApi(mapLatitude, mapLongitude);
        });
      }

      var currentCount = prefs.getInt(SharedPrefKey.MARKER_COUNTS);
      currentCount++;
      await markInOnTheMap(currentCount);

      // setState(() {
      //   markInProcessing = false;
      // });
      // end of state vars

      // if (reason == "Installation") {
      //   Get.to(
      //     () => InstallationReqDetails(
      //       assigned_product_id: assignedProductId,
      //       customer_id: customerId,
      //       product_id: productId,
      //     ),
      //   );
      // } else if (reason == "Pre Installation") {
      //   Get.to(
      //     () => InstallationReqDetails(
      //       assigned_product_id: assignedProductId,
      //       customer_id: customerId,
      //       product_id: productId,
      //     ),
      //   );
      // } else if (reason == "Service") {
      //   Get.to(
      //     () => ServiceReqDetail(
      //         customer_id: customerId,
      //         product_id: productId,
      //         service_request_id: serviceId,
      //         assignedProductId: assignedProductId),
      //   );
      // }

    } else {
      return;
    }
  }

  serviceresponse(String id, String responsedata) async {
    onserviceresponse(id, responsedata);
  }

  Future<Response> onserviceresponse(id, responsedata) async {
    var reason = prefs.getString(SharedPrefKey.MARK_IN_REASON);
    var productId = prefs.getString(SharedPrefKey.PRODUCTID);
    var customerId = prefs.getString(SharedPrefKey.SELECTED_CUSTOMER);
    var assignedProductId = prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID);

    bool isDeviceOnline = true;

    // bool isDeviceOnline = await checkConnection();
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    print(id);
    progressDialog.show();
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();

        Map<String, dynamic> formData = {
          "service_request_id": id,
          "response": responsedata,
          "customer_id": customerId,
          "product_id": productId,
          'assigned_product_id': assignedProductId
        };

        var onclickresponse = FormData.fromMap(formData);

        Response response =
            await baseApi.dio.post(clickserviceresponse, data: onclickresponse);

        progressDialog.dismiss();
        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE of onserviceresponse :" + parsed.toString());
          String error = parsed["error"].toString();
          print(parsed["status"]);

          if (error == "1") {
            _showMyDialog(context, parsed["status"].toString());
          } else {
//            String error_msg = commonRespo.error_msg;
            displayToast(parsed["status"].toString(), context);
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

  void _showMyDialog(BuildContext context, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Response"),
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

                    servicereqdetail();
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

  Future<Response> servicereqdetail() async {
    var reason = prefs.getString(SharedPrefKey.MARK_IN_REASON);
    var productId = prefs.getString(SharedPrefKey.PRODUCTID);
    var customerId = prefs.getString(SharedPrefKey.SELECTED_CUSTOMER);
    var assignedProductId = prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID);
    var serviceId = prefs.getString(SharedPrefKey.SERVICEENGINEERID);
    String error;
    bool isDeviceOnline = true;

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
          'assigned_product_id': assignedProductId,
          "customer_id": customerId,
          "product_id": productId,
          "service_request_id": serviceId,
        };

        var servicedetailrespo = FormData.fromMap(formData);

        Response response =
            await baseApi.dio.post(serreqdetail, data: servicedetailrespo);

        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPONSE of service req detail:" + parsed.toString());
          error = parsed["error"].toString();
          progressDialog.dismiss();
          if (error == "1") {
            SerReqDetail detail = SerReqDetail.fromJson(parsed);
            print('Details ${detail.serviceProduct.response}');
            // setState(() {
            //   productId = detail.serviceProduct.productId;
            //   product_name = detail.serviceProduct.productName;
            //   product_image = detail.serviceProduct.productImage;
            //   model_no = detail.serviceProduct.modelNo;
            //   brand = detail.serviceProduct.brand;
            //   customerId = detail.serviceProduct.customerId;
            //   customer_name = detail.serviceProduct.customerName;
            //   customer_mobile = detail.serviceProduct.customerMobile;
            //   customer_whatsapp = detail.serviceProduct.customerWhatsapp;
            //   qr_image = detail.serviceProduct.qrImage;
            //   service_status = detail.serviceProduct.serviceStatus;
            //   responses = detail.serviceProduct.response;
            //   serviceRequestId = detail.serviceProduct.serviceRequestId;
            // });
          } else {
//            AllocatedProdListModel allocatedrespo = AllocatedProdListModel.fromJson(parsed);
            //          String error_msg = allocatedrespo.error_msg;
            //        displayToast(error_msg.toString(), context);
          }
        }
        return response;
      } catch (e) {
        // print("RESPOONSE:" + e);
        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      //   displayToast("Please connect to internet", context);
      return null;
    }
  }
}
