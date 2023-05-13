import 'package:flutter/material.dart';
import 'package:scisco_service/app_theme.dart';

class Sample extends StatefulWidget {

  @override
  _SampleState createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppTheme.textcolor, //change your color here
        ),
        title: Text(
          "Sample",
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
