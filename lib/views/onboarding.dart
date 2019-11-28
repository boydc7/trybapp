import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trybapp/services/permission_service.dart';
import 'package:trybapp/widgets/carousel_slider.dart';
import 'package:trybapp/widgets/get_started.dart';
import 'package:trybapp/widgets/location_permissions.dart';
import 'package:trybapp/widgets/match_contacts.dart';
import 'package:trybapp/widgets/notification_permissions.dart';

class OnBoardingPage extends StatefulWidget {
  OnBoardingPage({Key key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int _current = 0;
  List<Widget> onBoardingComponents = [];

  @override
  void initState() {
    super.initState();
    getOnBoardingComponents();
  }

  getOnBoardingComponents() async {
    this.onBoardingComponents = [];

    var contactsPermission = await PermissionService.instance().havePermission(
      permission: PermissionGroup.contacts,
    );

    if (!contactsPermission) {
      this.onBoardingComponents.add(MatchContacts());
    }

    var locationPermission = await PermissionService.instance().havePermission(
      permission: PermissionGroup.location,
    );

    if (!locationPermission) {
      this.onBoardingComponents.add(LocationPermissions());
    }

    //TODO: Permission handler does not have entry for push notification monitoring
    //TODO: either use firebase messaging stream or other plugin
    var notificationPermission = false;

    if (!notificationPermission) {
      this.onBoardingComponents.add(NotificationsPermissions());
    }

    this.onBoardingComponents.add(GetStarted());
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;
    return Scaffold(
        primary: false,
        backgroundColor: Colors.white,
        body: Padding(
            padding: EdgeInsets.fromLTRB(0, 100, 0, 50),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CarouselSlider(
                    height: height / 1.5,
                    onPageChanged: (index) {
                      setState(() {
                        _current = index;
                      });
                    },
                    enableInfiniteScroll: false,
                    viewportFraction: 1.0,
                    items: onBoardingComponents,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: onBoardingComponents.isNotEmpty
                        ? onBoardingComponents.map((el) {
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: onBoardingComponents[_current] == el
                                      ? Color.fromRGBO(0, 0, 0, 0.9)
                                      : Color.fromRGBO(0, 0, 0, 0.4)),
                            );
                          }).toList()
                        : [Container()],
                  )
                ])));
  }

  @override
  void didUpdateWidget(OnBoardingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    getOnBoardingComponents();
  }
}
