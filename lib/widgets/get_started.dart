import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trybapp/services/device_storage.dart';

import 'link_text_span.dart';

class GetStarted extends StatefulWidget {
  GetStarted({Key key}) : super(key: key);

  @override
  _GetStartedState createState() {
    return _GetStartedState();
  }
}

class _GetStartedState extends State<GetStarted> {
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
              FontAwesomeIcons.checkSquare,
              color: Theme.of(context).primaryColor,
              size: height / 8.0,
            ),
            Text(
              "That's it!",
              style: Theme.of(context).primaryTextTheme.title,
              textAlign: TextAlign.center,
            ),
            Padding(
                padding: standardPadding,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'By creating an account and using Tryb, you agree to the ',
                        style: Theme.of(context).textTheme.body1,
                      ),
                      LinkTextSpan(
                        style: Theme.of(context).accentTextTheme.overline,
                        url: 'https://trybglobal.com/tos',
                        text: 'Terms of Use',
                      ),
                      TextSpan(
                        text: ' and the ',
                        style: Theme.of(context).textTheme.body1,
                      ),
                      LinkTextSpan(
                        style: Theme.of(context).accentTextTheme.overline,
                        url: 'https://trybglobal.com/privacy',
                        text: 'Privacy Policy.',
                      ),
                    ],
                  ),
                )),
            Padding(
              padding: standardPadding,
              child: RaisedButton(
                  onPressed: () async {
                    await DeviceStorage.setBool('tryb_onboard_complete', true);
                    await Navigator.of(context).pushReplacementNamed('/');
                  },
                  child: Text("Get Started")),
            )
          ],
        ));
  }
}
