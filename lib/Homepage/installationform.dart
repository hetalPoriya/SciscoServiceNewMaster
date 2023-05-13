import 'dart:convert';
import 'dart:io';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage/ServiceEngDashBoard.dart';
import 'package:scisco_service/Homepage/installationreqdone.dart';
import 'package:scisco_service/Homepage/installationreqpending.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/components/rounded_button.dart';
import 'package:scisco_service/components/text_field_container.dart';
import 'package:scisco_service/models/InstallationList.dart';
import 'package:scisco_service/models/installationdone.dart';
import 'package:scisco_service/models/response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'installationdetails.dart';

class InstallationForm extends StatefulWidget {
  var customer_id = "";
  var product_id = "";
  var assigned_product_id = "";

  InstallationForm(this.customer_id, this.product_id, this.assigned_product_id);

  @override
  _InstallationFormState createState() => _InstallationFormState(
      this.customer_id, this.product_id, this.assigned_product_id);
}

class _InstallationFormState extends State<InstallationForm> {
  List<InstallationList> installationrequestlist = new List();
  SharedPreferences prefs;
  var serviceengineerid;
  var serviceengineername;
  String installationpending;
  String installationdone;
  String servicepending;
  String servicedone;
  var customer_id = "";
  var product_id = "";
  var assigned_product_id = "";
  final _serialnoCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();

  List<File> fileitems = List<File>();
  List<String> fileitemsStr = List<String>();
  List<dynamic> fileitemsServer = List<dynamic>();
  var _aadharFile;
  var _photo;
  var _reportFile;
  String aadhar;
  String photo;
  String report;

