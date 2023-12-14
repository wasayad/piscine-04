import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    Map<String, dynamic> push = obj.data();
    push['id'] = obj.id;
    ret.add(push);
  }
  setState(ret);
}

class _DiaryState extends State<Diary> {
  var formKey = GlobalKey<FormState>();
  FeelingIcon icons = FeelingIcon();
  EventModel eventModel = EventModel();

  void setFeeling(num feeling) {
    eventModel.feeling = feeling;
  }

  Widget buildPopupDialogEvent(
      BuildContext context, Map<String, dynamic> event) {
    FeelingIcon icon = FeelingIcon();
    return AlertDialog(
      alignment: Alignment.topCenter,
      title:  Center(child: Text(event['title'], style: const TextStyle(fontSize: 40),)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Text(DateFormat('dd').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        event['date'].seconds * 1000)), style: const TextStyle(fontSize: 20),),
                Text(DateFormat('MMM').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        event['date'].seconds * 1000)), style: const TextStyle(fontSize: 25),),
                Text(DateFormat('yyyy').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        event['date'].seconds * 1000)), style: const TextStyle(fontSize: 30),),
              ],
            ),
            Text(event['email']),
            Icon(icon.icons[event['feeling']], color: icon.color[event['feeling']], size: 50,),
            Container(
                padding: const EdgeInsets.all(5),
                decoration:  BoxDecoration(
                border: Border.all(width: 2, color: Colors.amber),
                ),child: Text(event['content'], style: const TextStyle(fontSize: 20),)),
            ElevatedButton(
                child: const Text('DELETE'),
                onPressed: () {
                  FirebaseFirestore db = FirebaseFirestore.instance;
                  Navigator.of(context, rootNavigator: true).pop();
                  db.collection('event').doc(event['id']).delete();
                  updateEvents(widget.onEventsChange);
                }),
          ],
        ),
      ),
    );
  }

  List<Widget> getEvents(List<dynamic> data) {
    List<Widget> ret = [];
    FeelingIcon icons = FeelingIcon();
    var now = DateTime.now();
    var formatter = DateFormat('dd-MMM-yyyy');
    String formattedTime = DateFormat('kk:mm:a').format(now);
    for (var event in data) {
      ret.add(InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) =>
                  buildPopupDialogEvent(context, event),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blueGrey,
            ),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Text(DateFormat('dd').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            event['date'].seconds * 1000)), style: const TextStyle(fontSize: 20),),
                    Text(DateFormat('MMM').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            event['date'].seconds * 1000)), style: const TextStyle(fontSize: 25),),
                    Text(DateFormat('yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            event['date'].seconds * 1000)), style: const TextStyle(fontSize: 30),),
                  ],
                )),
                Expanded(child: Text(event['title'], style: const TextStyle(fontSize: 40, color: Colors.amber))),
                Expanded(child: Icon(icons.icons[event['feeling']], color: icons.color[event['feeling']], size: 50)),
              ],
            ),
          )));
    }
    return ret;
  }

  Widget buildPopupDialog(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topCenter,
      title: const Center(child: Text('Create event')),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              InputDatePickerFormField(
                  firstDate: DateTime.now(),
                  lastDate: DateTime(1923399567),
                  onDateSubmitted: (date) => {eventModel.date = date},
                  onDateSaved: (date) => {eventModel.date = date}),
              TextFormField(
                decoration: const InputDecoration(hintText: "title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  eventModel.title = value;
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "content"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  eventModel.content = value;
                  return null;
                },
              ),
              Row(
                children: icons.icons
                    .map((e) => Expanded(
                        child: IconButton(
                            onPressed: () => setFeeling(icons.icons.indexOf(e)),
                            icon: Icon(e, color: icons.color[icons.icons.indexOf(e)], size: 50))))
                    .toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    formKey.currentState!.save();
                    FirebaseFirestore db = FirebaseFirestore.instance;
                    Navigator.of(context, rootNavigator: true).pop();
                    db.collection('event').add(eventModel.toJson());
                    updateEvents(widget.onEventsChange);
                  }
                },
                child: const Text('ADD EVENT'),
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
      return Center(
          child: SingleChildScrollView(
          child: Column(
        children: [
          Column(children: getEvents(widget.object)),
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
              style: const ButtonStyle()),
        ],
        //getEvents(widget.object, widget.onEventsChange),
      )));
    }());
  }
}
