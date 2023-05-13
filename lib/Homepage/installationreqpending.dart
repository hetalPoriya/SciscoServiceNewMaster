import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:scisco_service/Homepage/ServiceEngDashBoard.dart';
import 'package:scisco_service/Homepage/components/comman_widget.dart';
import 'package:toast/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/route_manager.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage/installationdetails.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/Utils/sizeconfig.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/main.dart';
import 'package:scisco_service/models/installationpending.dart';
import 'package:scisco_service/models/response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:toast/toast.dart';

class InstallationRequestPending extends StatefulWidget {
  @override
  _InstallationRequestPendingState createState() =>
      _InstallationRequestPendingState();
}

class _InstallationRequestPendingState
    extends State<InstallationRequestPending> {
  List<Installations> installationrequestlist = [];
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
    insrequests();
    unloadImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = MediaQuery.of(context).size;
    var index = installationrequestlist.length;
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
          title: Text(
            "Installation Pending",
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
          height: size.height * 0.80,
          child: isLoading == true
              ? Container()
              : responseData.error == 1
                  ? installationrequestlist.length == 0
                      ? Center(child: Text('Product not found'))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: installationrequestlist.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding:
                                    EdgeInsets.fromLTRB(25.0, 5.0, 20.0, 5.0),
                                child: Container(
                                    height: installationrequestlist[index]
                                                    .customerId !=
                                                "0" &&
                                            installationrequestlist[index]
                                                    .productId !=
                                                "0"
                                        ? size.height * 0.180
                                        : size.height * 0.13,
                                    child: Card(
                                      shape: new RoundedRectangleBorder(
                                          side: new BorderSide(
                                              color: HexColor("#FFFFFF"),
                                              width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      color: HexColor("#FFFFFF"),
                                      elevation: 4.0,
                                      child: Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.topCenter,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  prefs.setString(
                                                      SharedPrefKey
                                                          .ASSIGNEDPRODUCTID,
                                                      installationrequestlist[
                                                              index]
                                                          .assignedProductId
                                                          .toString());

                                                  Get.to(
                                                    () =>
                                                        InstallationReqDetails(
                                                      assigned_product_id:
                                                          installationrequestlist[
                                                                      index]
                                                                  .assignedProductId
                                                                  .toString() ??
                                                              '',
                                                      customer_id:
                                                          installationrequestlist[
                                                                      index]
                                                                  .customerId
                                                                  .toString() ??
                                                              '',
                                                      product_id:
                                                          installationrequestlist[
                                                                      index]
                                                                  .productId
                                                                  .toString() ??
                                                              '',
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 10,
                                                      ),
                                                      child: Image.network(
                                                        installationrequestlist[
                                                                index]
                                                            .productImage,
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
                                                              duration:
                                                                  Duration(
                                                                seconds: 1,
                                                              ),
                                                              //Default value
                                                              interval:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              //Default value: Duration(seconds: 0)
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      63,
                                                                      61,
                                                                      61),
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
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        238,
                                                                        238,
                                                                        238),
                                                                height: mediaQueryData
                                                                        .size
                                                                        .height /
                                                                    5.0,
                                                                width: mediaQueryData
                                                                        .size
                                                                        .width /
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
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Container(
                                                                width: SizeConfig
                                                                        .safeBlockHorizontal *
                                                                    43,
                                                                child: Text(
                                                                    '${installationrequestlist[index].productName}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17,
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
                                                              SizedBox(
                                                                  height: 5),
                                                              Container(
                                                                width: SizeConfig
                                                                        .safeBlockHorizontal *
                                                                    43,
                                                                child: Text(
                                                                    'Name: ${installationrequestlist[index].customerName}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontFamily:
                                                                            "ProximaNova")),
                                                              ),
                                                              SizedBox(
                                                                  height: 5),
                                                              Container(
                                                                width: SizeConfig
                                                                        .safeBlockHorizontal *
                                                                    43,
                                                                child: Text(
                                                                    'Brand: ${installationrequestlist[index].productBrand}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontFamily:
                                                                            "ProximaNova")),
                                                              ),
                                                              SizedBox(
                                                                  height: 5),
                                                              Container(
                                                                width: SizeConfig
                                                                        .safeBlockHorizontal *
                                                                    43,
                                                                child: Text(
                                                                    'Model no.: ${installationrequestlist[index].modelNo}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontFamily:
                                                                            "ProximaNova")),
                                                              )
                                                            ])),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )));
                          },
                        )
                  : responseData.status == 'No requests yet'
                      ? Center(child: Text('No requests yet'))
                      : CommanWidget.punchOutWidget(size: size),
        ));
  }

  Future<Response> insrequests() async {
    print('installationrequestlist $installationrequestlist');
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

        var installationrespo = FormData.fromMap(formData);

        Response response =
            await baseApi.dio.post(insreqpending, data: installationrespo);

        if (response != null) {
          setState(() {
            responseData = ResponseData.fromMap(jsonDecode(response.data));
            isLoading = false;
          });
          final parsed = json.decode(response.data).cast<String, dynamic>();

          // prefs.setString(SharedPrefKey.ASSIGNEDPRODUCTID,
          //     parsed['installation_product']['assigned_product_id']);
          print(
              "RESPONSE of installation pending: " + response.data.toString());

          progressDialog.dismiss();

          if (responseData.error == 1) {
            InstallationPending insreqrespo =
                InstallationPending.fromJson(parsed);
            setState(() {
              installationrequestlist = insreqrespo.installations;
            });
          } else {
            installationrequestlist = [];
            print('installationrequestlist ${installationrequestlist.length}');
            //Fluttertoast.showToast(msg: responseData.status.toString() ?? '');
            //  AllocatedProdListModel allocatedrespo = AllocatedProdListModel.fromJson(parsed);
            //  String error_msg = allocatedrespo.error_msg;
            //toast(responseData.status.toString());
            // displayToast(parsed["status"].toString() ?? '', context);
          }
        }
        return response;
      } catch (e) {
        print("RESPOONSE:" + e);
        // displayToast("Something went wrong", context);
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
// To parse this JSON data, do
//
//     final responseData = responseDataFromMap(jsonString);
