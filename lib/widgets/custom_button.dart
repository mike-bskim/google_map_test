import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  // final Function onPressed;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.indigo,
      textColor: Colors.white,
      minWidth: 300,
      height: 45,
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
