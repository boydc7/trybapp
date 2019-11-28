import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:trybapp/services/auth_service.dart';
import 'package:trybapp/services/log_manager.dart';

class EmailVerifyPage extends StatefulWidget {
  EmailVerifyPage({
    Key key,
    this.email,
    this.password,
  }) : super(key: key);

  final String email;
  final String password;

  @override
  _EmailVerifyPageState createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends State<EmailVerifyPage> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final AppLog _log = LogManager.getLogger('EmailVerifyPage');
    final double height = screenSize.height;
    final double width = screenSize.width;

    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      inAsyncCall: _loading,
      child: Scaffold(
        appBar: AppBar(actions: [], leading: Container()),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(width / 20.0, 8, width / 20.0, 8),
                child: RichText(
                  text: TextSpan(
                      text: "Please verify your ",
                      children: [
                        TextSpan(text: "Email", style: Theme.of(context).primaryTextTheme.title),
                      ],
                      style: Theme.of(context).textTheme.title),
                  textAlign: TextAlign.left,
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(width / 20.0, 8, width / 20.0, 8),
                child: Text(
                  "Follow emailed instructions",
                  style: Theme.of(context).primaryTextTheme.title,
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(width / 3.0, height / 8.0, width / 3.0, 0),
              child: RaisedButton(
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });

                  try {
                    await AuthService.instance.verifyEmail();
                  } catch (x) {
                    _log.logException(x);
                  } finally {
                    setState(() {
                      _loading = false;
                    });
                  }
                },
                color: Theme.of(context).accentColor,
                child: Text(
                  "Check Now!",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
