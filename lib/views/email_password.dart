import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:trybapp/services/auth_service.dart';
import 'package:trybapp/services/log_manager.dart';

import 'email_name.dart';

class EmailPasswordPage extends StatefulWidget {
  EmailPasswordPage({
    Key key,
    this.isRegistration,
    this.email,
  }) : super(key: key);
  final String email;
  final bool isRegistration;

  @override
  _EmailPasswordPageState createState() => _EmailPasswordPageState();
}

class _EmailPasswordPageState extends State<EmailPasswordPage> {
  TextEditingController passController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();
  final AppLog _log = LogManager.getLogger('EmailPasswordPage');

  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
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
                      text: widget.isRegistration ? "Create a " : "What's your ",
                      children: [
                        TextSpan(text: "Password", style: Theme.of(context).primaryTextTheme.title),
                      ],
                      style: Theme.of(context).textTheme.title),
                  textAlign: TextAlign.left,
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(width / 20.0, 8, width / 20.0, 8),
                child: Text(
                  widget.isRegistration ? "Let's make your account secure" : "Login securely now",
                  style: Theme.of(context).primaryTextTheme.title,
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(width / 20.0, height / 8.0, width / 20.0, 8),
              child: TextField(
                keyboardType: TextInputType.text,
                obscureText: true,
                autocorrect: false,
                autofocus: true,
                focusNode: _passFocus,
                decoration: InputDecoration.collapsed(
                  hintText: "Password",
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                textInputAction: widget.isRegistration ? TextInputAction.next : TextInputAction.done,
                textAlign: TextAlign.left,
                controller: passController,
                style: Theme.of(context).textTheme.subhead,
                onEditingComplete: () async {
                  if (widget.isRegistration) {
                    _fieldFocusChange(context, _passFocus, _confirmFocus);
                  } else {
                    _passFocus.unfocus();

                    try {
                      //Perform Login
                      await AuthService.instance.signInWithEmail(
                        widget.email,
                        passController.text,
                      );
                    } catch (x) {
                      _log.logException(x);
                    }
                  }
                },
              ),
            ),
            widget.isRegistration
                ? Padding(
                    padding: EdgeInsets.fromLTRB(width / 20.0, height / 20.0, width / 20.0, 8),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      autocorrect: false,
                      autofocus: true,
                      focusNode: _confirmFocus,
                      decoration: InputDecoration.collapsed(
                        hintText: "Confirm Password",
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.left,
                      controller: confirmController,
                      style: Theme.of(context).textTheme.subhead,
                      onEditingComplete: () async {
                        if (passController.text != null && passController.text == confirmController.text) {
                          _confirmFocus.unfocus();
                          return Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => EmailNamePage(
                                password: passController.text,
                                email: widget.email,
                              ),
                            ),
                          );
                        } else {
                          //TODO: Display validation error?
                        }
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
