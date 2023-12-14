import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  EventModel();
  String email = "";
  DateTime? date;
  String title = "";
  String content = "";
  num? feeling;

  Map<String, dynamic> toJson()
  {
    Map<String, dynamic> ret = {};
    ret['email'] = email;
    ret['date'] = date;
    ret['title'] = title;
    ret['content'] = content;
    ret['date'] = date;
    ret['feeling'] = feeling;
    return ret;
  }
}