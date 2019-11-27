import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trybapp/theme.dart';

import 'loading_dots_progress_indicator.dart';

class Loading extends StatefulWidget {
  final String text;

  Loading({this.text});

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppGradients.coralGradient,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/images/logo.svg',
            semanticsLabel: 'Tryb Logo',
            height: 70,
          ),
          Padding(
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
              ),
            ),
            padding: EdgeInsets.all(8.0),
          ),
          JumpingDotsProgressIndicator(
            color: AppColors.darkBlue,
            fontSize: 40.0,
            numberOfDots: 5,
            milliseconds: 150,
          )
        ],
      ),
    );
  }
}
