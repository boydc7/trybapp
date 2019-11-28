import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:trybapp/services/auth_service.dart';
import 'package:trybapp/services/log_manager.dart';

class EmailNamePage extends StatefulWidget {
  EmailNamePage({
    Key key,
    this.password,
    this.email,
  }) : super(key: key);
  final String email;
  final String password;

  @override
  _EmailNamePageState createState() => _EmailNamePageState();
}

class _EmailNamePageState extends State<EmailNamePage> {
  TextEditingController _firstController = TextEditingController();
  TextEditingController _lastController = TextEditingController();
  final FocusNode _firstFocus = FocusNode();
  final FocusNode _lastFocus = FocusNode();

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
    final AppLog _log = LogManager.getLogger('EmailNamePage');
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
                          text: "Finally! Your ",
                          children: [TextSpan(text: "Name", style: Theme.of(context).primaryTextTheme.title)],
                          style: Theme.of(context).textTheme.title),
                      textAlign: TextAlign.left,
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(width / 20.0, 8, width / 20.0, 8),
                    child: Text("Let's us know your name", style: Theme.of(context).primaryTextTheme.title)),
                Padding(
                  padding: EdgeInsets.fromLTRB(width / 20.0, height / 8.0, width / 20.0, 8),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    autocorrect: false,
                    autofocus: true,
                    focusNode: _firstFocus,
                    decoration: InputDecoration.collapsed(
                        hintText: "Enter your first name here",
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor))),
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.left,
                    controller: _firstController,
                    style: Theme.of(context).textTheme.subhead,
                    onEditingComplete: () async {
                      _fieldFocusChange(context, _firstFocus, _lastFocus);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(width / 20.0, height / 20.0, width / 20.0, 8),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    autocorrect: false,
                    autofocus: true,
                    focusNode: _lastFocus,
                    decoration: InputDecoration.collapsed(
                        hintText: "Enter your last name here",
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor))),
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.left,
                    controller: _lastController,
                    style: Theme.of(context).textTheme.subhead,
                    onEditingComplete: () async {
                      _lastFocus.unfocus();

                      setState(() {
                        _loading = true;
                      });

                      try {
                        await AuthService.instance.signUpWithEmail(
                          widget.email,
                          widget.password,
                          _firstController.text + " " + _lastController.text,
                        );
                      } catch (x) {
                        _log.logException(x);
                      } finally {
                        setState(() {
                          _loading = false;
                        });
                      }
                    },
                  ),
                )
              ],
            )));
  }
}
