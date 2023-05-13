import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage/ServiceEngDashBoard.dart';
import 'package:scisco_service/Homepage/allocatedprodetail.dart';
import 'package:scisco_service/Homepage/installationform.dart';
import 'package:scisco_service/Homepage/serviceform.dart';
import 'package:scisco_service/Homepage/servicerequestdone.dart';
import 'package:scisco_service/Homepage/webserviceform.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/Utils/sizeconfig.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/googleMapScreen/googleMapsScreen.dart';
import 'package:scisco_service/models/ServicereqDetail.dart';
import 'package:scisco_service/models/servicedone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceReqDetail extends StatefulWidget {
  var customer_id = "";
  var product_id = "";
  var service_request_id = "";
  var assignedProductId = "";

  ServiceReqDetail(
      {this.customer_id,
      this.product_id,
      this.service_request_id,
      this.assignedProductId});

  @override
  _ServiceReqDetailState createState() => _ServiceReqDetailState(
      this.customer_id,
      this.product_id,
      this.service_request_id,
      this.assignedProductId);
}

class _ServiceReqDetailState extends State<ServiceReqDetail> {
  var customer_id = "";
  var product_id = "";
  var service_request_id = "";
  var assignedProductId = "";
  SharedPreferences prefs;
  bool isLogin;
  var serviceengineerid;
  var serviceengineername;
  String installationpending;
  String installationdone;
  String servicepending;
  String servicedone;
  String error;

  _ServiceReqDetailState(this.customer_id, this.product_id,
      this.service_request_id, this.assignedProductId);

  var productId = "";
  var product_name = "";
  var product_image = "";
  var model_no = "";
  var brand = "";
  var customerId = "";
  var customer_name = "";
  var customer_mobile = "";
  var customer_whatsapp = "";
  var qr_image = "";
  var service_status = "";
  var responses = "";
  var serviceRequestId = "";
  bool timeline = true;
  bool serviceLogs = false;
  bool qrCode = false;

