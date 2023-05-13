import 'package:flutter/material.dart';
import 'package:scisco_service/app_theme.dart';

class Test extends StatefulWidget {

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppTheme.textcolor, //change your color here
        ),
        title: Text(
          "Test1",
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
      ),
    );
  }
}
