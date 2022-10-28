import 'package:flutter/material.dart';
import 'package:todo_list/theme/app_theme.dart';

class ButtonComponent extends StatelessWidget {
  final String? titulo;
  final Function? onPressed;
  final Color? backgroundColor;
  final Color? fontColor;
  const ButtonComponent({Key? key, this.titulo, this.onPressed, this.backgroundColor, this.fontColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => {
        if (onPressed != null) {onPressed!()}
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor ?? accentColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
      child: Text(
        titulo ?? '',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          color: fontColor ?? Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
