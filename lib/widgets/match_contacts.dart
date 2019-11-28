import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedantic/pedantic.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trybapp/services/contact_sync_service.dart';
import 'package:trybapp/services/permission_service.dart';

class MatchContacts extends StatefulWidget {
  @override
  _MatchContactsState createState() {
    return _MatchContactsState();
  }
}

class _MatchContactsState extends State<MatchContacts> {
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
              FontAwesomeIcons.userPlus,
              color: Theme.of(context).primaryColor,
              size: height / 8.0,
            ),
            Text(
              "Match your Contacts",
              style: Theme.of(context).primaryTextTheme.title,
              textAlign: TextAlign.center,
            ),
            Padding(
                padding: standardPadding,
                child: Text(
                  "Match your existing contacts, existing service providers and customers in Tryb. "
                  "Click the button below to allow access to your contacts in order to match them to existing Tryb users. "
                  "You will be prompted to allow us access to do so. Note that we do not store any of your contacts anywhere in our app or on our servers.",
                  textAlign: TextAlign.justify,
                )),
            Padding(
              padding: standardPadding,
              child: RaisedButton(
                  onPressed: () async {
                    var havePermission = await PermissionService.instance().requestPermission(
                      permission: PermissionGroup.contacts,
                      force: true,
                    );

                    if (havePermission) {
                      unawaited(ContactSyncService.instance().syncDeviceContacts());
                    }
                  },
                  child: Text(
                    "Match my Contacts",
                  )),
            )
          ],
        ));
  }
}
