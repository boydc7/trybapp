import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trybapp/services/permission_service.dart';

class LocationPermissions extends StatefulWidget {
  LocationPermissions({Key key}) : super(key: key);

  @override
  _LocationPermissionsState createState() {
    return _LocationPermissionsState();
  }
}

class _LocationPermissionsState extends State<LocationPermissions> {
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
              FontAwesomeIcons.mapPin,
              color: Theme.of(context).primaryColor,
              size: height / 8.0,
            ),
            Text(
              "Share your location",
              style: Theme.of(context).primaryTextTheme.title,
              textAlign: TextAlign.center,
            ),
            Padding(
                padding: standardPadding,
                child: Text(
                  "Allow us to access your location when using the app to match you with service providers and customers nearby",
                  textAlign: TextAlign.justify,
                )),
            Padding(
              padding: standardPadding,
              child: RaisedButton(
                  onPressed: () async {
                    var havePermission = await PermissionService.instance().requestPermission(
                      permission: PermissionGroup.location,
                      force: true,
                    );

                    // TODO: Store permission access?
                  },
                  child: Text(
                    "Share my location",
                  )),
            )
          ],
        ));
  }
}
