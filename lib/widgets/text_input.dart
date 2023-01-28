import 'package:flutter/material.dart';
import 'package:pokemon_battle_logger/constants/theme_colors.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  final String labelText;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(
          fontFamily: 'MPLUSRounded1c',
          fontWeight: FontWeight.w400,
          color: ThemeColors.bodyForegroundColor,
          fontSize: 12.0,
        ),
        hintStyle: TextStyle(
          fontFamily: 'MPLUSRounded1c',
          fontWeight: FontWeight.w300,
          color: ThemeColors.bodyForegroundColor,
          fontSize: 12.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeColors.buttonHighlightedBackgroundColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ThemeColors.buttonBackgroundColor,
          ),
        ),
      ),
    );
  }
}
