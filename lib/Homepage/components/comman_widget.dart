import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../googleMapScreen/googleMapsScreen.dart';

class CommanWidget {
  static Widget punchOutWidget({Size size}) => Container(
      width: size.width,
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * .02,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text('You have not Punched In yet Please PunchIn',
                textAlign: TextAlign.center,
                maxLines: null,
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: "ProximaNova")),
          ),
          SizedBox(
            height: size.height * .02,
          ),
          Image.asset(
            "assets/images/punch_in.gif",
            height: size.height * .40,
            width: size.width * .80,
          ),
          SizedBox(
            height: size.height * .02,
          ),
          InkWell(
            onTap: () {
              navigator.pop();
              navigator.push(MaterialPageRoute(
                  builder: (BuildContext ctx) => MapsScreen()));
            },
            child: Container(
              width: size.width * .40,
              height: size.height * .06,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(size.width * .02)),
              child: Text('Punch In',
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: "ProximaNova")),
            ),
          ),
        ],
      ));
}
