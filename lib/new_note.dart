import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/callbacks/add_callback.dart';
import 'package:notes_app/sized_config.dart';
import 'package:notes_app/adapters/notes_adapter.dart';
import 'package:share/share.dart';
import  'package:intl/intl.dart';

class New_Note extends StatefulWidget {
  var titles;
  var description;
  var index;
  var date;
  var colors;

  New_Note({Key? key,required this.titles, required this.description,
                required this.index, required this.date, required this.colors}) : super(key: key);

  final formKey=GlobalKey<FormState>();
  @override
  State<New_Note> createState() => _New_NoteState();
}

class _New_NoteState extends State<New_Note> {

  var c = const Color(0xdbc4bfbf).value;
  final _name = 'Note';
  final _title_hint = 'Title';
  final _description_hint = '- Content';
  String title = '';
  String description = '';
  String snackBar_msg = '';
  String currDateTime=DateFormat("dd-MM-yyyy").format(DateTime.now());
  String dateTime='';
  Box<Note> noteBox = Hive.box<Note>('notes');


  //update data
  updateData() async {
    if(title_controller.text.isNotEmpty && description_controller.text.isNotEmpty){

     if(title.isNotEmpty && description.isNotEmpty){
       if(title.toString() == title_controller.text.toString() &&  description.toString() == description_controller.text.toString()){
         setState(() => dateTime=widget.date );
       }
       else{
         setState(() => dateTime=currDateTime );
       }
       await noteBox.putAt(widget.index, Note(title: title,
           description: description, dateTime: dateTime, colors:widget.colors));
     }

     else if(title.isEmpty && description.isNotEmpty){
       setState(() => dateTime=currDateTime );
       await noteBox.putAt(widget.index, Note(title: _name,
           description: description, dateTime: dateTime, colors:widget.colors));
     }

     else if(title.isNotEmpty && description.isEmpty){
       setState(() => dateTime=currDateTime );
       await noteBox.putAt(widget.index, Note(title: title,
           description: '', dateTime: dateTime, colors:widget.colors));
     }

     else{
       snackBar_msg = 'Empty note discarded...';
       snackBar(snackBar_msg);
       await noteBox.deleteAt(widget.index);
     }

   }

   else{
     if(title.isNotEmpty && description.isNotEmpty){
       if(title.toString() == title_controller.text.toString() &&  description.toString() == description_controller.text.toString()){
         setState(() => dateTime=widget.date );
         print('if 0/1/1');
       }
       else{
         setState(() => dateTime=currDateTime );
         print('else 0/1/2');
       }
       await noteBox.putAt(widget.index, Note(title: title,
           description: description, dateTime: dateTime, colors:widget.colors));
       print('if 2');
     }
     else if(title.isEmpty && description.isNotEmpty){
       setState(() => dateTime=currDateTime );
       await noteBox.putAt(widget.index, Note(title: _name,
           description: description, dateTime: dateTime, colors:widget.colors));
       print('else if 2/1');
     }
     else if(title.isNotEmpty && description.isEmpty){
       setState(() => dateTime=currDateTime );
       await noteBox.putAt(widget.index, Note(title: title,
           description: '', dateTime: dateTime, colors:widget.colors));
       print('else if 2/2');
     }
     else{
       snackBar_msg = 'Empty note discarded...';
       snackBar(snackBar_msg);
       print('else 2');
       await noteBox.deleteAt(widget.index);
     }
   }
    Navigator.pop(context,[c]);
  }

  //insert new data
  submitData() async {
    if (title.isEmpty && description.isEmpty) {
      snackBar_msg = 'Empty note discarded...';
      snackBar(snackBar_msg);
    }
    else if (widget.formKey.currentState!.validate()) {
      setState((){
        dateTime=currDateTime;
      });

      if (title.isEmpty && description.isNotEmpty) {
        noteBox.add(Note(title: _name, description: description, dateTime: dateTime, colors:c));//widget.colors
      }
      else if (title.isNotEmpty && description.isEmpty) {
        noteBox.add(Note(title: title, description: '', dateTime: dateTime, colors:c));//widget.colors
      }
      else {
        noteBox.add(Note(title: title, description: description, dateTime: dateTime, colors:c));//widget.colors
      }
    }
    Navigator.pop(context,[c]);
  }

  //declare TextEditingController for card title
  late TextEditingController title_controller;

  //declare TextEditingController for card description
  late TextEditingController description_controller;


  //in this state we can get text from card title and card description
  @override
  void initState() {
    super.initState();
    title_controller = TextEditingController(
      text: widget.titles,
    );
    description_controller = TextEditingController(
      text: widget.description,
    );

    title=title_controller.text.toString();
    description=description_controller.text.toString();

  }

