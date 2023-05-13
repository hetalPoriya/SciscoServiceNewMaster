import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

// import 'package:get/get.dart';
import 'package:scisco_service/Api/BaseApi.dart';
import 'package:scisco_service/Homepage/ServiceEngDashBoard.dart';
import 'package:scisco_service/Homepage/installationform.dart';
import 'package:scisco_service/Homepage/preinstallationform.dart';
import 'package:scisco_service/Homepage/servicerequestdone.dart';
import 'package:scisco_service/Homepage/webserviceform.dart';
import 'package:scisco_service/Utils/CommonLogic.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/components/text_field_container.dart';
import 'package:scisco_service/googleMapScreen/googleMapsScreen.dart';
import 'package:scisco_service/models/AllocatedProdDetail.dart';
import 'package:scisco_service/models/ServicereqDetail.dart';
import 'package:scisco_service/models/getCustomer.dart';
import 'package:scisco_service/models/newCustomerList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarkinScreen extends StatefulWidget {
  const MarkinScreen({Key key}) : super(key: key);

  @override
  State<MarkinScreen> createState() => _MarkinScreenState();
}

class _MarkinScreenState extends State<MarkinScreen> {
  User selectedUser;
  List<User> nameCustomer = <User>[];
  List<ProductDetails> productListData = <ProductDetails>[];
  ProductDetails productDetails = ProductDetails();
  List reasonList = [];
  String selectedReason;
  String selectedId;
  String selectServiceReason;
  String serviceRequestid;

  String selectedcustomerId = "Select Customer";
  String selectedProductId;
  String assignedProductId;
  int shiftended = 0;
  final msgCtrl = TextEditingController();
  SharedPreferences prefs;

  var serviceReg = [
    'Resolved on call',
    'Site visit required',
  ];

  Future<Response> getCustomerList(String reason) async {
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
          "service_engineer_id":
              prefs.getString(SharedPrefKey.SERVICEENGINEERID),
          "reason": reason,
        };
        var CustomerFormData = FormData.fromMap(formData);

        print(formData);

        Response response =
            await baseApi.dio.post(oncustomerlist, data: CustomerFormData);

        var data = json.decode(response.data);
        var message = data["error"];
        var jsonResults = data['customers'] as List;

