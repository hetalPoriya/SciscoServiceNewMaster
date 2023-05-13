import 'dart:convert';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage/ServiceEngDashBoard.dart';
import 'package:scisco_service/Homepage/installationform.dart';
import 'package:scisco_service/Homepage/preinstallationform.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/googleMapScreen/googleMapsScreen.dart';
import 'package:scisco_service/models/installationpending.dart';
import 'package:scisco_service/models/instreqdetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Utils/sizeconfig.dart';
import 'installationreqpending.dart';

class InstallationReqDetails extends StatefulWidget {
  var assigned_product_id = "";

  var customer_id = "";

  var product_id = "";

  InstallationReqDetails(
      {this.assigned_product_id, this.customer_id, this.product_id});

  @override
  _InstallationReqDetailsState createState() => _InstallationReqDetailsState(
      this.assigned_product_id, this.customer_id, this.product_id);
}

class _InstallationReqDetailsState extends State<InstallationReqDetails> {
  var customer_id = "";
  var product_id = "";
  var assigned_product_id = "";
  SharedPreferences prefs;
  bool isLogin;
  var serviceengineerid;
  var serviceengineername;
  String installationpending;
  String installationdone;
  String servicepending;
  String servicedone;
  String error;

  _InstallationReqDetailsState(
      this.assigned_product_id, this.customer_id, this.product_id);

  var customerId = "";
  var customerName = "";
  var customerMobile = "";
  var customerEmail = "";
  var customerWhatsapp = "";
  var productId = "";
  var productName = "";
  var productImage = "";
  var productBrand = "";
  var modelNo = "";
  var assignedOn = "";
  var qrImage = "";
  var installationStatus = "";
  var preInstallation = "";
  var installedAt = "";
  bool timeline = true;
  bool serviceLogs = false;
  bool qrCode = false;

