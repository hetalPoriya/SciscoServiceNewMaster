import 'dart:convert';
import 'dart:io';
import 'package:get/route_manager.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage/ServiceEngDashBoard.dart';
import 'package:scisco_service/Homepage/installationform.dart';
import 'package:scisco_service/Homepage/installationreqpending.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/components/rounded_button.dart';
import 'package:scisco_service/components/text_field_container.dart';
import 'package:scisco_service/models/InstallationList.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'installationdetails.dart';

class PreInstallationForm extends StatefulWidget {
  var customer_id = "";
  var product_id = "";
  var assignedProdctId = "";

  PreInstallationForm(this.customer_id, this.product_id, this.assignedProdctId);

  @override
  _PreInstallationFormState createState() => _PreInstallationFormState(
      this.customer_id, this.product_id, this.assignedProdctId);
}

class _PreInstallationFormState extends State<PreInstallationForm> {
  String selectedtable, selectedinstallation, selectedups;
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
  var assignedProdctId = "";
  List<String> tableList = ['Yes', 'No'];
  List<String> installationlist = ['Yes', 'No'];
  List<String> onlineupsList = ['Yes', 'No'];
  final _onlineupsCtrl = TextEditingController();
  final _earthingCtrl = TextEditingController();
  final _powerpointsCtrl = TextEditingController();
  final _remarksCtrl = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  List<File> imageFileList = [];

  List<File> fileitems = List<File>();
  List<File> selectfileitems = List<File>();
  List<String> fileitemsStr = List<String>();
  List<dynamic> fileitemsServer = List<dynamic>();
  List<File> _photo = List<File>();
  String photo;