        if (response != null) {
          progressDialog.dismiss();
          newCustomerList =
              jsonResults.map((place) => Customerss.fromJson(place)).toList();
          debugPrint("Response is " + response.data.toString());
          for (int i = 0; i < newCustomerList.length; i++) {
            var customernames = newCustomerList[i].name;
            setState(() {
              nameCustomer.add(User(
                name: customernames,
                id: newCustomerList[i].id,
                // productId: newCustomerList[i]["product_id"],
              ));
            });
          }
          print(nameCustomer);
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

  Future<Response> getReason() async {
    bool isDeviceOnline = true;

    if (isDeviceOnline) {
      try {
        BaseApi baseApi = new BaseApi();

        Response response = await baseApi.dio.post(markin_reason);

        var data = json.decode(response.data);
        var message = data["error"];
        setState(() {
          reasonList = data['reasons'] as List;
        });

        if (response != null) {
          final parsed = json.decode(response.data).cast<String, dynamic>();
          print("RESPONSE of get Reason list:" + parsed.toString());
        }
        return response;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<Response> getProductsApi(String reason) async {
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
          "service_engineer_id":
              prefs.getString(SharedPrefKey.SERVICEENGINEERID),
          "reason": selectedReason,
          "customer_id": selectedcustomerId,
        };
        var productFormData = FormData.fromMap(formData);

        print("getProductApi request is " + formData.toString());

        Response response =
            await baseApi.dio.post(onProductList, data: productFormData);

        var data = json.decode(response.data);
        var message = data["error"];
        var jsonResults = data['products'] as List;

        if (response != null) {
          progressDialog.dismiss();
          var newProductsList = jsonResults
              .map((product) => ProductDetails.fromJson(product))
              .toList();

          debugPrint("getProductApi Response is " + response.data.toString());
          // productDetails = response.data;

          productListData = [];
          for (int i = 0; i < newProductsList.length; i++) {
            var productNames = newProductsList[i].productName;
            setState(() {
              productListData.add(ProductDetails(
                  productName: productNames,
                  productId: newProductsList[i].productId,
                  assignedProductId: newProductsList[i].assignedProductId,
                  serviceRequestid: newProductsList[i].serviceRequestid));
            });
          }
          //selectedProductId = productListData[0].productId;
          // print(newProductsList);
          // print('selectedProductId $selectedProductId');
          //for zero

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

  void handleMarkInSubmit() async {
    print('HELLO123');
    print('selectedReason $selectedReason');
    // TODO: call the markin api here and send a response to the previous screen again
    await prefs.setString(SharedPrefKey.MARK_IN_REASON, selectedReason);
    await prefs.setString(SharedPrefKey.SELECTED_CUSTOMER, selectedcustomerId);
    await prefs.setString(
        SharedPrefKey.PRODUCTID, selectedProductId.toString());
    await prefs.setString(
        SharedPrefKey.ASSIGNEDPRODUCTID, assignedProductId.toString());
    await prefs.setString(
        SharedPrefKey.SERVICEREASON, selectServiceReason.toString());
    await prefs.setString(
        SharedPrefKey.SERVICEREQID, serviceRequestid.toString());

    // if (selectedReason == 'Pre Installation') {
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //         builder: ((context) => PreInstallationForm(
    //             selectedcustomerId,
    //             selectedProductId,
    //             prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID)))),
    //     (route) => false,
    //   );
    // }
    // if (selectedReason == 'Installation') {
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //         builder: ((context) => InstallationForm(
    //             selectedcustomerId,
    //             selectedProductId,
    //             prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID)))),
    //     (route) => false,
    //   );
    // }
    // if (selectedReason == 'Service') {
    //   if (selectServiceReason == 'Resolved on call') {
    //     return Get.dialog(AlertDialog(
    //       title: Text("Are you sure you want to submit Resolved on call"),
    //       actions: [
    //         ElevatedButton(
    //           onPressed: () async {
    //             Get.back();
    //             // print('Called');
    //             // Get.off(() => ServiceForm(
    //             //     customer_id,
    //             //     product_id,
    //             //     assignedProductId));
    //             // servicereqdetail();
    //             await serviceresponse(serviceRequestid, "Resolved on call");
    //             Navigator.pushAndRemoveUntil(
    //                 context,
    //                 MaterialPageRoute(builder: (context) => ServiceRequest()),
    //                 (route) => false);
    //           },
    //           child: Text(
    //             "Yes",
    //           ),
    //         ),
    //         ElevatedButton(
    //           onPressed: () => {
    //             Get.back(),
    //           },
    //           child: Text(
    //             "No",
    //           ),
    //         )
    //       ],
    //     ));
    //   } else {
    //     await serviceresponse(serviceRequestid, "Site visit required");
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //           builder: ((context) => WebServiceForm(
    //               selectedcustomerId, selectedProductId, serviceRequestid))),
    //       (route) => false,
    //     );
    //   }
    //
    //   // Navigator.pushAndRemoveUntil(
    //   //   context,
    //   //   MaterialPageRoute(
    //   //       builder: ((context) => WebServiceForm(
    //   //           selectedcustomerId,
    //   //           selectedProductId,
    //   //           prefs.getString(SharedPrefKey.ASSIGNEDPRODUCTID)))),
    //   //   (route) => false,
    //   // );
    // }
    Get.back();
  }

  @override
  void initState() {
    // TODO: implement initState
    getPrefInit();
    getReason();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppTheme.textcolor, //change your color here
          ),
          title: Text(
            "Mark-In",
            textAlign: TextAlign.start,
            maxLines: 2,
            style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w800),
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Get.back();
                // navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (BuildContext ctx) => MapsScreen(),
                //   ),
                // );
              }),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                TextFieldContainer(
                  child: DropdownButton<String>(
                    value: selectedReason,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    underline: Container(
                      height: 0,
                      color: Colors.black,
                    ),
                    hint: Text("--Reason--"),
                    onChanged: (String value) {
                      setState(() {
                        nameCustomer.clear();

                        selectedReason = value;
                        selectedcustomerId = "Select Customer";
                      });
                      if (selectedReason == "Rest" ||
                          selectedReason == "In office") {
                        print("-------------");
                      } else {
                        getCustomerList(selectedReason);
                        print(nameCustomer);
                      }
                    },
                    items: reasonList.map<DropdownMenuItem<String>>((data) {
                      return DropdownMenuItem<String>(
                        child: Text(data),
                        value: data,
                      );
                    }).toList(),
                  ),
                ),
                (selectedReason == "Rest" || selectedReason == "In office")
                    ? Container()
                    : TextFieldContainer(
                        child: DropdownButton<String>(
                            value: selectedcustomerId,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            underline: Container(
                              height: 0,
                              color: Colors.black,
                            ),
                            hint: Text("--Customer--"),
                            onChanged: (String value) async {
                              setState(() {
                                selectedcustomerId = value;
                              });
                              prefs.setString(
                                  SharedPrefKey.SELECTED_CUSTOMER, value);
                              productListData.clear();
                              productListData = <ProductDetails>[];
                              print('CLEAR DATA ${productListData}');
                              await getProductsApi(value);
                              if (productListData.length == 0) {
                                Get.snackbar(
                                  "No products found",
                                  "Please select different customer",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                  padding: EdgeInsets.all(20),
                                  margin: EdgeInsets.all(20),
                                );
                              }
                            },
                            items: [
                              DropdownMenuItem<String>(
                                child: Text("Select Customer"),
                                value: "Select Customer",
                              ),
                              for (var data in nameCustomer)
                                DropdownMenuItem<String>(
                                  onTap: () {
                                    print('PRINT ${data.name}');
                                  },
                                  child: Text(data.name),
                                  value: data.id,
                                ),
                            ]),
                      ),
                (selectedReason == "Rest" || selectedReason == "In office")
                    ? Container()
                    : TextFieldContainer(
                        child: DropdownButton<String>(
                          value: selectedProductId,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          underline: Container(
                            height: 0,
                            color: Colors.black,
                          ),
                          hint: Text("--Product--"),
                          onChanged: (String value) {
                            print('PRINT ${value}');
                            setState(() {
                              selectedProductId = value;
                            });
                            prefs.setString(SharedPrefKey.PRODUCTID,
                                selectedProductId.toString());
                          },
                          items: productListData.map((data) {
                            return DropdownMenuItem<String>(
                              child: Text(data.productName),
                              value: data.productId,
                              onTap: () {
                                assignedProductId = data.assignedProductId;
                                serviceRequestid = data.serviceRequestid;
                                setState(() {});
                              },
                            );
                          }).toList(),
                        ),
                      ),
                if (selectedReason == "Service" && selectedProductId != null)
                  TextFieldContainer(
                    child: DropdownButton<String>(
                      value: selectServiceReason,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      underline: Container(
                        height: 0,
                        color: Colors.black,
                      ),
                      hint: Text("--Service Request--"),
                      onChanged: (String value) {
                        setState(() {
                          selectServiceReason = value;
                          print('PRINT ${selectServiceReason}');
                        });
                      },
                      items: serviceReg.map((data) {
                        return DropdownMenuItem<String>(
                          child: Text(data),
                          value: data,
                        );
                      }).toList(),
                    ),
                  ),
                InkWell(
                  onTap: () {
                    handleMarkInSubmit();
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 50,
                    ),
                    width: 125,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppTheme.appColor),
                    child: Text(
                      "Submit",
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
            ),
          ),
        ),
      ),
    );
  }

  void getPrefInit() async {
    prefs = await SharedPreferences.getInstance();
  }
}
