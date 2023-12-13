import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:module04/components/utils/eventModel.dart';
import 'package:module04/components/utils/feelingIcon.dart';

class Diary extends StatefulWidget {
  Diary({required this.onEventsChange, required this.object, super.key});
  final List<dynamic> object;
  final ValueChanged<List<dynamic>> onEventsChange;

  @override
  State<Diary> createState() => _DiaryState();
}

Future<void> updateEvents(ValueChanged<List<dynamic>> setState) async {
  List<dynamic> body = [];
  List<dynamic> ret = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> query = db.collection("event");
  var response = await query.get();
  body = response.docs;
  for (var obj in body) {
    ret.add(obj.data());
  }
  setState(ret);
}

List<Widget> getEvents(List<dynamic> data) {
  List<Widget> ret = [];
  FeelingIcon icons = FeelingIcon();
  var now = DateTime.now();
  var formatter = DateFormat('dd-MM-yyyy');
  String formattedTime = DateFormat('kk:mm:a').format(now);
  for (var event in data) {
    ret.add(Row(
      children: [
        Column(
          children: [
            Text(DateFormat('dd').format(DateTime.fromMicrosecondsSinceEpoch(
                event['date'].seconds * 1000))),
            Text(DateFormat('MM').format(DateTime.fromMicrosecondsSinceEpoch(
                event['date'].seconds * 1000))),
            Text(DateFormat('yyyy').format(DateTime.fromMicrosecondsSinceEpoch(
                event['date'].seconds * 1000))),
          ],
        ),
        Icon(icons.icons[event['feeling']]),
        Text(event['title']),
      ],
    ));
  }
  return ret;
}

class _DiaryState extends State<Diary> {
  var formKey = GlobalKey<FormState>();
  FeelingIcon icons = FeelingIcon();
  EventModel eventModel = EventModel();


  void setFeeling(num feeling) {
    eventModel.feeling = feeling;
  }

  Widget buildPopupDialog(BuildContext context) {

    return AlertDialog(
      alignment: Alignment.topCenter,
      title: const Text('Popup example'),
      content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                InputDatePickerFormField(firstDate: DateTime.now(), lastDate: DateTime(1923399567),
                onDateSubmitted: (date) => {
                  eventModel.date = date.microsecondsSinceEpoch as Timestamp
                }),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: "email"
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {

                      return 'Please enter some text';
                    }
                    eventModel.email = value;
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: "title"
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    eventModel.title = value;
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: "content"
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    eventModel.content = value;
                    return null;
                  },
                ),
                Row(children: (() {
                  List<Widget> ret = [];
                  num i = 1;
                  for (var icon in icons.icons) {
                    ret.add(Expanded(child: IconButton(onPressed: () => setFeeling(i),icon: Icon(icon),)));
                    i++;
                  }
                  return ret;
                } ())
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      FirebaseFirestore db = FirebaseFirestore.instance;
                      db.collection('event').add(data)
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (() {
      print("Here");
      return Center(
          child: Column(
        children: [
          SingleChildScrollView(
              child: Column(children: getEvents(widget.object))),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => buildPopupDialog(context),
                );
              },
              icon: const Icon(
                Icons.add,
                size: 50,
              ),
              color: Colors.blue,
              style: ButtonStyle()),
        ],
        //getEvents(widget.object, widget.onEventsChange),
      ));
    }());
  }
}
