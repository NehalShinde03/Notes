import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/adapters/notes_adapter.dart';
import 'package:notes_app/callbacks/card_callback.dart';
import 'package:notes_app/new_note.dart';
import 'package:notes_app/sized_config.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({Key? key}) : super(key: key);

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  String a = '';
  int b = 0;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      final isPortrait = orientation == Orientation.portrait;
      return Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0x8e6f8177),
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: Color(0xff2d2d2d), width: 4.0),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    //goto new_note with parameter titles,description,index,date and color
                    builder: (context) => New_Note(
                        titles: a,
                        description: a,
                        index: a,
                        date: a,
                        colors: b)));
          },
          child: const Icon(Icons.add, color: Color(0xff2d2d2d)),
        ),
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(top: isPortrait ? 35 : 6, left: 5),
            child: Text(
              "Notes",
              style: TextStyle(
                fontSize: isPortrait
                    ? Sized_Config.txtAdjust * 11
                    : Sized_Config.txtAdjust * 8,
                fontFamily: 'Ropa Sans',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          bottomOpacity: 0,
          toolbarOpacity: 0.0,
          backgroundColor: Colors.transparent,

          //your phone is landscape mode or portrait mode it automatically adjust cards or your notes
          toolbarHeight: isPortrait
              ? Sized_Config.txtAdjust * 12
              : Sized_Config.txtAdjust * 6,
        ),
        body: SafeArea(
            child: ValueListenableBuilder(
          valueListenable: Hive.box<Note>('notes').listenable(),
          builder: (context, Box<Note> box, orientation) {
            //if notes is empty
            if (box.values.isEmpty) {
              return Center(
                child: Text("Note's not Available...",
                    style: TextStyle(
                        fontSize: Sized_Config.txtAdjust * 3.5,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff3b3b3b)),
                    textAlign: TextAlign.center),
              );
            }
            return Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50)),
                ),
                width: isPortrait
                    ? Sized_Config.widthAdjust * 100
                    : double.infinity,
                margin: const EdgeInsets.only(top: 30),
                padding: EdgeInsets.only(
                    left: Sized_Config.widthAdjust * 3,
                    right: Sized_Config.widthAdjust * 3,
                    top: Sized_Config.heightAdjust * 1.6),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isPortrait ? 2 : 4,
                  ),
                  reverse: true,
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    Note? note = box.getAt(index);
                    return Card(
                      elevation: 10,
                      color: Color(note!.colors),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            Sized_Config.heightAdjust * 3.8),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Card_Callback(
                            color: Color(note.colors),
                            onclicked: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => New_Note(
                                          titles: note.title,
                                          description: note.description,
                                          index: index,
                                          date: note.dateTime,
                                          colors: note.colors)));
                            },
                            child: SizedBox(
                              height: 190,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  note.title,
                                  style: TextStyle(
                                      fontSize: isPortrait
                                          ? Sized_Config.txtAdjust * 3.5
                                          : Sized_Config.txtAdjust * 3,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff3f3b3b),
                                      fontFamily: 'Cabin Sketch'),
                                  textAlign: TextAlign.center,
                                  maxLines: isPortrait ? 4 : 3,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: isPortrait ? 152 : 131, left: 8),
                            child: Card_Callback(
                                onclicked: () async {
                                  await box.deleteAt(index);
                                },
                                color: Color(note.colors),
                                child: const Icon(Icons.delete_outline_outlined,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                ));
          },
        )),
      );
    });
  }
}
