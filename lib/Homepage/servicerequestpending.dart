import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/route_manager.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage/ServiceEngDashBoard.dart';
import 'package:scisco_service/Homepage/components/comman_widget.dart';
import 'package:scisco_service/Homepage/servicereqdetail.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/Utils/sizeconfig.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/main.dart';
import 'package:scisco_service/models/response_model.dart';
import 'package:scisco_service/models/servicepending.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ServiceRequestPending extends StatefulWidget {
  @override
  _ServiceRequestPendingState createState() => _ServiceRequestPendingState();
}

class _ServiceRequestPendingState extends State<ServiceRequestPending> {
  List<ServiceRequest> servicerequestlist = [];

  SharedPreferences prefs;
  bool isLogin;
  var serviceengineerid;
  var serviceengineername;
  String installationpending;
  String installationdone;
  String servicepending;
  String servicedone;
  bool isImageLoading = true;
  bool isLoading = true;
  ResponseData responseData;

  @override
  void initState() {
    initPrefs();
    servicerequests();
    unloadImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = MediaQuery.of(context).size;
    SizeConfig().init(context);

    var index = servicerequestlist.length;
    return new WillPopScope(
        onWillPop: () {
          _willPopCallback();
        },
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
              "Service Requests Pending",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: "PriximaNova"),
            ),
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
          body: Container(
              height: size.height * 0.85,
              child: isLoading == true
                  ? Container()
                  : responseData.error == 1
                      ? servicerequestlist.length == 0
                          ? Center(child: Text('Product not found'))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: servicerequestlist.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        25.0, 5.0, 20.0, 5.0),
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      height: servicerequestlist[index]
                                                  .productId
                                                  .isNotEmpty &&
                                              servicerequestlist[index]
                                                      .productId !=
                                                  "0" &&
                                              servicerequestlist[index]
                                                  .customerId
                                                  .isNotEmpty &&
                                              servicerequestlist[index]
                                                      .customerId !=
                                                  "0"
                                          ? size.height * 0.180
                                          : size.height * 0.13,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: HexColor("#FFFFFF"),
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        color: HexColor("#FFFFFF"),
                                        elevation: 4,
                                        child: InkWell(
                                          onTap: () {
                                            prefs.setString(
                                                SharedPrefKey.ASSIGNEDPRODUCTID,
                                                servicerequestlist[index]
                                                    .assignedProductId);
                                            Get.to(
                                              () => ServiceReqDetail(
                                                customer_id:
                                                    servicerequestlist[index]
                                                        .customerId,
                                                product_id:
                                                    servicerequestlist[index]
                                                        .productId,
                                                service_request_id:
                                                    servicerequestlist[index]
                                                        .serviceRequestId,
                                                assignedProductId:
                                                    servicerequestlist[index]
                                                            .assignedProductId ??
                                                        '',
                                              ),
                                            );
                                            // navigator.pushReplacement(MaterialPageRoute(
                                            //     builder: (BuildContext ctx) =>
                                          },
                                          child: Container(
                                              child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                height:
                                                    mediaQueryData.size.height /
                                                        5.0,
                                                width:
                                                    mediaQueryData.size.width /
                                                        4.0,
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 10,
                                                ),
                                                child: Image.network(
                                                  servicerequestlist[index]
                                                      .productImage,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace stackTrace) {
                                                    print(exception);
                                                    return Image.asset(
                                                        'placeholder.gif');
                                                  },
                                                  loadingBuilder:
                                                      (BuildContext ctx,
                                                          Widget child,
                                                          ImageChunkEvent
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    } else {
                                                      return Shimmer(
                                                        duration: Duration(
                                                          seconds: 1,
                                                        ),
                                                        //Default value
                                                        interval: Duration(
                                                            seconds: 1),
                                                        //Default value: Duration(seconds: 0)
                                                        color: Color.fromARGB(
                                                            255, 63, 61, 61),
                                                        //Default value
                                                        colorOpacity: 0,
                                                        //Default value
                                                        enabled: true,
                                                        //Default value
                                                        direction:
                                                            ShimmerDirection
                                                                .fromLTRB(),
                                                        //Default Value
                                                        child: Container(
                                                          color: Color.fromARGB(
                                                              255,
                                                              238,
                                                              238,
                                                              238),
                                                          height: mediaQueryData
                                                                  .size.height /
                                                              5.0,
                                                          width: mediaQueryData
                                                                  .size.width /
                                                              4.0,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  height: mediaQueryData
                                                          .size.height /
                                                      5.0,
                                                  width: mediaQueryData
                                                          .size.width /
                                                      4.0,
                                                ), /*isImageLoading
                                            ? Shimmer(
                                          duration: Duration(
                                            seconds: 1,
                                          ), //Default value
                                          interval: Duration(
                                              seconds:
                                              1), //Default value: Duration(seconds: 0)
                                          color: Color.fromARGB(
                                              255,
                                              63,
                                              61,
                                              61), //Default value
                                          colorOpacity:
                                          0, //Default value
                                          enabled:
                                          true, //Default value
                                          direction: ShimmerDirection
                                              .fromLTRB(), //Default Value
                                          child: Container(
                                            color: Color.fromARGB(
                                                255,
                                                238,
                                                238,
                                                238),
                                            width: 130,
                                            height: 100,
                                          ),
                                        )
                                            : Container(
                                            height: mediaQueryData
                                                .size.height /
                                                5.0,
                                            width: mediaQueryData
                                                .size.width /
                                                4.0,
                                            decoration:
                                            BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius
                                                        .circular(
                                                        10),
                                                    topRight: Radius
                                                        .circular(
                                                        10)),
                                                image:
                                                DecorationImage(
                                                    image:
                                                    NetworkImage(
                                                      servicerequestlist[index]
                                                          .productImage,
                                                    ),
                                                    fit: BoxFit
                                                        .cover)))*/
                                              ),
                                              Container(
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        width: SizeConfig
                                                                .safeBlockHorizontal *
                                                            43,
                                                        child: Text(
                                                            '${servicerequestlist[index].productName}',
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                color: AppTheme
                                                                    .textcolor,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontFamily:
                                                                    "ProximaNova")),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Container(
                                                        width: SizeConfig
                                                                .safeBlockHorizontal *
                                                            43,
                                                        child: Text(
                                                            'Model No: ${servicerequestlist[index].modelNo}',
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "ProximaNova")),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Container(
                                                        width: SizeConfig
                                                                .safeBlockHorizontal *
                                                            43,
                                                        child: Text(
                                                            'Brand: ${servicerequestlist[index].brand}',
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "ProximaNova")),
                                                      ),
                                                    ],
                                                  ))
                                            ],
                                          )),
                                        ),
                                      ),
                                    ));
                              },
                            )
                      : responseData.status == 'No requests yet'
                          ? Center(child: Text('No requests yet'))
                          : CommanWidget.punchOutWidget(size: size)),
        ));
  }

  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    Get.back();
    // navigator.pushReplacement(MaterialPageRoute(
    //     builder: (BuildContext ctx) => ServiceEngDashboard(
    //         true,
    //         serviceengineerid,
    //         serviceengineername,
    //         installationpending,
    //         installationdone,
    //         servicepending,
    //         servicedone)));

    return false; // return true if the route to be popped
  }

  Future<Response> servicerequests() async {
    bool isDeviceOnline = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //   bool isDeviceOnline = await checkConnection();
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    progressDialog.show();
    setState(() {
      isLoading = true;
    });
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();

        Map<String, dynamic> formData = {
          "service_engineer_id":
              prefs.getString(SharedPrefKey.SERVICEENGINEERID)
        };

        var servicerespo = FormData.fromMap(formData);

        Response response =
            await baseApi.dio.post(servicereqpending, data: servicerespo);

        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPONSE of service request list: " + parsed.toString());
          // String error = parsed["error"].toString();
          responseData = ResponseData.fromMap(jsonDecode(response.data));
          isLoading = false;
          setState(() {});

          progressDialog.dismiss();

          if (responseData.error == 1) {
            ServicePending servicerespo = ServicePending.fromJson(parsed);

            servicerequestlist = servicerespo.serviceRequest;
          } else {
            isLoading = false;
            servicerequestlist = [];
            //Fluttertoast.showToast(msg: responseData.status.toString() ?? '');
            //  AllocatedProdListModel allocatedrespo = AllocatedProdListModel.fromJson(parsed);
            //  String error_msg = allocatedrespo.error_msg;
            // displayToast(parsed["status"].toString(), context);
          }
        }
        return response;
      } catch (e) {
//        print("RESPOONSE:" + e);
        //      displayToast("Something went wrong", context);
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

  void unloadImages() async {
    await 5.delay();
    if (this.mounted) {
      setState(() {
        isImageLoading = false;
      });
    }
  }
}
