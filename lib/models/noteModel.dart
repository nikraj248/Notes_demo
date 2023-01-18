import 'package:flutter/material.dart';

class Note{
   int? _id;
   String? _title;
   String? _description;
   String? _date;

  Note(this._title,this._description,this._date);

   Note.withId(this._id,this._title,this._description,this._date);


  int get id => _id ?? 0;

  set id(int value) {
    _id = value;
  }

  String get date => _date!;

  set date(String value) {
    _date = value;
  }

  String get description => _description!;

  set description(String value) {
    _description = value;
  }

  String get title => _title!;

  set title(String value) {
    _title = value;
  }

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    if(_id!=null){
      map['id']=_id;
    }
    map['title']=_title;
    map['description']=_description;
    map['date']=_date;
    return map;
  }

  Note.fromMapObject(Map<String,dynamic> map){
    _id=map['id'];
    _title=map['title'];
    _description=map['description'];
    this._date=map['date'];
  }

}