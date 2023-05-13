import 'dart:convert';
import 'dart:io';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/route_manager.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage/ServiceEngDashBoard.dart';
import 'package:scisco_service/Homepage/servicereqdetail.dart';
import 'package:scisco_service/Homepage/servicerequestpending.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/components/rounded_button.dart';
import 'package:scisco_service/components/text_field_container.dart';
import 'package:scisco_service/models/CustomFieldList.dart';
import 'package:scisco_service/models/CustomFieldModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceForm extends StatefulWidget {
  var product_id = "";
  var assignedProdctId = "";

  var service_request_id = "";
  var customer_id = "";

  ServiceForm(this.customer_id, this.product_id, this.assignedProdctId,
      this.service_request_id);

  @override
  _ServiceFormState createState() => _ServiceFormState(this.customer_id,
      this.product_id, this.assignedProdctId, this.service_request_id);
}

class _ServiceFormState extends State<ServiceForm> {
  _ServiceFormState(this.customer_id, this.product_id, this.assignedProdctId,
      this.service_request_id);

  String selectedups;
  var selectedRadio;
  String date = "";
  DateTime selectedDate = DateTime.now();
  File file;
  List<File> files = List<File>();
  List<String> onlineupsList = new List();
  List<String> radiolist = new List();

//  List<String> radiolabel = new List();
  List<CustomFieldList> customfieldlist = new List();
  var customValues = new List();
  var counter = 0;
  var customer_id = "";
  var product_id = "";
  var assignedProdctId = "";

  var service_request_id = "";
  var label;
  var customdata;
  List<String> labellist = new List();
  List<String> customdatalist = new List();
  var labelsplit;
  var customdatasplit;
  final _servicepartCtrl = TextEditingController();
  final _servicegivenCtrl = TextEditingController();

  // final _inputCtrl = TextEditingController();
  TextEditingController _inputCtrl = new TextEditingController();
  SharedPreferences prefs;
  bool isLogin;
  var serviceengineerid;
  var serviceengineername;
  String installationpending;
  String installationdone;
  String servicepending;
  String servicedone;

  // static List<String> friendsList = [null];
  List<Asset> images = List<Asset>();
  String _error;
  List<File> fileitems = List<File>();
  List<String> fileitemsStr = List<String>();
  List<String> fileitemsServer = List<String>();
  var _values = [];

//  List<Map<String, dynamic>> _values;
  var _photo;
  var _reportFile;
  String photo;
  String report;
  bool datepicker = false;

  @override
  void initState() {
    customValues = List.generate(customfieldlist.length, (value) => 1);
    initPrefs();
    serviceform();
    super.initState();
  }

