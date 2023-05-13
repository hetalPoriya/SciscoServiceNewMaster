import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/route_manager.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage/allocatedprodetail.dart';
import 'package:scisco_service/LoginSignup/Login/login_screen.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/Utils/sizeconfig.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/main.dart';
import 'package:scisco_service/models/AllocatedProdList.dart';
import 'package:scisco_service/models/AllocatedProdListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AllocatedProdList> productlist = new List();
  SharedPreferences prefs;
  bool isLogin;
  String customerid;
  String customername;
  bool isImageLoading = true;

  @override
  void initState() {
    prodlist();
    initPrefs();
    unloadImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = MediaQuery.of(context).size;

    var index = productlist.length;
    return Scaffold(
        backgroundColor: AppTheme.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppTheme.textcolor, //change your color here
          ),
          elevation: 0,
          title: Text(
            "Allocated Product List",
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
            /*RaisedButton(
            color: AppTheme.appColor,
            onPressed: () async {
              _logoutDialog();
            },
            child: Icon(Icons.logout),
          )*/
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
        body: Column(children: [
          SizedBox(
            height: 20,
          ),
          Container(
              height: SizeConfig.blockSizeVertical * 75,
              child: productlist != null
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: productlist.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(25.0, 5.0, 20.0, 5.0),
                            child: Container(
                                height:
                                    productlist[index].product_id.isNotEmpty &&
                                            productlist[index].product_id != "0"
                                        ? size.height * 0.180
                                        : size.height * 0.13,
                                child: Card(
                                  shape: new RoundedRectangleBorder(
                                      side: new BorderSide(
                                          color: HexColor("#FFFFFF"),
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  color: HexColor("#FFFFFF"),
                                  elevation: 4.0,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0.0, 8.0, 0.0, 8.0),
                                              child: InkWell(
                                                  onTap: () {
                                                    Get.to(
                                                      () =>
                                                          AllocatedProductDetail(
                                                        productlist[index]
                                                            .product_id,
                                                        productlist[index]
                                                            .assigned_product_id,
                                                      ),
                                                    );
                                                    // navigator.pushReplacement(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (BuildContext
                                                    //                 ctx) =>
                                                    //             AllocatedProductDetail(
                                                    //                 productlist[index]
                                                    //                     .product_id)));
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 10,
                                                          vertical: 10,
                                                        ),
                                                        child: isImageLoading
                                                            ? Shimmer(
                                                                duration:
                                                                    Duration(
                                                                  seconds: 1,
                                                                ), //Default value
                                                                interval: Duration(
                                                                    seconds:
                                                                        1), //Default value: Duration(seconds: 0)
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        63,
                                                                        61,
                                                                        61), //Default value
                                                                colorOpacity:
                                                                    0, //Default value
                                                                enabled:
                                                                    true, //Default value
                                                                direction:
                                                                    ShimmerDirection
                                                                        .fromLTRB(), //Default Value
                                                                child:
                                                                    Container(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          238,
                                                                          238,
                                                                          238),
                                                                  width: 130,
                                                                  height: 100,
                                                                ),
                                                              )
                                                            : Image.network(
                                                                productlist[
                                                                        index]
                                                                    .product_image,
                                                                errorBuilder: (BuildContext
                                                                        context,
                                                                    Object
                                                                        exception,
                                                                    StackTrace
                                                                        stackTrace) {
                                                                  return Image
                                                                      .asset(
                                                                          'placeholder.gif');
                                                                },
                                                                width: 130,
                                                                height: 100,
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
                                                          children: [
                                                            Container(
                                                              width: SizeConfig
                                                                      .safeBlockHorizontal *
                                                                  43,
                                                              child: Text(
                                                                  '${productlist[index].product_name}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                height: 10),
                                                            Container(
                                                              width: SizeConfig
                                                                      .safeBlockHorizontal *
                                                                  43,
                                                              child: Text(
                                                                  'Model No: ${productlist[index].model_no}',
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
                                                            SizedBox(height: 3),
                                                            Container(
                                                              width: SizeConfig
                                                                      .safeBlockHorizontal *
                                                                  43,
                                                              child: Text(
                                                                  'Brand: ${productlist[index].brand}',
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
                                                                          "PriximaNova")),
                                                            ),
                                                            // SizedBox(height: 3),
                                                            // Container(
                                                            //   width: size.width * 0.60,
                                                            //   child: Text(
                                                            //       'Reagents based: ${productlist[index].reagents_based}',
                                                            //       textAlign: TextAlign.start,
                                                            //       maxLines: 1,
                                                            //       overflow:
                                                            //           TextOverflow.ellipsis,
                                                            //       style: TextStyle(
                                                            //           fontSize: 13,
                                                            //           color:
                                                            //               AppTheme.textcolor,
                                                            //           fontWeight:
                                                            //               FontWeight.w500,
                                                            //           fontFamily:
                                                            //               "WorkSans")),
                                                            // ),
                                                            // SizedBox(height: 3),
                                                            // Container(
                                                            //   width: size.width * 0.60,
                                                            //   child: Text(
                                                            //       'Allocation Date/time: ${productlist[index].assigned_date}',
                                                            //       textAlign: TextAlign.start,
                                                            //       maxLines: 2,
                                                            //       overflow:
                                                            //           TextOverflow.ellipsis,
                                                            //       style: TextStyle(
                                                            //           fontSize: 13,
                                                            //           color:
                                                            //               AppTheme.textcolor,
                                                            //           fontWeight:
                                                            //               FontWeight.w500,
                                                            //           fontFamily:
                                                            //               "WorkSans")),
                                                            // ),
                                                            // SizedBox(
                                                            //   height: 5,
                                                            // ),
                                                            // Container(
                                                            //   width: size.width * 0.60,
                                                            //   child: Text(
                                                            //       'Installation Status: ${productlist[index].installation_status}',
                                                            //       textAlign: TextAlign.start,
                                                            //       style: TextStyle(
                                                            //           fontSize: 13,
                                                            //           color:
                                                            //               AppTheme.textcolor,
                                                            //           fontWeight:
                                                            //               FontWeight.w500,
                                                            //           fontFamily:
                                                            //               "WorkSans")),
                                                            // ),
                                                            // SizedBox(height: 5),
                                                            /*productlist[index]
                                                                .installation_status ==
                                                            "Installed"
                                                        ? Container(
                                                            // width: size.width * 0.60,
                                                            // child: Text(
                                                            //     'Installation Date: ${productlist[index].installed_at}',
                                                            //     textAlign:
                                                            //         TextAlign.start,
                                                            //     style: TextStyle(
                                                            //         fontSize: 13,
                                                            //         color: AppTheme
                                                            //             .textcolor,
                                                            //         fontWeight:
                                                            //             FontWeight
                                                            //                 .w500,
                                                            //         fontFamily:
                                                            //             "WorkSans")),
                                                            )
                                                        : Wrap(),
                                                    productlist[index]
                                                                .installation_status ==
                                                            "Installed"
                                                        ? SizedBox(height: 5)
                                                        : Wrap(),
                                                    productlist[index]
                                                                .service_status ==
                                                            "Send now"
                                                        ? Container(
                                                            // width: size.width * 0.60,
                                                            // child: Row(children: <
                                                            //     Widget>[
                                                            //   Expanded(
                                                            //       child: RaisedButton(
                                                            //     onPressed: () async {
                                                            //       sendnow();
                                                            //     },
                                                            //     child: Text(productlist[
                                                            //             index]
                                                            //         .service_status),
                                                            //   )),
                                                            // ])
                                                            )
                                                        : Container(
                                                            // width: size.width * 0.60,
                                                            // child: Text(
                                                            //     'Service: ${productlist[index].service_status}',
                                                            //     textAlign:
                                                            //         TextAlign.start,
                                                            //     style: TextStyle(
                                                            //         fontSize: 13,
                                                            //         color: AppTheme
                                                            //             .textcolor,
                                                            //         fontWeight:
                                                            //             FontWeight
                                                            //                 .w500,
                                                            //         fontFamily:
                                                            //             "WorkSans")),
                                                            )*/
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )))),
                                    ],
                                  ),
                                )));
                      },
                    )
                  : Wrap()),
        ]));
  }

  Future<Response> prodlist() async {
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
          "customer_id": prefs.getString(SharedPrefKey.COSTUMERID),
          "customer_name": prefs.getString(SharedPrefKey.CUSTOMERNAME)
        };
        print(formData.toString());

        var productrespo = FormData.fromMap(formData);

        Response response =
            await baseApi.dio.post(allocatedlist, data: productrespo);

        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPONSE of product list:" + parsed.toString());
          String error = parsed["error"].toString();
          progressDialog.dismiss();
          if (error == "1") {
            AllocatedProdListModel allocatedrespo =
                AllocatedProdListModel.fromJson(parsed);
            setState(() {
              productlist = allocatedrespo.assigned_products;
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

  Future<Response> sendnow() async {
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
          "customer_id": prefs.getString(SharedPrefKey.COSTUMERID),
          "product_id": productlist[0].product_id,
          "assigned_product_id": productlist[0].assigned_product_id
        };

        print(formData.toString());

        var sendnowrespo = FormData.fromMap(formData);

        Response response =
            await baseApi.dio.post(sendnowurl, data: sendnowrespo);
        print(response.toString());
        progressDialog.dismiss();
        prodlist();
      } catch (e) {
//        print("RESPOONSE:" + e);
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
      customerid = prefs.getString(SharedPrefKey.COSTUMERID);
      customername = prefs.getString(SharedPrefKey.CUSTOMERNAME);
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
                // navigator.pop();
                Get.back();
              },
            ),
            CupertinoDialogAction(
              child: Text('Yes'),
              onPressed: () async {
                // navigator.pop();
                Get.back();

                SharedPreferences prefs = await SharedPreferences.getInstance();

                prefs.remove(SharedPrefKey.COSTUMERID);
                prefs.remove(SharedPrefKey.CUSTOMERNAME);
                prefs.remove(SharedPrefKey.ISLOGEDIN);
                Get.offAll(() => LoginScreen());
                // navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return LoginScreen();
                //     },
                //   ),
                // );
              },
            ),
          ],
        );
      },
    );
  }

  void unloadImages() async {
    await 5.delay();
    setState(() {
      isImageLoading = false;
    });
  }
}
