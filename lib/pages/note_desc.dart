import 'package:flutter/material.dart';
import 'package:notes_demo/models/noteModel.dart';
import 'package:notes_demo/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {

  final String appBarTitle;
  final Note note;

  const NoteDetail({Key? key,required this.note,required this.appBarTitle}) : super(key: key);


  @override
  State<NoteDetail> createState() => _NoteDetailState(this.note,this.appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {

  String appBarTitle;
  Note note;
  _NoteDetailState(this.note,this.appBarTitle);

  DatabaseHelper helper=DatabaseHelper();

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    titleController.text=note.title;
    descController.text=note.description;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
          moveToLastScreen();
        },),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ListTile(
            //   title: DropdownButton(
            //     items: _priorities.map((String dropDownStringItem){
            //       return DropdownMenuItem<String>(
            //         value: dropDownStringItem,
            //         child: Text(dropDownStringItem),
            //       );
            //     }).toList(),
            //     value: getPriorityAsString(note.priority),
            //     onChanged: (valueSelectedByUser){
            //       setState(() {
            //         updatePriorityAsInt(valueSelectedByUser!);
            //
            //       });
            //     },
            //   ),
            // ),
            TextField(
              controller: titleController,
              onChanged: (value){
                updateTitle();
              },
              decoration: InputDecoration(
                labelText: "TITLE",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4)
                )
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: descController,
              onChanged: (value){
                updateDescription();
              },
              decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4)
                  )
              ),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(onPressed: (){
                  _save();
                }, child: Text("SAVE"),
                style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),),

                const SizedBox(width: 20,),

                ElevatedButton(onPressed: (){
                  _delete();
                }, child: Text("DELETE"),
                  style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),),
              ],
            )
          ],
        ),
      ),
    );
  }
  void moveToLastScreen(){
    Navigator.pop(context,true);
  }


  void updateTitle(){
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descController.text;
  }

  void _save() async {

    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != 0) {  // Case 1: Update operation
      //print('hhhh');
      result = await helper.updateNote(note);
    } else { // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    // debugPrint(note.id.toString());
    // debugPrint(result.toString());
    // print(note.id);
    // print(result);


    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }

  }

  void _delete() async {

    moveToLastScreen();

    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }


    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }


}
