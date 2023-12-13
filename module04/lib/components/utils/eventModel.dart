import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  EventModel();
  String email = "";
  Timestamp? date;
  String title = "";
  String content = "";
  num? feeling;
}