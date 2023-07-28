//splash screen

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/home_screen.dart';
import 'package:notes_app/sized_config.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  int a=0;
  @override
  initState(){
    super.initState();
    Timer(const Duration(seconds: 3),(){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home_Screen()));
    });
  }

  @override
  Widget build(BuildContext context) {
     return Center(
         child: Stack(
           alignment: Alignment.bottomCenter,
           children: [
             Lottie.asset("assets/images/splash_screen.json",fit: BoxFit.fill,
                            width: Sized_Config.widthAdjust*42,height: Sized_Config.heightAdjust*28),
              Text("Notes App",
                 style: TextStyle(
                     fontSize: Sized_Config.txtAdjust*4,
                     fontFamily: 'Cabin Sketch',
                     fontWeight: FontWeight.w700,
                     color: Colors.white
                 )
             )
           ],
         )
     );
  }
}