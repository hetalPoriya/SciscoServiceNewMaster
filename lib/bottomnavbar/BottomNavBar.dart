import 'package:flutter/material.dart';
import 'package:scisco_service/bottomnavbar/demo.dart';
import 'package:scisco_service/bottomnavbar/sample.dart';
import 'package:scisco_service/bottomnavbar/test1.dart';

class BottomNavBar extends StatefulWidget {

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentindex = 0;
  final List<Widget> _children = [
    Test(),
    Demo(),
    Sample()
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentindex = index;
    });
    print(_currentindex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentindex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTappedBar,
          currentIndex: _currentindex,
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
                icon: Icon(Icons.description),
                label: 'Installation Requests'),
            new BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Service Requests'),
            new BottomNavigationBarItem(
                icon: Icon(Icons.description),
                label: 'Edit Profile'),
          ],
        )
    );
  }
}
