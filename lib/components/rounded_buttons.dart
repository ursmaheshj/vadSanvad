import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {Key? key, this.text, this.color, required this.onpressed})
      : super(key: key);
  // ignore: use_key_in_widget_constructors
  //  const RoundedButton({this.text, this.color, required this.onpressed});
  final String? text;
  final Color? color;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onpressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text!,
            style: const  TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
