//callback
import 'package:flutter/material.dart';

class Add_Callback extends StatelessWidget {

  final Widget child;
  final Color color;
  final VoidCallback onclicked;

  const Add_Callback({
    Key? key,
    required this.child,
    required this.color,
    required this.onclicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
      onPressed: onclicked,
      child: child,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color)
      ),
  );
}