  //dispose both controller title_controller and  description_controller
  @override
  void dispose() {
    super.dispose();
    title_controller.dispose();
    description_controller.dispose();
  }

  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:(widget.titles=='' && widget.description=='') ? Color(c) : Color(widget.colors) ,
      body: SafeArea(
          child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: Sized_Config.widthAdjust * 2,
                      top: Sized_Config.widthAdjust * 2.5,
                      right: Sized_Config.widthAdjust * 2
                  ),

                  child: Form(
                    key: widget.formKey,
                    child: Column(
                      children: [

                        //data time
                        Center(
                          child: Text(
                            (widget.titles=='' && widget.description=='') ? 'late edited : $currDateTime' : 'late edited : ${widget.date}',
                              style: const TextStyle(
                                fontFamily: 'Cabin Sketch',
                                color: Colors.white,
                                fontWeight: FontWeight.w600
                              ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                              left: Sized_Config.widthAdjust * 2,
                          ),
                          //Write a Title for new note
                          child: TextFormField(
                            controller: (title_controller.text.isEmpty)
                                ? null
                                : title_controller,
                            style: TextStyle(
                                color: (widget.titles=='' && widget.description=='') ? const Color(0xff3f3b3b) : const Color(0xff3f3b3b),
                                fontSize: 40,
                                fontFamily: 'Ropa Sans',
                                fontWeight: FontWeight.bold
                            ),
                            decoration: InputDecoration(
                                hintText: (title_controller.text.isEmpty)
                                    ? _title_hint
                                    : title_controller.text.toString(),
                                border: InputBorder.none,
                                hintStyle: const TextStyle(
                                  color: Color(0xff3f3b3b),
                                  fontSize: 65,
                                )
                            ),
                            cursorColor: Colors.white,
                            onChanged: (value) {
                              setState(() => title = value);
                            },
                          ),
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.only(
                                left: Sized_Config.widthAdjust * 3,
                                bottom: Sized_Config.heightAdjust * 4
                            ),
                            //Write a Description for new note
                            child: TextFormField(
                              controller: (description_controller.text.isEmpty)
                                  ? null
                                  : description_controller,
                              style: TextStyle(
                                  color: (widget.titles=='' && widget.description=='') ? const Color(0xff3f3b3b) : const Color(0xff3f3b3b),
                                  fontSize: Sized_Config.txtAdjust * 3,
                                  fontFamily: 'Ropa Sans',
                                  fontWeight: FontWeight.w400
                              ),
                              decoration: InputDecoration(
                                  hintText: (description_controller.text.isEmpty)
                                      ? _description_hint
                                      : description_controller.text.toString(),
                                  border: InputBorder.none,
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff3f3b3b)
                                  )
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              cursorColor: const Color(0xffffffff),
                              onChanged: (value) {
                                setState(() => description = value);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      width: double.infinity,
                      height: Sized_Config.heightAdjust * 5,
                      decoration: BoxDecoration(
                          color:(widget.titles=='' && widget.description=='') ? Color(c) : Color(widget.colors) ,
                          border: Border.all(color: Colors.white)
                      ),
                      child: Row(
                        children: [

                          //for share data
                          Expanded(
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.only(
                                  bottom: Sized_Config.heightAdjust * 0),
                              child: Add_Callback(
                                onclicked: () {
                                  if (title_controller.text.isEmpty && description_controller.text.isEmpty){
                                    if (title.isEmpty && description.isEmpty) {
                                      snackBar_msg = 'Empty note can not Send...';
                                      snackBar(snackBar_msg);
                                    }
                                    else if (widget.formKey.currentState!.validate()) {
                                      setState(() => dateTime=currDateTime );
                                      if (title.isEmpty && description.isNotEmpty) {
                                        noteBox.add(Note(title: _name, description: description, dateTime: dateTime, colors:c));//widget.colors
                                      }
                                      else if (title.isNotEmpty && description.isEmpty) {
                                        noteBox.add(Note(title: title, description: '', dateTime: dateTime, colors:c));//widget.colors
                                      }
                                      else {
                                        noteBox.add(Note(title: title, description: description, dateTime: dateTime, colors:c));//widget.colors
                                      }
                                      data_share();
                                    }
                                  }
                                  else{
                                   data_share();
                                  }
                                },
                                color:(widget.titles=='' && widget.description=='') ? Color(c) : Color(widget.colors) ,
                                child: const Icon(Icons.share,
                                    color: Color(0xff3f3b3b)),
                              ),
                            ),
                          ),

                          //for Color
                          Center(
                            child: Row(
                              children: [
                                SizedBox(
                                  height: Sized_Config.heightAdjust * 3,
                                  width: Sized_Config.widthAdjust * 4.9,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        c = const Color(0xdbc4bfbf).value;
                                        widget.colors=const Color(0xdbc4bfbf).value;
                                      });
                                    },
                                    child: null,
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .all(const Color(0xdbc4bfbf)),
                                      shape: MaterialStateProperty.all(
                                          const CircleBorder(side: BorderSide(
                                              color: Colors.white))),
                                    ),
                                  ),
                                ),

                                SizedBox(width: Sized_Config.widthAdjust * 3),
                                SizedBox(
                                  height: Sized_Config.heightAdjust * 3,
                                  width: Sized_Config.widthAdjust * 4.9,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        c = const Color(0xffFB6868).value;
                                        widget.colors=const Color(0xffFB6868).value;
                                      });
                                    },
                                    child: null,
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .all(const Color(0xffFB6868)),
                                      shape: MaterialStateProperty.all(
                                          const CircleBorder(side: BorderSide(
                                              color: Colors.white))),
                                    ),
                                  ),
                                ),

