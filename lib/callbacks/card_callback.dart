//callback for card
import 'package:flutter/material.dart';
import 'package:notes_app/sized_config.dart';

class Card_Callback extends StatelessWidget {

  final Widget child;
  final Color color;
  final VoidCallback onclicked;

  const Card_Callback({
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
         backgroundColor: MaterialStateProperty.all(color),
         shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sized_Config.heightAdjust*3.8),
          ))
     ),
   );
}
