import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddPage extends StatefulWidget {
  AddPage({Key key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController emailController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      inAsyncCall: _loading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add",
            style: TextStyle(color: Colors.black),
          ),
          actions: [],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
}
