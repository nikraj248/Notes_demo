import 'package:flutter/material.dart';
import 'package:notes_demo/pages/note_desc.dart';
import 'dart:async';
import 'package:notes_demo/models/noteModel.dart';
import 'package:notes_demo/utils/database_helper.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotesList extends StatefulWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note>? noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = <Note>[];
      updateListView();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("UserNotes"),
          centerTitle: true,
        ),
        body: StaggeredGridView.countBuilder(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
            itemCount: noteList!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: Card(
                    elevation: 20,

                    color: Colors.white70, //Color(0xff252525),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        //maxLines: 1,overflow: TextOverflow.ellipsis,
                        Text(
                          noteList![index].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: Colors.black),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          noteList![index].date,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: Colors.black54),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              noteList![index].description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.black87),
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    )),
                  ),
                ),
                onTap: () {
                  goToEditPage(noteList![index], 'Edit Note');
                },
                onDoubleTap: () {
                  _delete(context, noteList![index]);
                },
              );
            },
            staggeredTileBuilder: (index) {
              return StaggeredTile.fit(1);
            }),

        // body: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     const SizedBox(height: 5,),
        //     const Text("Single Tap to Update"),
        //     const Text("Double Tap to Delete"),
        //     const SizedBox(height: 5,),
        //
        //     Expanded(
        //       child: GridView.builder(
        //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        //
        //           itemCount: noteList!.length,
        //
        //           itemBuilder: (context, index) {
        //             return GestureDetector(
        //                 child: Container(
        //                   //margin: const EdgeInsets.all(10),
        //                   decoration: BoxDecoration(
        //                     color: Colors.black87,
        //                   ),
        //
        //                   // width: 160,
        //                   // height: 250,
        //                   child: Card(
        //                     //elevation: 20,
        //
        //                     color: Colors.white70, //Color(0xff252525),
        //
        //                     shape: RoundedRectangleBorder(
        //                       borderRadius: BorderRadius.circular(20),
        //
        //                     ),
        //                     child: SingleChildScrollView(
        //                       child: Container(
        //
        //                         //alignment: Alignment.center,
        //                         margin: EdgeInsets.all(5),
        //                         child: Column(
        //
        //                           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                           children: <Widget>[
        //                             //maxLines: 1,overflow: TextOverflow.ellipsis,
        //                             Text(noteList![index].title,textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.black),maxLines: 3,overflow: TextOverflow.ellipsis,),
        //                             const SizedBox(height: 5,),
        //                             Text(noteList![index].date,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 10,color: Colors.black54),),
        //                             const SizedBox(height: 20,),
        //                             Container(padding: EdgeInsets.all(5),child: Text(noteList![index].description,textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 14,color: Colors.black87),maxLines: 10,overflow: TextOverflow.ellipsis,)),
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //
        //               ),
        //               onTap: (){
        //                 goToEditPage(noteList![index],'Edit Note');
        //               },
        //               onDoubleTap: (){
        //                 _delete(context, noteList![index]);
        //               },
        //             );
        //           }),
        //     ),
        //   ],
        // ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add",
          child: const Icon(Icons.add),
          onPressed: () {
            goToEditPage(Note('', '', ''), "Add Note");
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void goToEditPage(Note note, String appBarTitle) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(
        note: note,
        appBarTitle: appBarTitle,
      );
    }));
    if (result == true) {
      updateListView();
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
