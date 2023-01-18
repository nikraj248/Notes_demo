import 'package:flutter/material.dart';
import 'package:notes_demo/pages/note_desc.dart';
import 'package:notes_demo/pages/notes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "UserNotes",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: const NotesList(),
      // home: const NoteDetail(),
    );
  }
}


// StaggeredGridView.countBuilder(
// crossAxisCount: 2,
// crossAxisSpacing: 10,
// mainAxisSpacing: 12,
// itemCount: 50,
// itemBuilder: (context, index) {
// return index.isEven?Text("helloworStaggeredTile.fit(2)StaggeredTile.fit(2)StaggeredTile.fit(2)StaggeredTile.fit(2)ld",style: TextStyle(color: Colors.deepOrange,backgroundColor: Colors.blue),):Text("This video shows how to create a staggered gridview in a flutter and shows how to staggered gridview will work when using the flutter_staggered_grid_view package, and then they will be shown on your device.");
// }, //staggeredTileBuilder: (int index) { StaggeredTile.fit(2); },
// staggeredTileBuilder: (index) {
// return StaggeredTile.fit(1);
// }
// ),

