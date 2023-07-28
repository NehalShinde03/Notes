import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/adapters/notes_adapter.dart';
import 'package:notes_app/sized_config.dart';
import 'package:notes_app/splash_screen.dart';

void main() async{

  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');

  //it is for screen size
  runApp(
      LayoutBuilder(
          builder:(context,constraints){
            return OrientationBuilder(
                builder: (context,orientation){
                    Sized_Config().init(constraints,orientation);
                    return  const MaterialApp(
                      debugShowCheckedModeBanner: false,
                      home: MyApp(),
                    );
              }
            );
          }
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Splash_Screen(),
      ),
    );
  }
}
