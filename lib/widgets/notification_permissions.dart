import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trybapp/services/notification_service.dart';

class NotificationsPermissions extends StatefulWidget {
  @override
  _NotificationsPermissionsState createState() {
    return _NotificationsPermissionsState();
  }
}

class _NotificationsPermissionsState extends State<NotificationsPermissions> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;

    var standardPadding = EdgeInsets.fromLTRB(0, height / 30.0, 0, height / 30.0);

    return Padding(
        padding: EdgeInsets.fromLTRB(width / 10.0, 0, width / 10.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              FontAwesomeIcons.exclamationTriangle,
              color: Theme.of(context).primaryColor,
              size: height / 8.0,
            ),
            Text(
              "Stay up to date",
              style: Theme.of(context).primaryTextTheme.title,
              textAlign: TextAlign.center,
            ),
            Padding(
                padding: standardPadding,
                child: Text(
                    "Stay up to date with goings on. Click the button below to allow us to send you notifications "
                    "about your services, customers, appointments, and more.",
                    textAlign: TextAlign.justify)),
            Padding(
              padding: standardPadding,
              child: RaisedButton(
                  onPressed: () async {
                    await NotificationService.instance.requestNotificationPermissions();
                  },
                  child: Text(
                    "Yes, keep me informed!",
                  )),
            )
          ],
        ));
  }
}
