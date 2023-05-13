import 'package:flutter/material.dart';
import 'package:scisco_service/Homepage/EditScreen.dart';
import 'package:scisco_service/Homepage/home_screen.dart';
import 'package:scisco_service/Utils/CommonStrings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/sizeconfig.dart';

class Dashboard extends StatefulWidget {
  bool isLogin;
  String customerid;
  String customername;

   Dashboard(this.isLogin,this.customerid,this.customername);

  @override
  _DashboardState createState() => _DashboardState(this.isLogin,this.customerid,this.customername);
}

class _DashboardState extends State<Dashboard> {
  int _pageIndex = 0;
  PageController _pageController;

  List<Widget> tabPages = [
    HomeScreen(),
    EditScreen(),
//    Tex()
  ];
  SharedPreferences prefs;
  bool isLogin;
  var customerid;
  var customername;
  var customeremail;
  var customermobile;
  var customeraddress;
  var customerwhatsapp;
  var customerorganization;

  _DashboardState(this.isLogin,this.customerid,this.customername);

  @override
  void initState() {
    initPrefs();
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
        return Scaffold(
          bottomNavigationBar: SizedBox(
              height: SizeConfig.blockSizeVertical*9,
              child: BottomNavigationBar(
            currentIndex: _pageIndex,
            onTap: onTabTapped,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            elevation: 10,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            items: <BottomNavigationBarItem>[
              new BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Icon(Icons.widgets_outlined),
                      ),
                    ],
                  ), label: 'Product List',),
              new BottomNavigationBarItem(icon: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Icon(Icons.person_outline),
                  ),
                ],
              ), label: 'Profile'),
           //   new BottomNavigationBarItem(icon: Icon(Icons.print), label: 'test'),
            ],
          )),
          body: PageView(
            children: tabPages,
            onPageChanged: onPageChanged,
            controller: _pageController,
          ),
 );
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool(SharedPrefKey.ISLOGEDIN);
    if(isLogin == null){
      isLogin = false;
    }
    setState(() {
      customerid = prefs.getString(SharedPrefKey.COSTUMERID);
      customername = prefs.getString(SharedPrefKey.CUSTOMERNAME);
      customeremail = prefs.getString(SharedPrefKey.EMAILID);
      customeraddress = prefs.getString(SharedPrefKey.ADDRESS);
      customermobile = prefs.getString(SharedPrefKey.MOBILENO);
      customerwhatsapp = prefs.getString(SharedPrefKey.WHATSAPP);
      customerorganization = prefs.getString(SharedPrefKey.ORGANIZATION);
    });
  }

  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,duration: const Duration(milliseconds: 400),curve: Curves.easeInOut);
  }
}