  Widget buildGridView() {
    if (images != null)
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(images.length, (index) {
            Asset asset = images[index];
            return AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            );
          }),
        ),
      );
    else
      return Container(height: 0.1, color: Colors.white);
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
          "Service Form",
          style: TextStyle(fontFamily: "PriximaNova", color: Colors.black),
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(23.0, 5.0, 0.0, 0.0),
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceReqDetail(
                        customer_id: customer_id,
                        product_id: product_id,
                        service_request_id: service_request_id,
                        assignedProductId: assignedProdctId),
                  ),
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
              child: Column(children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 25, top: 10),
                  child: Text(
                    'Service Part Required',
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    controller: _servicepartCtrl,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      // new WhitelistingTextInputFormatter(
                      //     RegExp("[a-zA-Z 0-9]")),
                    ],
                    cursorColor: AppTheme.nearlyBlack,
                    decoration: InputDecoration(
                      hintText: "Enter service part",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 25, top: 10),
                  child: Text(
                    'Service Part Given',
                    style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    controller: _servicegivenCtrl,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      // new WhitelistingTextInputFormatter(
                      //     RegExp("[a-zA-Z 0-9]")),
                    ],
                    cursorColor: AppTheme.nearlyBlack,
                    decoration: InputDecoration(
                      hintText: "Enter service part given",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.9,
                  child: ElevatedButton(
                    child: Text(
                      "Upload your Photo",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    onPressed: loadAssets,
                  ),
                ),
                Container(
                    child: SizedBox(
                  height: images != null ? 80 : 5,
                  child: Column(children: <Widget>[
                    Expanded(
                      child: buildGridView(),
                    )
                  ]),
                )),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.9,
                  child: Text(
                    "Upload your Report",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
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
                for (var i = 0; i < customfieldlist.length; i++)
                  Column(
                    children: [
                      Text(customfieldlist[i].product_id),
                      Text(customfieldlist[i].field_type),
                      Text(customfieldlist[i].label),
                      Text(customfieldlist[i].options),
                      Text(customValues[i]),
                      customfieldlist[i].field_type == "dropdown"
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  DropdownButton(
                                    value: customValues[i],
                                    items: customfieldlist[i]
                                        .options
                                        .split(",")
                                        .map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (var value) {
                                      setState(() {
                                        if (customValues
                                            .asMap()
                                            .containsKey(i)) {
                                          customValues[i] = value;
                                        } else {
                                          customValues.add(value);
                                        }
                                      });
                                    },
                                  )
                                ])
                          : Wrap(),
                    ],
                  )
              ]))),
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
                    if (_servicepartCtrl.text.toString().isEmpty) {
                      _showDialog(
                          context, "Please enter service part required");
                    } else if (_servicegivenCtrl.text.toString().isEmpty) {
                      _showDialog(context, "Please enter service part given");
                    } else {
                      print('CLAAAAA');
                      fillserviceform();
                    }
                  },
                ),
              ],
            ),
          )),
    );
  }

  _onUpdate(String index, String val) async {
    print("dsfasfi" + index);
    print(_values);
    int foundKey = -1;
    // if(_values!=null) {
    //   for (var map in _values) {
    //     if (map.containsKey("id")) {
    //       if (map["id"] == index) {
    //         foundKey = index;
    //         break;
    //       }
    //     }
    //   }
    // }
    // final indexx = _values.indexWhere((element) =>
    // element.label == index);
    // if (indexx >= 0) {
    //   print('Using indexWhere: ${_values[indexx]}');
    // }
    if (_values.length > 0) {
      for (int i = 0; i < _values.length; i++) {
        print(_values[i]['label']);
        if (_values[i]['label'] == index) {
          foundKey = i;
          _values.removeAt(foundKey);
          break;
        }
      }
    }

    _values.add({
      "label": index,
      "value": val,
    });
    print(_values);
  }

  Future<Response> fillserviceform() async {
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

        print(_values);
        for (int i = 0; i < customfieldlist.length; i++) {
          print(customfieldlist[i].label);
        }

        String reportString = _reportFile.path.split('/').last;
        Map<String, dynamic> formData = {
          "customer_id": customer_id,
          "product_id": product_id,
          "service_engineer_id":
              prefs.getString(SharedPrefKey.SERVICEENGINEERID),
          "service_part_required": _servicepartCtrl.text.toString(),
          "service_part_given": _servicegivenCtrl.text.toString(),
          'assigned_product_id': assignedProdctId,
          //"service_request_id": service_request_id,
          "custom_fields": json.encode(_values)
        };

        var submitserviceform = FormData.fromMap(formData);
        print(formData);

        if (_reportFile != null) {
          var ReportFile = await MultipartFile.fromFile(_reportFile.path,
              filename: reportString,
              contentType: MediaType("image", reportString));
          submitserviceform.files.add(MapEntry("service_report", ReportFile));
          print(ReportFile);
        }

        if (files != null) {
          for (var file in files) {
            String fileName = file.path.split("/").last;
            var multipartFileSign = await MultipartFile.fromFile(file.path,
                filename: fileName, contentType: MediaType("image", fileName));
            submitserviceform.files.add(MapEntry("images", multipartFileSign));
            print(multipartFileSign);
          }
        }

        Response response = await baseApi.dio
            .post(onsubmitserviceform, data: submitserviceform);
        progressDialog.dismiss();
        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPOONSE service form :" + parsed.toString());
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
        displayToast("Something went wrong", context);
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
                    Get.back();
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

  _selectDate(BuildContext context, String label) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
    print(selectedDate);
    _onUpdate(label, selectedDate.toString());
  }

  Future<Response> serviceform() async {
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
          "product_id": product_id,
          "assigned_product_id": assignedProdctId,

          //"service_request_id": service_request_id
        };
        print(formData.toString());

        var productrespo = FormData.fromMap(formData);

        Response response =
            await baseApi.dio.post(onserviceform, data: productrespo);

        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPONSE of service form list:" + parsed.toString());
          String error = parsed["error"].toString();
          progressDialog.dismiss();
          if (error == "1") {
            CustomFieldModel servicerespo = CustomFieldModel.fromJson(parsed);
            setState(() {
              customfieldlist = servicerespo.custom_fields;
            });
            print("Custom field list");
            print(customfieldlist);
            for (int i = 0; i < customfieldlist.length; i++) {
              label = customfieldlist[i].label;
              labelsplit = label.split(",");
              customdatalist = customfieldlist[i].options.split(",");
              for (var j = 0; j < customdatalist.length; j++) {
                customValues[j] = customdatalist[i];
              }
              //   labelsplit = labellist.split(",");
              /*if (customfieldlist[i].field_type == "dropdown") {
                customdata = selectedups;
                customdatalist = customdata.split(",");
                customdatasplit = customdata.split(",");
                print(customfieldlist[i].options);
                print("customdatalist");
              } else if (customfieldlist[i].field_type == "radio") {
                customdata = selectedRadio;
                customdatasplit = customdata.split(",");
                print(customdatasplit);
              } else if (customfieldlist[i].field_type == "input") {
                customdata = _inputCtrl.text.toString();
                customdatasplit = customdata.split(",");
                print(customdatasplit);
                // customdatalist = customdata.split(",");
                // print(customdatalist);
              } else if (customfieldlist[i].field_type == "date") {
                customdata = selectedDate;
                customdatasplit = customdata.split(",");
                print(customdatasplit);
                // customdatalist = customdata.split(",");
                // print(customdatalist);
              }*/
            }
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
    print("this is service engineer id");
    print(serviceengineerid);
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    List<MultipartFile> multipartImageList = new List<MultipartFile>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } catch (e) {}
    if (!mounted) return;

    setState(() {
      images = resultList;
    });

    for (int i = 0; i < images.length; i++) {
      // String imagePath = await FlutterAbsolutePath.getAbsolutePath(
      //   images[i].identifier,
      // );
      // TODO: get absolute path
      String imagePath = images[i].identifier;
      File file = File(imagePath);
      files.add(file);
      fileitemsServer.add(file.path);
    }
    print(files);
    print(fileitemsServer);
    return files;
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
      print(fileitems);
      print(fileitemsStr);
    } catch (e) {
      print(e);
    }
  }

  void onDropDownChange(dropDownIndex, value) {
    setState(() {
      customValues[dropDownIndex] = value;
    });
    print('onDropDownChange: $dropDownIndex -> $value');
  }
}