                                SizedBox(width: Sized_Config.widthAdjust * 3),
                                SizedBox(
                                  height: Sized_Config.heightAdjust * 3,
                                  width: Sized_Config.widthAdjust * 4.9,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        c = const Color(0xff8187b9).value;
                                        widget.colors=const Color(0xff8187b9).value;
                                      });
                                    },
                                    child: null,
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .all(const Color(0xff757cb9)),
                                      shape: MaterialStateProperty.all(
                                          const CircleBorder(side: BorderSide(
                                              color: Colors.white))),
                                    ),
                                  ),
                                ),

                                SizedBox(width: Sized_Config.widthAdjust * 3),
                                SizedBox(
                                  height: Sized_Config.heightAdjust * 3,
                                  width: Sized_Config.widthAdjust * 4.9,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        c = const Color(0xff0fa3b1).value;
                                        widget.colors=const Color(0xff0fa3b1).value;
                                      });
                                    },
                                    child: null,
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all(const Color(0xff0fa3b1)),
                                        shape: MaterialStateProperty.all(
                                            const CircleBorder(side: BorderSide(
                                                color: Colors.white)))
                                    ),
                                  ),
                                ),

                                SizedBox(width: Sized_Config.widthAdjust * 3),
                                SizedBox(
                                  height: Sized_Config.heightAdjust * 3,
                                  width: Sized_Config.widthAdjust * 4.9,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        c = const Color(0xff36a690).value;
                                        widget.colors=const Color(0xff36a690).value;
                                      });
                                    },
                                    child: null,
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .all(const Color(0xff36a690)),
                                      shape: MaterialStateProperty.all(
                                          const CircleBorder(side: BorderSide(
                                              color: Colors.white))),
                                    ),
                                  ),
                                ),

                                SizedBox(width: Sized_Config.widthAdjust * 3),
                                SizedBox(
                                  height: Sized_Config.heightAdjust * 3,
                                  width: Sized_Config.widthAdjust * 4.9,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        c = const Color(0xffd9a87c).value;
                                        widget.colors=const Color(0xffd9a87c).value;
                                      });
                                    },
                                    child: null,
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all(const Color(0xffd9a87c)),
                                        shape: MaterialStateProperty.all(
                                            const CircleBorder(side: BorderSide(
                                                color: Colors.white)))
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //for save
                          Expanded(
                            child: Container(
                              alignment: Alignment.bottomRight,
                              padding: EdgeInsets.only(
                                  bottom: Sized_Config.heightAdjust * 0),
                              child: Add_Callback(
                                color:(widget.titles=='' && widget.description=='') ? Color(c) : Color(widget.colors),
                                onclicked: () {
                                  print('titles=${widget.titles==''}');
                                  print('color=${Color(c)}');
                                  print('descriptions=${widget.description==''}');
                                  (widget.titles=='' && widget.description=='') ? submitData() : updateData();
                                },
                                child: const Icon(Icons.check,
                                    color: Color(0xff3f3b3b)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                )
              ]
          )
      ),
    );
  }

  //for snack bar
  snackBar(msg) {
    final snackbar = SnackBar(
      content: Text(
          msg.toString(),
          style: const TextStyle(color: Color(0xff8d8a8a), fontSize: 16)),
      action: SnackBarAction(
        onPressed: () {},
        label: '',
        textColor: Colors.grey,
      ),
      backgroundColor: const Color(0xff262525),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  //data share function
 data_share() async {
    if (title.isNotEmpty && description.isNotEmpty) {
      await Share.share('Title\n\t\t${title.toString()} \n\n- Content\n\t\t${description.toString()}');
    }
    else if(title.isEmpty && description.isNotEmpty) {
      await Share.share('- Content\n\t\t${description.toString()}');
    }
    else if(title.isNotEmpty && description.isEmpty) {
      await Share.share('- Title\n\t\t${title.toString()}');
    }
    else{
      snackBar_msg = 'Empty note can not Share...';
      snackBar(snackBar_msg);
    }
 }

}
