import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trybapp/theme.dart';
import 'package:trybapp/widgets/auth_login.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Widget _getAuthComponent() {
    return AuthLogin();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;

    final welcome = Text(
      "Welcome to Tryb",
      style: Theme.of(context).textTheme.headline,
      textAlign: TextAlign.center,
    );

    final moto = Text(
      "\"Tryb helps you find the services you need within your trusted circle of family, friends, colleagues, and neighbors\"",
      style: Theme.of(context).textTheme.caption,
      textAlign: TextAlign.center,
    );

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.white,
    ));

    return Scaffold(
      primary: false,
      appBar: null,
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Container(
            height: height / 2.5,
            child: OverflowBox(
              minHeight: height / 2.5,
              minWidth: width,
              maxWidth: width * 10,
              child: Container(
                height: height / 2.5,
                width: width * 1.4,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(width * 1.4 / 2.0),
                    bottomLeft: Radius.circular(width * 1.4 / 2.0),
                  ),
                ),
                child: Center(
                  child: Container(
                    height: screenSize.height / 10 * 1.4,
                    alignment: Alignment(0, 2.5 * 1.4),
                    child: SvgPicture.asset(
                      'assets/images/logo.svg',
                      semanticsLabel: 'Tryb Logo',
                      height: screenSize.height / 10,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                welcome,
                SizedBox(height: 10.0),
                Container(
                  child: moto,
                  padding: EdgeInsets.only(
                    left: 60.0,
                    right: 60.0,
                  ),
                ),
                SizedBox(height: 30.0),
                _getAuthComponent(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
