import 'package:flutter/material.dart';

class AppbarText extends StatelessWidget {
  const AppbarText({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'MPLUSRounded1c',
        fontWeight: FontWeight.w500,
        fontSize: 22.0,
        color: color,
      ),
    );
  }
}