  @override
  void initState() {
    initPrefs();
    servicereqdetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppTheme.textcolor, //change your color here
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        brightness: Brightness.light,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(23.0, 5.0, 0.0, 0.0),
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () async {
                Get.back();
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
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(25.0, 15.0, 0.0, 10.0),
                        child: Text(
                          product_name ?? '',
                          style: TextStyle(
                              fontFamily: "PriximaNova",
                              fontSize: SizeConfig.safeBlockHorizontal * 7,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 5.0),
                        child: Text(
                          "Customer Name: " + customer_name,
                          style: TextStyle(
                              fontFamily: "PriximaNova",
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
                              color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 5.0),
                        child: Text(
                          "Model no: " + model_no,
                          style: TextStyle(
                              fontFamily: "PriximaNova",
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
                              color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 10.0),
                        child: Text(
                          "Brand: " + brand,
                          style: TextStyle(
                              fontFamily: "PriximaNova",
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
                              color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(25.0, 30.0, 0.0, 10.0),
                        child: Align(
                            alignment: Alignment.center,
                            child: Image.network(
                              product_image,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace stackTrace) {
                                return Text('Loading Image...');
                              },
                              height: SizeConfig.safeBlockVertical * 25,
                            )),
                      ),
                      (customer_name != null &&
                              (customer_mobile != null ||
                                  customer_whatsapp != null))
                          ? Padding(
                              padding:
                                  EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 0.0),
                              child: Card(
                                  color: Color.fromRGBO(241, 242, 243, 1.0),
                                  shadowColor:
                                      Color.fromRGBO(241, 242, 243, 1.0),
                                  elevation: 4,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        15.0, 15.0, 0.0, 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [],
                                        ),
                                        Text(
                                          "Customer name",
                                          style: TextStyle(
                                              fontFamily: 'PriximaNova',
                                              fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                  4,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          customer_name,
                                          style: TextStyle(
                                              fontFamily: 'PriximaNova',
                                              fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                  3.5,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Ink(
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: IconButton(
                                                color: Colors.white,
                                                onPressed: () {
                                                  launch("http://wa.me/91" +
                                                      customer_whatsapp);
                                                },
                                                icon: Icon(Icons.whatsapp),
                                              ),
                                            ),
                                            SizedBox(
                                              width: SizeConfig
                                                      .safeBlockHorizontal *
                                                  3,
                                            ),
                                            Ink(
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: IconButton(
                                                color: Colors.white,
                                                onPressed: () {
                                                  launch(
                                                      "tel:$customer_mobile");
                                                },
                                                icon: Icon(Icons.phone),
                                              ),
                                            ),
                                          ],
                                        ),
                                        //Text(service_logs[i]['service_done_at']),
                                      ],
                                    ),
                                  )),
                            )
                          : SizedBox(),
                      Padding(
                          padding: EdgeInsets.fromLTRB(40.0, 30.0, 0.0, 10.0),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                  child: Text(
                                    "Service Request Detail",
                                    style: TextStyle(
                                        fontFamily: "PriximaNova",
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal * 4,
                                        color: timeline == true
                                            ? Colors.black
                                            : Colors.grey,
                                        fontWeight: timeline == true
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      timeline = true;
                                      serviceLogs = false;
                                      qrCode = false;
                                    });
                                  },
                                )),
                                Expanded(
                                    child: GestureDetector(
                                  child: Text(
                                    "QR Code",
                                    style: TextStyle(
                                        fontFamily: "PriximaNova",
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal * 4,
                                        color: qrCode == true
                                            ? Colors.black
                                            : Colors.grey,
                                        fontWeight: qrCode == true
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      qrCode = true;
                                      serviceLogs = false;
                                      timeline = false;
                                    });
                                  },
                                )),
                              ])),
                      Padding(
                        padding: EdgeInsets.fromLTRB(40.0, 10.0, 0.0, 10.0),
                        child: Container(
                            alignment: Alignment.topLeft,
                            width: size.width * 0.80,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Please Mark In First to do that !",
                                    //"Pre Installation is Pending. Please fill the below form to complete Pre Installation",
                                    style: TextStyle(
                                        fontFamily: "PriximaNova",
                                        fontSize: 14,
                                        height: 1.3,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(children: <Widget>[
                                    Expanded(
                                      child: TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color.fromRGBO(
                                                        241, 242, 243, 1.0)),
                                            textStyle:
                                                MaterialStateProperty.all(
                                                    TextStyle(
                                                        color: Colors.black))),
                                        //textColor: Colors.black,
                                        //color: Color.fromRGBO(241, 242, 243, 1.0),
                                        onPressed: () async {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MapsScreen(),
                                              ),
                                              (route) => false);
                                        },
                                        child: Text("Go",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                // fontSize: 12,
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "PriximaNova")),
                                      ),
                                    ),
                                  ])
                                  // Row(children: <Widget>[
                                  //   Expanded(
                                  //     child: TextButton(
                                  //       style: ButtonStyle(
                                  //           backgroundColor:
                                  //               MaterialStateProperty.all(
                                  //                   Color.fromRGBO(
                                  //                       241,
                                  //                       242,
                                  //                       243,
                                  //                       1.0)),
                                  //           textStyle: MaterialStateProperty
                                  //               .all(TextStyle(
                                  //                   color: Colors
                                  //                       .black))),
                                  //       //textColor: Colors.black,
                                  //       //color: Color.fromRGBO(241, 242, 243, 1.0),
                                  //       onPressed: () async {
                                  //         Get.dialog(
                                  //             AlertDialog(
                                  //               title: Text(
                                  //                   "Are you sure you want to submit Pre Installation Form"),
                                  //               actions: [
                                  //                 ElevatedButton(
                                  //                   onPressed:
                                  //                       () async {
                                  //                     Get.off(
                                  //                       () => PreInstallationForm(
                                  //                           customer_id,
                                  //                           product_id,
                                  //                           assigned_product_id),
                                  //                     );
                                  //                   },
                                  //                   child:
                                  //                       Text(
                                  //                     "Yes",
                                  //                   ),
                                  //                 ),
                                  //                 ElevatedButton(
                                  //                   onPressed:
                                  //                       () =>
                                  //                           {
                                  //                     Get.back(),
                                  //                   },
                                  //                   child:
                                  //                       Text(
                                  //                     "No",
                                  //                   ),
                                  //                 )
                                  //               ],
                                  //             ),
                                  //             barrierDismissible:
                                  //                 false);
                                  //       },
                                  //       child: Text(
                                  //           "Pre Installation Form",
                                  //           textAlign:
                                  //               TextAlign
                                  //                   .center,
                                  //           style: TextStyle(
                                  //               fontSize: 12,
                                  //               color: Colors
                                  //                   .black,
                                  //               fontWeight:
                                  //                   FontWeight
                                  //                       .w700,
                                  //               fontFamily:
                                  //                   "PriximaNova")),
                                  //     ),
                                  //   ),
                                  // ])
                                ])),
                      ),
                      // Visibility(
                      //   visible: timeline,
                      //   child: Padding(
                      //       padding:
                      //           EdgeInsets.fromLTRB(25.0, 20.0, 20.0, 80.0),
                      //       child: Card(
                      //           shadowColor: Color.fromRGBO(231, 232, 233, 1.0),
                      //           elevation: 4,
                      //           child: Padding(
                      //               padding: EdgeInsets.fromLTRB(
                      //                   15.0, 15.0, 0.0, 10.0),
                      //               child: Column(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.start,
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.start,
                      //                 children: [
                      //                   service_status == "Done"
                      //                       ? Container(
                      //                           width: size.width * 0.35,
                      //                           child: Padding(
                      //                               padding:
                      //                                   EdgeInsets.fromLTRB(
                      //                                       20.0,
                      //                                       0.0,
                      //                                       0.0,
                      //                                       5.0),
                      //                               child: Column(
                      //                                 mainAxisAlignment:
                      //                                     MainAxisAlignment
                      //                                         .start,
                      //                                 crossAxisAlignment:
                      //                                     CrossAxisAlignment
                      //                                         .start,
                      //                                 children: [
                      //                                   Text(
                      //                                     "Service Status",
                      //                                     style: TextStyle(
                      //                                         fontFamily:
                      //                                             "PriximaNova",
                      //                                         fontSize: SizeConfig
                      //                                                 .safeBlockHorizontal *
                      //                                             4,
                      //                                         color:
                      //                                             Colors.black,
                      //                                         fontWeight:
                      //                                             FontWeight
                      //                                                 .bold),
                      //                                   ),
                      //                                   Text(
                      //                                     service_status,
                      //                                     style: TextStyle(
                      //                                       fontFamily:
                      //                                           "PriximaNova",
                      //                                       fontSize: SizeConfig
                      //                                               .safeBlockHorizontal *
                      //                                           4,
                      //                                       color: Colors.grey,
                      //                                     ),
                      //                                   ),
                      //                                 ],
                      //                               )),
                      //                         )
                      //                       : Wrap(),
                      //                   SizedBox(
                      //                     height: 5,
                      //                   ),
                      //                   service_status == "Done"
                      //                       ? SizedBox(height: 5)
                      //                       : Wrap(),
                      //                   responses != null
                      //                       ? Container(
                      //                           child: Padding(
                      //                               padding:
                      //                                   EdgeInsets.fromLTRB(
                      //                                       20.0,
                      //                                       0.0,
                      //                                       0.0,
                      //                                       5.0),
                      //                               child: Column(
                      //                                 mainAxisAlignment:
                      //                                     MainAxisAlignment
                      //                                         .start,
                      //                                 crossAxisAlignment:
                      //                                     CrossAxisAlignment
                      //                                         .start,
                      //                                 children: [
                      //                                   Text(
                      //                                     "Responses",
                      //                                     style: TextStyle(
                      //                                         fontFamily:
                      //                                             "PriximaNova",
                      //                                         fontSize: SizeConfig
                      //                                                 .safeBlockHorizontal *
                      //                                             4,
                      //                                         color:
                      //                                             Colors.black,
                      //                                         fontWeight:
                      //                                             FontWeight
                      //                                                 .bold),
                      //                                   ),
                      //                                   Text(
                      //                                     responses,
                      //                                     style: TextStyle(
                      //                                       fontFamily:
                      //                                           "PriximaNova",
                      //                                       fontSize: SizeConfig
                      //                                               .safeBlockHorizontal *
                      //                                           4,
                      //                                       color: Colors.grey,
                      //                                     ),
                      //                                   ),
                      //                                 ],
                      //                               )))
                      //                       : Wrap(),
                      //                   Row(children: [
                      //                     Padding(
                      //                       padding: const EdgeInsets.only(
                      //                           top: 0, left: 30.0),
                      //                       child: Row(
                      //                         children: [
                      //                           service_status == "Pending"
                      //                               ? Container(
                      //                                   alignment:
                      //                                       Alignment.topLeft,
                      //                                   width:
                      //                                       size.width * 0.30,
                      //                                   child: Row(
                      //                                       children: <Widget>[
                      //                                         Expanded(
                      //                                           child:
                      //                                               TextButton(
                      //                                             style: ButtonStyle(
                      //                                                 backgroundColor: MaterialStateProperty.all(Color.fromRGBO(
                      //                                                     241,
                      //                                                     242,
                      //                                                     243,
                      //                                                     1.0)),
                      //                                                 textStyle:
                      //                                                     MaterialStateProperty.all(
                      //                                                         TextStyle(color: Colors.black))),
                      //                                             //textColor: Colors.black,
                      //                                             //color: Color.fromRGBO(241, 242, 243, 1.0),
                      //                                             onPressed:
                      //                                                 () async {
                      //                                               Get.dialog(
                      //                                                   AlertDialog(
                      //                                                 title: Text(
                      //                                                     "Are you sure you want to submit Resolved on call"),
                      //                                                 actions: [
                      //                                                   ElevatedButton(
                      //                                                     onPressed:
                      //                                                         () async {
                      //                                                       Get.back();
                      //                                                       // print('Called');
                      //                                                       // Get.off(() => ServiceForm(
                      //                                                       //     customer_id,
                      //                                                       //     product_id,
                      //                                                       //     assignedProductId));
                      //                                                       // servicereqdetail();
                      //                                                       await serviceresponse(service_request_id,
                      //                                                           "Resolved on call");
                      //                                                       Navigator.pushAndRemoveUntil(
                      //                                                           context,
                      //                                                           MaterialPageRoute(builder: (context) => ServiceRequest()),
                      //                                                           (route) => false);
                      //                                                     },
                      //                                                     child:
                      //                                                         Text(
                      //                                                       "Yes",
                      //                                                     ),
                      //                                                   ),
                      //                                                   ElevatedButton(
                      //                                                     onPressed:
                      //                                                         () => {
                      //                                                       Get.back(),
                      //                                                     },
                      //                                                     child:
                      //                                                         Text(
                      //                                                       "No",
                      //                                                     ),
                      //                                                   )
                      //                                                 ],
                      //                                               ));
                      //                                             },
                      //                                             child: Text(
                      //                                                 "Resolved on call",
                      //                                                 textAlign:
                      //                                                     TextAlign
                      //                                                         .center,
                      //                                                 style: TextStyle(
                      //                                                     fontSize:
                      //                                                         14,
                      //                                                     color: Colors
                      //                                                         .black,
                      //                                                     fontWeight: FontWeight
                      //                                                         .w700,
                      //                                                     fontFamily:
                      //                                                         "PriximaNova")),
                      //                                           ),
                      //                                         ),
                      //                                       ]))
                      //                               : Wrap(),
                      //                           SizedBox(width: 5),
                      //                           service_status == "Pending" &&
                      //                                   responses == null
                      //                               ? Container(
                      //                                   alignment:
                      //                                       Alignment.center,
                      //                                   width:
                      //                                       size.width * 0.30,
                      //                                   child: Row(
                      //                                       children: <Widget>[
                      //                                         Expanded(
                      //                                           child:
                      //                                               TextButton(
                      //                                             style: ButtonStyle(
                      //                                                 backgroundColor: MaterialStateProperty.all(Color.fromRGBO(
                      //                                                     241,
                      //                                                     242,
                      //                                                     243,
                      //                                                     1.0)),
                      //                                                 textStyle:
                      //                                                     MaterialStateProperty.all(
                      //                                                         TextStyle(color: Colors.black))),
                      //                                             //textColor: Colors.black,
                      //                                             //color: Color.fromRGBO(241, 242, 243, 1.0),
                      //                                             onPressed:
                      //                                                 () async {
                      //                                               Get.dialog(
                      //                                                   AlertDialog(
                      //                                                 title: Text(
                      //                                                     "Are you sure you want to submit Site visit required"),
                      //                                                 actions: [
                      //                                                   ElevatedButton(
                      //                                                     onPressed:
                      //                                                         () async {
                      //                                                       Get.back();
                      //                                                       // Get.off(() => ServiceForm(
                      //                                                       //     customer_id,
                      //                                                       //     product_id,
                      //                                                       //     assignedProductId));
                      //                                                       await serviceresponse(service_request_id,
                      //                                                           "Site visit required");
                      //                                                       Navigator.pushAndRemoveUntil(
                      //                                                           context,
                      //                                                           MaterialPageRoute(builder: (context) => ServiceRequest()),
                      //                                                           (route) => false);
                      //                                                     },
                      //                                                     child:
                      //                                                         Text(
                      //                                                       "Yes",
                      //                                                     ),
                      //                                                   ),
                      //                                                   ElevatedButton(
                      //                                                     onPressed:
                      //                                                         () => {
                      //                                                       Get.back(),
                      //                                                     },
                      //                                                     child:
                      //                                                         Text(
                      //                                                       "No",
                      //                                                     ),
                      //                                                   )
                      //                                                 ],
                      //                                               ));
                      //                                               // navigator.pushAndRemoveUntil(
                      //                                               //     context,
                      //                                               //     MaterialPageRoute(builder: (BuildContext context) => InstallationForm(customer_id,product_id)),
                      //                                               //         (route) => false);
                      //                                             },
                      //                                             child: Text(
                      //                                                 "Site visit required",
                      //                                                 textAlign:
                      //                                                     TextAlign
                      //                                                         .center,
                      //                                                 style: TextStyle(
                      //                                                     fontSize:
                      //                                                         14,
                      //                                                     color: Colors
                      //                                                         .black,
                      //                                                     fontWeight: FontWeight
                      //                                                         .w700,
                      //                                                     fontFamily:
                      //                                                         "PriximaNova")),
                      //                                           ),
                      //                                         ),
                      //                                       ]))
                      //                               : service_status ==
                      //                                           "Pending" &&
                      //                                       responses ==
                      //                                           "Site visit required"
                      //                                   ? Container(
                      //                                       margin:
                      //                                           EdgeInsets.only(
                      //                                               top: 10),
                      //                                       alignment: Alignment
                      //                                           .center,
                      //                                       width: size.width *
                      //                                           0.30,
                      //                                       child: Row(
                      //                                           children: <
                      //                                               Widget>[
                      //                                             Expanded(
                      //                                               child:
                      //                                                   TextButton(
                      //                                                 style: ButtonStyle(
                      //                                                     backgroundColor: MaterialStateProperty.all(Color.fromRGBO(
                      //                                                         241,
                      //                                                         242,
                      //                                                         243,
                      //                                                         1.0)),
                      //                                                     textStyle:
                      //                                                         MaterialStateProperty.all(TextStyle(color: Colors.black))),
                      //                                                 //textColor: Colors.black,
                      //                                                 //color: Color.fromRGBO(241, 242, 243, 1.0),
                      //                                                 onPressed:
                      //                                                     () async {
                      //                                                   Get.dialog(
                      //                                                       AlertDialog(
                      //                                                     title:
                      //                                                         Text("Are you sure you want to submit Service Forms"),
                      //                                                     actions: [
                      //                                                       ElevatedButton(
                      //                                                         onPressed: () async {
                      //                                                           Get.to(
                      //                                                             () =>
                      //                                                                 // ServiceForm(customer_id, product_id, assignedProductId, service_request_id)
                      //                                                                 WebServiceForm(
                      //                                                               customer_id,
                      //                                                               product_id,
                      //                                                               service_request_id,
                      //                                                             ),
                      //                                                           );
                      //                                                         },
                      //                                                         child: Text(
                      //                                                           "Yes",
                      //                                                         ),
                      //                                                       ),
                      //                                                       ElevatedButton(
                      //                                                         onPressed: () => {
                      //                                                           Get.back(),
                      //                                                         },
                      //                                                         child: Text(
                      //                                                           "No",
                      //                                                         ),
                      //                                                       )
                      //                                                     ],
                      //                                                   ));
                      //                                                 },
                      //                                                 child: Text(
                      //                                                     "Service Forms",
                      //                                                     textAlign: TextAlign
                      //                                                         .center,
                      //                                                     style: TextStyle(
                      //                                                         fontSize: 14,
                      //                                                         color: Colors.black,
                      //                                                         fontWeight: FontWeight.w700,
                      //                                                         fontFamily: "PriximaNova")),
                      //                                               ),
                      //                                             ),
                      //                                           ]))
                      //                                   : Wrap(),
                      //                         ],
                      //                       ),
                      //                     )
                      //                   ]),
                      //                 ],
                      //               )))),
                      // ),
                      Visibility(
                        visible: qrCode,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 30.0, 0.0, 10.0),
                          child: Align(
                              alignment: Alignment.center,
                              child: CachedNetworkImage(
                                imageUrl: qr_image,
                                placeholder: (context, url) => Image.asset(
                                  "assets/images/qrLoading.gif",
                                ),
                                height: SizeConfig.safeBlockVertical * 25,
                              )),
                        ),
                      )
                    ]),
              )),
            ),
          ],
        ),
      ),
    );
  }

  static var _customTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: AppTheme.fontName,
    fontSize: 15.0,
    fontWeight: FontWeight.w800,
  );

  serviceresponse(String id, String responsedata) async {
    onserviceresponse(id, responsedata);
  }

  Future<Response> onserviceresponse(id, responsedata) async {
    bool isDeviceOnline = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
          "customer_id": customer_id,
          "product_id": product_id,
          'assigned_product_id':
              prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID)
        };

        var onclickresponse = FormData.fromMap(formData);
        print(formData);

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
          'assigned_product_id': assignedProductId,
          "customer_id": customer_id,
          "product_id": product_id,
          "service_request_id": service_request_id
        };
        print(formData.toString());

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
            setState(() {
              productId = detail.serviceProduct.productId;
              product_name = detail.serviceProduct.productName;
              product_image = detail.serviceProduct.productImage;
              model_no = detail.serviceProduct.modelNo;
              brand = detail.serviceProduct.brand;
              customerId = detail.serviceProduct.customerId;
              customer_name = detail.serviceProduct.customerName;
              customer_mobile = detail.serviceProduct.customerMobile;
              customer_whatsapp = detail.serviceProduct.customerWhatsapp;
              qr_image = detail.serviceProduct.qrImage;
              service_status = detail.serviceProduct.serviceStatus;
              responses = detail.serviceProduct.response;
              serviceRequestId = detail.serviceProduct.serviceRequestId;
            });
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
}

Widget callButton({String infoText, String infoTitle, int detailSize}) {
  return ElevatedButton.icon(
    onPressed: () => {
      launch("tel:$infoText"),
    },
    icon: Icon(
      Icons.call,
    ),
    label: Text(infoText),
  );
}

Widget whatsappButton({String infoText, String infoTitle, int detailSize}) {
  return ElevatedButton.icon(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
    ),
    onPressed: () => {
      launch("http://wa.me/91" + infoText),
    },
    icon: Icon(
      Icons.whatsapp,
    ),
    label: Text(
      infoText,
    ),
  );
}

Widget emailButton({String infoText, String infoTitle, int detailSize}) {
  return ElevatedButton.icon(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
    ),
    onPressed: () => {
      launch("mailto:$infoText"),
    },
    icon: Icon(
      Icons.email_outlined,
    ),
    label: Text(
      infoText,
    ),
  );
}
