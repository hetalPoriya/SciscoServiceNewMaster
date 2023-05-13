import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:scisco_service/app_theme.dart';
import 'package:scisco_service/components/text_field_container.dart';
import 'package:scisco_service/googleMapScreen/googleMapsScreen.dart';
import 'package:scisco_service/models/getCustomer.dart';

class MarkOutScreen extends StatefulWidget {
  const MarkOutScreen({Key key}) : super(key: key);

  @override
  State<MarkOutScreen> createState() => _MarkOutScreenState();
}

class _MarkOutScreenState extends State<MarkOutScreen> {
  List nameCustomer = [];
  List reasonList = [];
  String selectedReason;

  String selectedcustomer;
  int shiftended = 0;
  final msgCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppTheme.textcolor, //change your color here
          ),
          title: Text(
            "Mark-Out",
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
              onPressed: () async {
                Get.back();
                // navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (BuildContext ctx) => MapsScreen()));
              }),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              TextFieldContainer(
                child: DropdownButton<String>(
                  value: selectedcustomer,
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
                  onChanged: (String value) {
                    setState(() {
                      selectedcustomer = value;
                    });
                    print(selectedcustomer);
                  },
                  items: customerList.map<DropdownMenuItem<String>>((data) {
                    return DropdownMenuItem<String>(
                      child: Text(data),
                      value: data,
                    );
                  }).toList(),
                ),
              ),
              TextFieldContainer(
                child: TextField(
                  controller: msgCtrl,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    // new WhitelistingTextInputFormatter(
                    //     RegExp("[a-zA-Z 0-9]")),
                  ],
                  cursorColor: AppTheme.nearlyBlack,
                  decoration: InputDecoration(
                    hintText: "Enter message",
                    icon: Icon(Icons.message),
                    border: InputBorder.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
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
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