  @override
  void initState() {
    initPrefs();
    instreqdetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = MediaQuery.of(context).size;
    SizeConfig().init(context);
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => ServiceEngDashboard(
                            isLogin,
                            serviceengineerid,
                            serviceengineername,
                            installationpending,
                            installationdone,
                            servicepending,
                            servicedone))));
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: ((context) => ServiceEngDashboard(
                //             isLogin,
                //             serviceengineerid,
                //             serviceengineername,
                //             installationpending,
                //             installationdone,
                //             servicepending,
                //             servicedone))));
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
                          productName ?? '',
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
                          "Customer Name: " + customerName,
                          style: TextStyle(
                              fontFamily: "PriximaNova",
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
                              color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 5.0),
                        child: Text(
                          "Model no: " + modelNo,
                          style: TextStyle(
                              fontFamily: "PriximaNova",
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
                              color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 10.0),
                        child: Text(
                          "Brand: " + productBrand,
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
                              productImage,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace stackTrace) {
                                return Text('Loading Image...');
                              },
                              height: SizeConfig.safeBlockVertical * 25,
                            )),
                      ),
                      (customerName != null &&
                              (customerEmail != null || customerMobile != null))
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
                                          customerName,
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
                                                      customerMobile);
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
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: IconButton(
                                                color: Colors.white,
                                                onPressed: () {
                                                  launch(
                                                      "mailto:$customerEmail");
                                                },
                                                icon:
                                                    Icon(Icons.email_outlined),
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
                                    "Installation Detail",
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
                      Visibility(
                        visible: timeline,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 10.0),
                            child: Column(
                              children: [
                                Row(children: [
                                  preInstallation == "Pending"
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 20.0),
                                          child: Container(
                                              alignment: Alignment.topLeft,
                                              width: size.width * 0.80,
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Please Mark In First to do that !",
                                                      //"Pre Installation is Pending. Please fill the below form to complete Pre Installation",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "PriximaNova",
                                                          fontSize: 14,
                                                          height: 1.3,
                                                          fontWeight: FontWeight
                                                              .normal),
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
                                                                          241,
                                                                          242,
                                                                          243,
                                                                          1.0)),
                                                              textStyle: MaterialStateProperty
                                                                  .all(TextStyle(
                                                                      color: Colors
                                                                          .black))),
                                                          //textColor: Colors.black,
                                                          //color: Color.fromRGBO(241, 242, 243, 1.0),
                                                          onPressed: () async {
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              MapsScreen(),
                                                                    ),
                                                                    (route) =>
                                                                        false);
                                                          },
                                                          child: Text("Go",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  // fontSize: 12,
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontFamily:
                                                                      "PriximaNova")),
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
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25.0, bottom: 8.0, top: 20),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  width: size.width * 0.48,
                                                  child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          WidgetSpan(
                                                              child: Icon(
                                                                  Icons
                                                                      .check_box,
                                                                  color: Colors
                                                                      .green)),
                                                          TextSpan(
                                                              text:
                                                                  '  Pre Installation'),
                                                        ],
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontFamily:
                                                              "WorkSans")),
                                                )
                                              ])),
                                ]),
                                Row(children: [
                                  installationStatus == "Pending" &&
                                          preInstallation == "Done"
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 1, left: 20.0),
                                          child: Container(
                                              alignment: Alignment.center,
                                              width: size.width * 0.80,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Installtion Pending !",
                                                    //"Pre Installation is Pending. Please fill the below form to complete Pre Installation",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "PriximaNova",
                                                        fontSize: 14,
                                                        height: 1.3,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(children: <Widget>[
                                                    Expanded(
                                                      child: TextButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Color
                                                                        .fromRGBO(
                                                                            241,
                                                                            242,
                                                                            243,
                                                                            1.0)),
                                                            textStyle: MaterialStateProperty
                                                                .all(TextStyle(
                                                                    color: Colors
                                                                        .black))),
                                                        //textColor: Colors.black,
                                                        //color: Color.fromRGBO(241, 242, 243, 1.0),
                                                        onPressed: () async {
                                                          Navigator
                                                              .pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            MapsScreen(),
                                                                  ),
                                                                  (route) =>
                                                                      false);
                                                        },
                                                        child: Text("Go",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                // fontSize: 12,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontFamily:
                                                                    "PriximaNova")),
                                                      ),
                                                    ),
                                                  ])
                                                  // Text(
                                                  //   "Installation is Pending. Please fill the below form to complete the Installation",
                                                  //   style: TextStyle(
                                                  //       fontFamily:
                                                  //           "PriximaNova",
                                                  //       fontSize: 14,
                                                  //       height: 1.3,
                                                  //       fontWeight:
                                                  //           FontWeight.normal),
                                                  // ),
                                                  // SizedBox(
                                                  //   height: 10,
                                                  // ),
                                                  // Row(children: <Widget>[
                                                  //   Expanded(
                                                  //     child: TextButton(
                                                  //       style: ButtonStyle(
                                                  //           backgroundColor:
                                                  //               MaterialStateProperty
                                                  //                   .all(Color
                                                  //                       .fromRGBO(
                                                  //                           241,
                                                  //                           242,
                                                  //                           243,
                                                  //                           1.0)),
                                                  //           textStyle: MaterialStateProperty
                                                  //               .all(TextStyle(
                                                  //                   color: Colors
                                                  //                       .black))),
                                                  //       //textColor: Colors.black,
                                                  //       //color: Color.fromRGBO(241, 242, 243, 1.0),
                                                  //       onPressed: () {
                                                  //         Get.dialog(
                                                  //             AlertDialog(
                                                  //           title: Text(
                                                  //               "Are you sure you want to submit Installation Form"),
                                                  //           actions: [
                                                  //             TextButton(
                                                  //               onPressed:
                                                  //                   () async {
                                                  //                 Get.off(
                                                  //                   () => InstallationForm(
                                                  //                       customer_id,
                                                  //                       product_id,
                                                  //                       assigned_product_id),
                                                  //                 );
                                                  //               },
                                                  //               child: Text(
                                                  //                 "Yes",
                                                  //               ),
                                                  //             ),
                                                  //             TextButton(
                                                  //               onPressed: () =>
                                                  //                   {
                                                  //                 Get.back(),
                                                  //               },
                                                  //               child: Text(
                                                  //                 "No",
                                                  //               ),
                                                  //             )
                                                  //           ],
                                                  //         ));
                                                  //       },
                                                  //       child: Text(
                                                  //           "Installation Form",
                                                  //           textAlign: TextAlign
                                                  //               .center,
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
                                                ],
                                              )),
                                        )
                                      : Wrap(),
                                  installationStatus == "Installed" &&
                                          preInstallation == "Done"
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25.0, bottom: 8.0, top: 5),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  width: size.width * 0.58,
                                                  child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          WidgetSpan(
                                                              child: Icon(
                                                                  Icons
                                                                      .check_box,
                                                                  color: Colors
                                                                      .green)),
                                                          TextSpan(
                                                              text:
                                                                  '  Installation Status'),
                                                        ],
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontFamily:
                                                              "WorkSans")),
                                                )
                                              ]))
                                      : Wrap(),
                                ])
                              ],
                            )),
                      ),
                      Visibility(
                        visible: qrCode,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(25.0, 30.0, 0.0, 10.0),
                          child: Align(
                              alignment: Alignment.center,
                              child: CachedNetworkImage(
                                imageUrl: qrImage,
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
    fontSize: 17.0,
    fontWeight: FontWeight.w800,
  );

  Future<Response> instreqdetail() async {
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
          "customer_id": customer_id,
          "product_id": product_id,
          'assigned_product_id':
              prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID)
        };
        print('FormData ${formData.toString()}');

        var insdetailrespo = FormData.fromMap(formData);

        Response response =
            await baseApi.dio.post(insdetail, data: insdetailrespo);

        print('ResponseData ${response}');
        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPONSE of installation req detail:" + parsed.toString());
          error = parsed["error"].toString();
          progressDialog.dismiss();
          if (error == "1") {
            InstallationReqDetail detail =
                InstallationReqDetail.fromJson(parsed);
            print(detail.installationProduct.productName);
            setState(() {
              customerId = detail.installationProduct.customerId;
              customerName = detail.installationProduct.customerName;
              customerMobile = detail.installationProduct.customerMobile;
              customerEmail = detail.installationProduct.customerEmail;
              customerWhatsapp = detail.installationProduct.customerWhatsapp;
              productId = detail.installationProduct.productId;
              productName = detail.installationProduct.productName;
              productImage = detail.installationProduct.productImage;
              productBrand = detail.installationProduct.productBrand;
              modelNo = detail.installationProduct.modelNo;
              assignedOn = detail.installationProduct.assignedOn;
              qrImage = detail.installationProduct.qrImage;
              installationStatus =
                  detail.installationProduct.installationStatus;
              preInstallation = detail.installationProduct.preInstallation;
              installedAt = detail.installationProduct.installedAt;
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
