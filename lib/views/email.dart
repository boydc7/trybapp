import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:trybapp/services/auth_service.dart';
import 'package:trybapp/services/log_manager.dart';
import 'email_password.dart';
import 'package:pedantic/pedantic.dart';

class EmailPage extends StatefulWidget {
  EmailPage({Key key}) : super(key: key);

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final AppLog _log = LogManager.getLogger('EmailPage');

  TextEditingController emailController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;

    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      inAsyncCall: _loading,
      child: Scaffold(
        appBar: AppBar(
            actions: [],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(width / 20.0, 8, width / 20.0, 8),
                child: RichText(
                  text: TextSpan(
                      text: "What's your ",
                      children: [TextSpan(text: "Email", style: Theme.of(context).primaryTextTheme.title)],
                      style: Theme.of(context).textTheme.title),
                  textAlign: TextAlign.left,
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(width / 20.0, 8, width / 20.0, 8),
                child: Text(
                  "Check your email",
                  style: Theme.of(context).primaryTextTheme.title,
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(width / 20.0, height / 8.0, width / 20.0, 8),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                decoration: InputDecoration.collapsed(
                    hintText: "Enter your email",
                    border: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor))),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.left,
                controller: emailController,
                style: Theme.of(context).textTheme.subhead,
                onEditingComplete: () async {
                  try {
                    var exists = await AuthService.instance.checkEmail(emailController.text);

                    if (exists) {
                      unawaited(
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => EmailPasswordPage(
                              isRegistration: false,
                              email: emailController.text,
                            ),
                          ),
                        ),
                      );
                    } else {
                      unawaited(
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => EmailPasswordPage(
                              isRegistration: true,
                              email: emailController.text,
                            ),
                          ),
                        ),
                      );
                    }
                  } catch (x) {
                    _log.logException(x);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
