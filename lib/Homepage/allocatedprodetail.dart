import 'dart:convert';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage/Dashboard.dart';
import 'package:scisco_service/Homepage/servicereqdetail.dart';
import 'package:scisco_service/Homepage/timeline.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/Utils/sizeconfig.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/models/AllocatedProdDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class AllocatedProductDetail extends StatefulWidget {
  var product_id = "";
  var assigned_product_id = "";

  AllocatedProductDetail(this.product_id, this.assigned_product_id);

  @override
  _AllocatedProductDetailState createState() =>
      _AllocatedProductDetailState(this.product_id, this.assigned_product_id);
}

class _AllocatedProductDetailState extends State<AllocatedProductDetail> {
  List<ProductDetails> productdeatillist = new List();
  var product_id = "";
  var assigned_product_id = "";
  SharedPreferences prefs;
  bool isLogin;
  String customerid;
  String customername;
  String error;
  String engineer_name;
  String engineer_email;
  String engineer_mobile;

  _AllocatedProductDetailState(this.product_id, this.assigned_product_id);

  var productId = "";
  var product_name = "";
  var productImage = "";
  var modelNo = "";
  var brand = "";
  var qrImage = "";
  var service_yet = "";
  var reagentsBased = "";
  var assignedDate = "";
  var warranty = "";
  var amcCost = "";
  var amcDuration = "";
  var cmcCost = "";
  var cmcDuration = "";
  var installationStatus = "";
  var serviceStatus = "";
  var installedAt = "";
  var serviceYet;
  bool isImageLoading = true;
  bool timeline = true;
  bool serviceLogs = false;
  bool qrCode = false;
  List service_logs;

