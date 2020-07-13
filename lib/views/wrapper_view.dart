import 'package:flutter/material.dart';
import 'package:parkIt/views/booked_view.dart';
import 'package:parkIt/views/home_view.dart';
import 'package:parkIt/views/user_dashboard_view.dart';

class WrapperView extends StatefulWidget {
  WrapperView({Key key}) : super(key: key);

  @override
  _WrapperViewState createState() => _WrapperViewState();
}

class _WrapperViewState extends State<WrapperView> {
  int _index = 0;

  static List<Widget> _widgetOption = <Widget>[
    HomeView(),
    BookedView(),
    UserDashboardView(),
  ];

  void _getNewIndex(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).accentColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('Booked'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('User'),
          ),
        ],
        currentIndex: _index,
        onTap: _getNewIndex,
      ),
      body: _widgetOption.elementAt(_index),
    );
  }
}