  _InstallationFormState(
      this.customer_id, this.product_id, this.assigned_product_id);

  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          "Installation Form",
          style: TextStyle(fontFamily: "PriximaNova", color: Colors.black),
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(23.0, 5.0, 0.0, 0.0),
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () async {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceEngDashboard(
                          prefs.getBool(SharedPrefKey.ISLOGEDIN),
                          serviceengineerid,
                          serviceengineername,
                          installationpending,
                          installationdone,
                          servicepending,
                          servicedone),
                    ),
                    (route) => false);
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => InstallationReqDetails(
                //         assigned_product_id:
                //             prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID),
                //         customer_id: customer_id,
                //         product_id: product_id),
                //   ),
                // );
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 25, top: 10),
                  child: Text(
                    'Serial No:',
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    controller: _serialnoCtrl,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      //new WhitelistingTextInputFormatter(
                      //  RegExp("[a-zA-Z 0-9]")),
                    ],
                    cursorColor: AppTheme.nearlyBlack,
                    decoration: InputDecoration(
                      hintText: "Serial No.",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.9,
                  child: Text(
                    "Upload your Photo",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 15),
                    child: Container(
                        child: Row(
                      children: [
                        photo != null
                            ? Container(
                                height: size.width / 1.50,
                                width: size.width / 1.125,
                                child:
                                    Image.network(photo, fit: BoxFit.contain))
                            : _photo != null
                                ? Stack(children: <Widget>[
                                    Container(
                                      height: size.width / 1.50,
                                      width: size.width / 1.125,
                                      child: Image.file(_photo,
                                          fit: BoxFit.contain),
                                    ),
                                  ])
                                : Stack(
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(
                                            AppBar().preferredSize.height),
                                        child: DottedBorder(
                                          color: Colors.black,
                                          strokeWidth: 1,
                                          padding: EdgeInsets.only(
                                              left: size.width / 2.5,
                                              right: size.width / 2.5,
                                              top: size.width / 5,
                                              bottom: size.width / 5),
                                          child: Icon(
                                            Icons.add,
                                            size: 40,
                                          ),
                                        ),
                                        onTap: () {
                                          _showSelectionDialog(context);
                                        },
                                      ),
                                    ],
                                  ),
                      ],
                    ))),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.9,
                  child: Text(
                    "Upload your Report",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 15),
                    child: Container(
                        child: Row(
                      children: [
                        report != null
                            ? Container(
                                height: size.width / 1.50,
                                width: size.width / 1.125,
                                child:
                                    Image.network(report, fit: BoxFit.contain))
                            : _reportFile != null
                                ? Stack(children: <Widget>[
                                    Container(
                                      height: size.width / 1.50,
                                      width: size.width / 1.125,
                                      child: Image.file(_reportFile,
                                          fit: BoxFit.contain),
                                    ),
                                  ])
                                : Stack(
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(
                                            AppBar().preferredSize.height),
                                        child: DottedBorder(
                                          color: Colors.black,
                                          strokeWidth: 1,
                                          padding: EdgeInsets.only(
                                              left: size.width / 2.5,
                                              right: size.width / 2.5,
                                              top: size.width / 5,
                                              bottom: size.width / 5),
                                          child: Icon(
                                            Icons.add,
                                            size: 40,
                                          ),
                                        ),
                                        onTap: () {
                                          _showSelection(context);
                                        },
                                      ),
                                    ],
                                  ),
                      ],
                    ))),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 25, top: 10),
                  child: Text(
                    'Remarks',
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    controller: _remarksCtrl,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      //new WhitelistingTextInputFormatter(
                      //  RegExp("[a-zA-Z 0-9]")),
                    ],
                    cursorColor: AppTheme.nearlyBlack,
                    decoration: InputDecoration(
                      hintText: "Remarks",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            )),
      ),
      bottomNavigationBar: Visibility(
          visible: true,
          child: Container(
            alignment: Alignment.center,
            height: size.height * 0.12,
            color: AppTheme.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RoundedButton(
                  color: AppTheme.appColor,
                  text: "Submit",
                  press: () {
                    if (_serialnoCtrl.text.toString().isEmpty) {
                      _showDialog(context, "Please Enter Serial No");
                    } else if (_photo == null) {
                      _showDialog(context, "Please Select your Photo");
                    } else if (_reportFile == null) {
                      _showDialog(context, "Please Select your Report");
                    } else if (_remarksCtrl.text.toString().isEmpty) {
                      _showDialog(context, "Please Enter Remarks");
                    } else {
                      submitinstallationform();
                    }
                    // Get.dialog(AlertDialog(
                    //   title: Text(
                    //       "Are you sure you want to submit Installation form?"),
                    //   actions: [
                    //     ElevatedButton(
                    //       onPressed: () async {
                    //         if (_serialnoCtrl.text.toString().isEmpty) {
                    //           _showDialog(context, "Please Enter Serial No");
                    //         } else if (_photo == null) {
                    //           _showDialog(context, "Please Select your Photo");
                    //         } else if (_reportFile == null) {
                    //           _showDialog(context, "Please Select your Report");
                    //         } else if (_remarksCtrl.text.toString().isEmpty) {
                    //           _showDialog(context, "Please Enter Remarks");
                    //         } else {
                    //           submitinstallationform();
                    //         }
                    //       },
                    //       child: Text(
                    //         "Yes",
                    //       ),
                    //     ),
                    //     ElevatedButton(
                    //       onPressed: () => {
                    //         Get.back(),
                    //       },
                    //       child: Text(
                    //         "No",
                    //       ),
                    //     )
                    //   ],
                    // ));
                  },
                ),
              ],
            ),
          )),
    );
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "From where do you want to take the photo?",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        captureImage(ImageSource.gallery);
                        Get.back();
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        captureImage(ImageSource.camera);
                        Get.back();
                      },
                    )
                  ],
                ),
              ));
        });
  }

  Future<void> captureImage(ImageSource imageSource) async {
    try {
      final imageFile =
          await ImagePicker.platform.pickImage(source: imageSource);
      final dir = await path_provider.getTemporaryDirectory();

      final targetPath = dir.absolute.path +
          "/temp" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".jpg";
      File compressedImage = await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        targetPath,
        quality: 50,
      );

      setState(() {
        _photo = compressedImage;
        fileitems.add(_photo);
        fileitemsStr.add(_photo.path);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showSelection(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                "From where do you want to take the photo?",
                style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        captureReportImage(ImageSource.gallery);
                        Get.back();
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        captureReportImage(ImageSource.camera);
                        Get.back();
                      },
                    )
                  ],
                ),
              ));
        });
  }

  Future<void> captureReportImage(ImageSource imageSource) async {
    try {
      final imageFile =
          await ImagePicker.platform.pickImage(source: imageSource);
      final dir = await path_provider.getTemporaryDirectory();

      final targetPath = dir.absolute.path +
          "/temp" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".jpg";

      File compressedImage = await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        targetPath,
        quality: 50,
      );

      setState(() {
        _reportFile = compressedImage;
        fileitems.add(_reportFile);
        fileitemsStr.add(_reportFile.path);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Response> submitinstallationform() async {
    bool isDeviceOnline = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isDeviceOnline = await checkConnection();
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    progressDialog.show();
    // bool isDeviceOnline = await checkConnection();
    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();

        String photoString = _photo.path.split('/').last;
        String reportString = _reportFile.path.split('/').last;
        Map<String, dynamic> formData = {
          "serial_no": _serialnoCtrl.text.toString(),
          "remarks": _remarksCtrl.text.toString(),
          "customer_id": customer_id,
          "product_id": product_id,
          "assigned_product_id":
              prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID),
          "service_engineer_id":
              prefs.getString(SharedPrefKey.SERVICEENGINEERID),
        };

        var submitinstallation = FormData.fromMap(formData);
        print(formData);
        if (_photo != null) {
          var ImageFile = await MultipartFile.fromFile(_photo.path,
              filename: photoString,
              contentType: MediaType("image", photoString));
          submitinstallation.files.add(MapEntry("photo", ImageFile));
        }

        if (_reportFile != null) {
          var ReportFile = await MultipartFile.fromFile(_reportFile.path,
              filename: reportString,
              contentType: MediaType("image", reportString));
          submitinstallation.files.add(MapEntry("report", ReportFile));
        }

        Response response =
            await baseApi.dio.post(installationform, data: submitinstallation);
        progressDialog.dismiss();
        print(response);
        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE installation form :" + parsed.toString());
          String error = parsed["error"].toString();
          if (error == "1") {
            _showMyDialog(context, parsed["status"].toString());
          } else {
//            String error_msg = commonRespo.error_msg;
            //  displayToast(parsed["status"].toString(), context);
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

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      serviceengineerid = prefs.getString(SharedPrefKey.SERVICEENGINEERID);
      serviceengineername = prefs.getString(SharedPrefKey.SERVICEENGINEERNAME);
      installationpending = prefs.getString(SharedPrefKey.INSTALLATIONPENDING);
      installationdone = prefs.getString(SharedPrefKey.INSTALLATIONDONE);
      servicepending = prefs.getString(SharedPrefKey.SERVICEPENDING);
      servicedone = prefs.getString(SharedPrefKey.SERVICEDONE);
    });
  }

  void _showMyDialog(BuildContext context, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Installation Form"),
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
                      final parsed =
                          json.decode(response.data).cast<String, dynamic>();

                      prefs.setString(SharedPrefKey.INSTALLATIONPENDING,
                          parsed['installations_pending'].toString());
                      prefs.setString(SharedPrefKey.INSTALLATIONDONE,
                          parsed['installations_done'].toString());
                      prefs.setString(SharedPrefKey.SERVICEPENDING,
                          parsed['services_pending'].toString());
                      prefs.setString(SharedPrefKey.SERVICEDONE,
                          parsed['services_done'].toString());
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Installationreq()),
                          (route) => false);
                    }
                    // navigator.pushReplacement(
                    //     MaterialPageRoute(
                    //         builder: (BuildContext ctx) => ServiceEngDashboard(
                    //             true, serviceengineerid, serviceengineername,installationpending,installationdone,servicepending,servicedone)));
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

  void _showDialog(BuildContext context, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Error"),
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
}
