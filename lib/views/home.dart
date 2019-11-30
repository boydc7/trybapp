import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trybapp/views/notifications.dart';

import 'add.dart';
import 'dashboard.dart';
import 'favorites.dart';
import 'mytryb.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
    this.initialPath,
  }) : super(key: key);

  final String initialPath;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  int _currentIndex = -1;

  static const List<String> tabs = [
    "dashboard",
    "mytryb",
    "add",
    "favorites",
    "notifications",
  ];

  Widget _getPage() {
    switch (tabs[_currentIndex]) {
      case "add":
        return AddPage();
      case "dashboard":
        return DashboardPage();
      case "favorites":
        return FavoritesPage();
      case "mytryb":
        return MyTrybPage();
      case "notifications":
        return NotificationsPage();
      default:
        return DashboardPage();
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _currentIndex = tabs.indexOf(widget.initialPath);

    if (_currentIndex < 0) {
      _currentIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold();
    }
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: _getPage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex >= 0 ? _currentIndex : 0,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        onTap: _onTabTapped,
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.mapPin,
            ),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.users,
            ),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.userPlus,
              ),
              title: SizedBox.shrink()),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.solidHeart,
            ),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.solidCommentAlt,
              ),
              title: SizedBox.shrink())
        ],
      ),
    );
  }
}
