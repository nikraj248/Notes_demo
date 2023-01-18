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

