import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  const ButtonText({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
    required this.size,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 25.0 * (size / 20.0),
        ),
        SizedBox(
          width: 10.0 * (size / 20.0),
        ),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'MPLUSRounded1c',
            fontWeight: FontWeight.w400,
            color: color,
            fontSize: size,
          ),
        ),
      ],
    );
  }
}