  @override
  void initState() {
    initPrefs();
    print(product_id);
    proddetaillist();
    unloadImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = MediaQuery.of(context).size;
    try {
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
              installationStatus == "Installed"
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: 10, right: SizeConfig.safeBlockHorizontal * 8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: SizeConfig.safeBlockVertical * 5,
                              child: Ink(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(241, 242, 243, 1.0),
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0.3, 3),
                                    child: TextButton(
                                      child: serviceStatus == "Request sent"
                                          ? Text(
                                              "Service Request Sent",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              "Request for Service",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                      //style: ButtonStyle(color: Colors.black,),
                                      onPressed: () {
                                        serviceStatus == "Request sent"
                                            ? SizedBox()
                                            : sendnow();
                                      },
                                    ),
                                  )),
                            ),
                          ]))
                  : SizedBox(),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 2.0,
            elevation: 0,
            color: Color.fromRGBO(255, 255, 255, 1.0),
          ),
          body: SingleChildScrollView(
              child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 15.0, 0.0, 10.0),
                  child: Text(
                    product_name,
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
                    "Model no: " + modelNo,
                    style: TextStyle(
                        fontFamily: "PriximaNova",
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                        color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 5.0),
                  child: Text(
                    "Product Warranty: " + warranty.trim(),
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
                        productImage,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace stackTrace) {
                          return Text('Loading Image...');
                        },
                        height: SizeConfig.safeBlockVertical * 25,
                      )),
                ),
                (engineer_name != null &&
                        engineer_email != null &&
                        engineer_mobile != null)
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 0.0),
                        child: Card(
                            color: Color.fromRGBO(241, 242, 243, 1.0),
                            shadowColor: Color.fromRGBO(241, 242, 243, 1.0),
                            elevation: 4,
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [],
                                  ),
                                  Text(
                                    "Engineer name",
                                    style: TextStyle(
                                        fontFamily: 'PriximaNova',
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal * 4,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    engineer_name,
                                    style: TextStyle(
                                        fontFamily: 'PriximaNova',
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
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
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: IconButton(
                                          color: Colors.white,
                                          onPressed: () {
                                            launch("tel:$engineer_mobile");
                                          },
                                          icon: Icon(Icons.phone),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            SizeConfig.safeBlockHorizontal * 3,
                                      ),
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
                                                engineer_mobile);
                                          },
                                          icon: Icon(Icons.whatsapp),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            SizeConfig.safeBlockHorizontal * 3,
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
                                            launch("mailto:$engineer_email");
                                          },
                                          icon: Icon(Icons.email_outlined),
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
                            "Timeline",
                            style: TextStyle(
                                fontFamily: "PriximaNova",
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
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
                            "Service Logs",
                            style: TextStyle(
                                fontFamily: "PriximaNova",
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                color: serviceLogs == true
                                    ? Colors.black
                                    : Colors.grey,
                                fontWeight: serviceLogs == true
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                          onTap: () {
                            setState(() {
                              serviceLogs = true;
                              timeline = false;
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
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                color:
                                    qrCode == true ? Colors.black : Colors.grey,
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
                        ))
                      ],
                    )),
                Visibility(
                  visible: timeline,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 10.0),
                    child: ProductTimeLineDetails(
                      installationStatus: installationStatus,
                      serviceStatus: serviceStatus,
                      installedAt: installedAt,
                      assignedDate: assignedDate,
                    ),
                  ),
                ),
                Visibility(
                    visible: serviceLogs,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: (serviceYet == null || serviceYet == 0)
                                ? Text("No Service request Yet")
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      for (int i = 0; i < serviceYet; i++)
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0.0, 10.0, 0.0, 0.0),
                                            child: Card(
                                                shadowColor: Color.fromRGBO(
                                                    241, 242, 243, 1.0),
                                                elevation: 4,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      15.0, 15.0, 0.0, 10.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Servicing " +
                                                            (i + 1).toString(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'PriximaNova',
                                                            fontSize: SizeConfig
                                                                    .safeBlockHorizontal *
                                                                4.5,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "Service Engineer Assigned: ",
                                                              style: TextStyle(
                                                                  height: 1.2,
                                                                  fontFamily:
                                                                      'PriximaNova',
                                                                  fontSize:
                                                                      SizeConfig.safeBlockHorizontal *
                                                                          3.8,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Colors
                                                                      .black)),
                                                          Flexible(
                                                            child: Text(
                                                                service_logs[i][
                                                                    'service_engineer_name'],
                                                                style:
                                                                    TextStyle(
                                                                        height:
                                                                            1.2,
                                                                        // the height between text, default is null
                                                                        letterSpacing:
                                                                            0.5,
                                                                        fontFamily:
                                                                            'PriximaNova',
                                                                        fontSize:
                                                                            SizeConfig.safeBlockHorizontal *
                                                                                3.8,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        color: Colors
                                                                            .black)),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "Servicing done on ",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'PriximaNova',
                                                                  fontSize:
                                                                      SizeConfig.safeBlockHorizontal *
                                                                          3.8,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Colors
                                                                      .black)),
                                                          Expanded(
                                                            child: Text(
                                                                service_logs[i][
                                                                    'service_done_at'],
                                                                style: TextStyle(
                                                                    letterSpacing:
                                                                        1.0,
                                                                    fontFamily:
                                                                        'PriximaNova',
                                                                    fontSize:
                                                                        SizeConfig.safeBlockHorizontal *
                                                                            3.8,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Colors
                                                                        .black)),
                                                          )
                                                        ],
                                                      ),
                                                      //Text(service_logs[i]['service_done_at']),
                                                    ],
                                                  ),
                                                )))
                                    ],
                                  )))),
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
              ],
            ),
          )));
    } catch (e) {
      print(e);
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
          "customer_id": customerid,
          "product_id": product_id,
          "assigned_product_id": assigned_product_id
        };

        print('formData.toString() ${formData.toString()}');

        var sendnowrespo = FormData.fromMap(formData);

        Response response =
            await baseApi.dio.post(sendnowurl, data: sendnowrespo);
        print(response.toString());
        progressDialog.dismiss();
        proddetaillist();
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
      print("customer id " + customerid);
      customername = prefs.getString(SharedPrefKey.CUSTOMERNAME);
      engineer_name = prefs.getString(SharedPrefKey.ENGINEER_NAME);
      print("engineer name " + prefs.getString(SharedPrefKey.ENGINEER_NAME));
      engineer_email = prefs.getString(SharedPrefKey.ENGINEER_EMAIL);
      print("engineer email " + engineer_email);
      engineer_mobile = prefs.getString(SharedPrefKey.ENGINEER_MOBILE);
    });
  }

  Future<Response> proddetaillist() async {
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
          "customer_id": customerid,
          "assigned_product_id": assigned_product_id,
//          "customer_name": prefs.getString(SharedPrefKey.CUSTOMERNAME)
          "product_id": product_id
        };
        print(formData.toString());

        var productdetailrespo = FormData.fromMap(formData);

        Response response =
            await baseApi.dio.post(productdetail, data: productdetailrespo);

        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPONSE of product list detail:" + parsed.toString());
          error = parsed["error"].toString();
          progressDialog.dismiss();
          if (error == "1") {
            AllocatedProdDetail detail = AllocatedProdDetail.fromJson(parsed);
            print(detail.productDetails.service_logs);
            setState(() {
              productId = detail.productDetails.productId;
              product_name = detail.productDetails.productName;
              productImage = detail.productDetails.productImage;
              modelNo = detail.productDetails.modelNo;
              brand = detail.productDetails.brand;
              qrImage = detail.productDetails.qrImage;
              reagentsBased = detail.productDetails.reagentsBased;
              assignedDate = detail.productDetails.assignedDate;
              warranty = detail.productDetails.warranty;
              amcCost = detail.productDetails.amcCost;
              amcDuration = detail.productDetails.amcDuration;
              cmcCost = detail.productDetails.cmcCost;
              cmcDuration = detail.productDetails.cmcDuration;
              installationStatus = detail.productDetails.installationStatus;
              serviceStatus = detail.productDetails.serviceStatus;
              installedAt = detail.productDetails.installedAt;
              serviceYet = detail.productDetails.serviceYet;
              service_logs = detail.productDetails.service_logs;
            });
          } else {
//            AllocatedProdListModel allocatedrespo = AllocatedProdListModel.fromJson(parsed);
            //          String error_msg = allocatedrespo.error_msg;
            //        displayToast(error_msg.toString(), context);
          }
        }
        return response;
      } catch (e) {
        print("RESPOONSE:" + e);
        displayToast("Something went wrong", context);
        return null;
      }
    } else {
      //   displayToast("Please connect to internet", context);
      return null;
    }
  }

  void unloadImages() async {
    await 10.delay();
    setState(() {
      isImageLoading = false;
    });
  }
}

class ProdTitleWithDescription extends StatelessWidget {
  const ProdTitleWithDescription({
    Key key,
    @required this.infoText,
    @required this.infoTitle,
    this.titleSize = 10.0,
    this.detailSize = 28,
  }) : super(key: key);

  final String infoText;
  final String infoTitle;
  final double titleSize;
  final double detailSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Column(
            children: [
              Text(
                infoTitle.toUpperCase(),
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 58, 80, 178),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: 2.0,
            bottom: 8.0,
          ),
          width: Get.width - 60,
          child: Text(
            '${infoText}'.toUpperCase(),
            textAlign: TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: detailSize,
              color: Color.fromARGB(255, 65, 12, 178),
              fontWeight: FontWeight.w800,
              fontFamily: "WorkSans",
            ),
          ),
        ),
      ],
    );
  }
}
