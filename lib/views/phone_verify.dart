import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:trybapp/services/auth_service.dart';
import 'package:trybapp/services/log_manager.dart';

class PhoneVerifyPage extends StatefulWidget {
  PhoneVerifyPage({Key key}) : super(key: key);

  @override
  _PhoneVerifyPageState createState() => _PhoneVerifyPageState();
}

class _PhoneVerifyPageState extends State<PhoneVerifyPage> {
  TextEditingController codeController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLog _log = LogManager.getLogger('PhoneVerify');
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
                      text: "Verify your ",
                      children: [
                        TextSpan(text: "Phone Number", style: Theme.of(context).primaryTextTheme.title),
                      ],
                      style: Theme.of(context).textTheme.title),
                  textAlign: TextAlign.left,
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(width / 20.0, height / 8.0, width / 20.0, 8),
              child: TextField(
                keyboardType: TextInputType.phone,
                autocorrect: false,
                autofocus: true,
                decoration: InputDecoration.collapsed(
                  hintText: "Enter sms code",
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.left,
                controller: codeController,
                style: Theme.of(context).textTheme.subhead,
                onEditingComplete: () async {
                  try {
                    await AuthService.instance.verifyPhoneNumber(codeController.text);
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