  _PreInstallationFormState(
      this.customer_id, this.product_id, this.assignedProdctId);

  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => ServiceEngDashboard(
                prefs.getBool(SharedPrefKey.ISLOGEDIN),
                serviceengineerid,
                serviceengineername,
                installationpending,
                installationdone,
                servicepending,
                servicedone)),
        (route) => false,
      ),
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
            "Pre Installation Form",
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
                            servicedone)),
                    (route) => false,
                  );
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
                      'Online UPS',
                      style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextFieldContainer(
                    child: DropdownButton<String>(
                      value: selectedups,
                      hint: Text("--Select--"),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      underline: Container(
                        height: 0,
                        color: Colors.black,
                      ),
                      onChanged: (String data) {
                        setState(() {
                          selectedups = data;
                        });
                      },
                      items: onlineupsList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 25, top: 10),
                    child: Text(
                      'Online UPS(Kw)',
                      style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextFieldContainer(
                    child: TextField(
                      controller: _onlineupsCtrl,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        //new WhitelistingTextInputFormatter(
                        //  RegExp("[a-zA-Z 0-9]")),
                      ],
                      cursorColor: AppTheme.nearlyBlack,
                      decoration: InputDecoration(
                        hintText: "Online UPS(Kw)",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 25, top: 10),
                    child: Text(
                      'Earthing Difference',
                      style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextFieldContainer(
                    child: TextField(
                      controller: _earthingCtrl,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        // new WhitelistingTextInputFormatter(
                        //   RegExp("[a-zA-Z 0-9]")),
                      ],
                      cursorColor: AppTheme.nearlyBlack,
                      decoration: InputDecoration(
                        hintText: "Earthing Difference",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 25, top: 10),
                    child: Text(
                      'Table',
                      style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextFieldContainer(
                    child: DropdownButton<String>(
                      value: selectedtable,
                      hint: Text("--Select--"),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      underline: Container(
                        height: 0,
                        color: Colors.black,
                      ),
                      onChanged: (String data) {
                        setState(() {
                          selectedtable = data;
                        });
                      },
                      items: tableList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 25, top: 10),
                    child: Text(
                      'Power Points',
                      style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextFieldContainer(
                    child: TextField(
                      controller: _powerpointsCtrl,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        //new WhitelistingTextInputFormatter(
                        //  RegExp("[a-zA-Z 0-9]")),
                      ],
                      cursorColor: AppTheme.nearlyBlack,
                      decoration: InputDecoration(
                        hintText: "Power Points",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
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
                        // new WhitelistingTextInputFormatter(
                        //     RegExp("[a-zA-Z 0-9]")),
                      ],
                      cursorColor: AppTheme.nearlyBlack,
                      decoration: InputDecoration(
                        hintText: "Remarks",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 25, top: 10),
                    child: Text(
                      'Ready For Installation',
                      style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextFieldContainer(
                    child: DropdownButton<String>(
                      value: selectedinstallation,
                      hint: Text("--Select--"),
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      underline: Container(
                        height: 0,
                        color: Colors.black,
                      ),
                      onChanged: (String data) {
                        setState(() {
                          selectedinstallation = data;
                        });
                      },
                      items: installationlist
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
                        child: photo != null
                            ? Container(
                                height: size.width / 1.50,
                                width: size.width / 1.125,
                                child:
                                    Image.network(photo, fit: BoxFit.contain))
                            : _photo.length != 0
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          for (var selectphoto in _photo)
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Container(
                                                height: size.width / 1.0,
                                                width: size.width / 1.125,
                                                child: Image.file(selectphoto,
                                                    fit: BoxFit.contain),
                                              ),
                                            ),
                                        ]))
                                /*:_photo != null
                                  ? Stack(children: <Widget>[
                                      Container(
                                        height: size.width / 1.50,
                                        width: size.width / 1.125,
                                        child: Image.file(_photo[0],
                                            fit: BoxFit.contain),
                                      ),
                                    ])*/
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
                      )),
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
                      if (selectedups == null) {
                        _showDialog(context, "Please Select Online UPS");
                      } else if (_onlineupsCtrl.text.toString().isEmpty) {
                        _showDialog(context, "Please Enter Online UPS(kw)");
                      } else if (_earthingCtrl.text.toString().isEmpty) {
                        _showDialog(
                            context, "Please Enter Earthing Difference");
                      } else if (selectedtable == null) {
                        _showDialog(context, "Please Select Table");
                      } else if (_powerpointsCtrl.text.toString().isEmpty) {
                        _showDialog(context, "Please Enter Power Points");
                      } else if (_remarksCtrl.text.toString().isEmpty) {
                        _showDialog(context, "Please Enter Remarks");
                      } else if (selectedinstallation == null) {
                        _showDialog(
                            context, "Please Select Ready For Installation");
                      } else {
                        preinstallationform();
                      }
                      //Get.back();
                      // Get.dialog(AlertDialog(
                      //   title: Text(
                      //       "Are you sure you want to submit Pre Installation form?"),
                      //   actions: [
                      //     ElevatedButton(
                      //       onPressed: () async {
                      //         if (selectedups == null) {
                      //           _showDialog(context, "Please Select Online UPS");
                      //         } else if (_onlineupsCtrl.text.toString().isEmpty) {
                      //           _showDialog(
                      //               context, "Please Enter Online UPS(kw)");
                      //         } else if (_earthingCtrl.text.toString().isEmpty) {
                      //           _showDialog(
                      //               context, "Please Enter Earthing Difference");
                      //         } else if (selectedtable == null) {
                      //           _showDialog(context, "Please Select Table");
                      //         } else if (_powerpointsCtrl.text
                      //             .toString()
                      //             .isEmpty) {
                      //           _showDialog(context, "Please Enter Power Points");
                      //         } else if (_remarksCtrl.text.toString().isEmpty) {
                      //           _showDialog(context, "Please Enter Remarks");
                      //         } else if (selectedinstallation == null) {
                      //           _showDialog(context,
                      //               "Please Select Ready For Installation");
                      //         } else {
                      //           preinstallationform();
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
      ),
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
                        selectImages();
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

  void selectImages() async {
    final List<XFile> selectedImages = (await imagePicker.pickMultiImage());
    for (var selectphoto in selectedImages) {
      _photo.add(File(selectphoto.path));
    }
    print("Image List Length:" + _photo.length.toString());
    print(_photo);
    setState(() {
      for (var selectphoto in _photo) {
        fileitems.add(selectphoto);
        fileitemsStr.add(selectphoto.path);
      }
    });
  }

  Future<void> captureImage(ImageSource imageSource) async {
    try {
      final imageFile =
          await ImagePicker.platform.pickImage(source: imageSource);
      print("Camera Image");
      print(imageFile.path);

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
      print(compressedImage);
      print(compressedImage.path);

      setState(() {
        _photo.add(compressedImage);
        fileitems.add(_photo[0]);
        fileitemsStr.add(_photo[0].path);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Response> preinstallationform() async {
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

        Map<String, dynamic> formData = {
          "online_ups": selectedups,
          "online_ups_kw": _onlineupsCtrl.text.toString(),
          "earthing_difference": _earthingCtrl.text.toString(),
          "table": selectedtable,
          "power_points": _powerpointsCtrl.text.toString(),
          "remarks": _remarksCtrl.text.toString(),
          "ready_for_installation": selectedinstallation,
          "customer_id": customer_id,
          "product_id": product_id,
          "service_engineer_id":
              prefs.getString(SharedPrefKey.SERVICEENGINEERID),
          'assigned_product_id': assignedProdctId
        };

        var submitpreinstallation = FormData.fromMap(formData);
        print(formData);

        if (_photo.length != 0) {
          for (int i = 0; i < _photo.length; i++) {
            String photoString = _photo[i].path.split('/').last;
            var ImageFile = await MultipartFile.fromFile(_photo[i].path,
                filename: photoString,
                contentType: MediaType("image", photoString));
            submitpreinstallation.files.add(MapEntry("photo[]", ImageFile));
          }
        }
        print(submitpreinstallation.files);
        /*if (_photo != null) {
          var ImageFile = await MultipartFile.fromFile(_photo.path,
              filename: photoString,
              contentType: MediaType("image", photoString));
          submitpreinstallation.files.add(MapEntry("photo", ImageFile));
        }*/

        Response response = await baseApi.dio
            .post(preinstallation, data: submitpreinstallation);
        progressDialog.dismiss();
        print(response.toString());
        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE pre installation form :" + parsed.toString());
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
            title: Text("Pre-installation Form"),
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InstallationForm(
                          customer_id,
                          product_id,
                          prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID),
                        ),
                      ),
                      (route) => false,
                    );
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => InstallationReqDetails(
                    //         assigned_product_id: prefs
                    //             .getString(SharedPrefKey.ASSIGNEDPRODUCTID),
                    //         customer_id: customer_id,
                    //         product_id: product_id),
                    //   ),
                    //   (route) => false,
                    // );

                    //Get.back();
                    //Get.back();
                    // navigator.pushReplacement(
                    //     MaterialPageRoute(
                    //         builder: (BuildContext ctx) => ServiceEngDashboard(
                    //         true,
                    //         serviceengineerid,
                    //         serviceengineername,
                    //         installationpending,
                    //         installationdone,
                    //         servicepending,
                    //         servicedone)));
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
