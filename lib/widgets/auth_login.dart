import 'package:flutter/material.dart';
import 'package:trybapp/services/auth_service.dart';
import 'package:trybapp/views/email.dart';
import 'package:trybapp/views/phone.dart';

class AuthLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;

    var buttonPadding = EdgeInsets.fromLTRB(width / 5.0, width / 40.0, width / 5.0, width / 40.0);
    var textPadding = EdgeInsets.fromLTRB(0, width / 32.0, 0, width / 32.0);
    var imagePadding = EdgeInsets.fromLTRB(width / 40.0, 0, width / 40.0, 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          child: RaisedButton(
            onPressed: () async {
              await FacebookAuthService.tryAuthenticate();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  child: Image(
                    image: AssetImage("assets/images/facebook_color.png"),
                    height: width / 18.0,
                    width: width / 18.0,
                  ),
                  padding: imagePadding,
                ),
                Text("Continue with Facebook", style: TextStyle(color: Colors.black, fontSize: 12))
              ],
            ),
            color: Colors.grey[300],
          ),
          padding: buttonPadding,
        ),
        Padding(
          child: RaisedButton(
            onPressed: () async {
              await GoogleAuthService.tryAuthenticate();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  child: Image(
                    image: AssetImage("assets/images/google.png"),
                    height: width / 18.0,
                    width: width / 18.0,
                  ),
                  padding: imagePadding,
                ),
                Text(
                  "Continue with Google",
                  style: TextStyle(color: Colors.black, fontSize: 12),
                )
              ],
            ),
            color: Colors.grey[300],
          ),
          padding: buttonPadding,
        ),
        Padding(
          child: RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => EmailPage(),
                ),
              );
            },
            child: Text(
              "Signup with Email",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            color: Theme.of(context).accentColor,
            padding: textPadding,
          ),
          padding: buttonPadding,
        ),
        Padding(
          child: RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => PhonePage(),
                ),
              );
            },
            child: Text(
              "Signup with Phone",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            color: Theme.of(context).accentColor,
            padding: textPadding,
          ),
          padding: buttonPadding,
        ),
      ],
    );
  }
}
