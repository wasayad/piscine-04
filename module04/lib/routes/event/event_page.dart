import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/appBar.dart';
import '../../components/diary.dart';
import '../../components/bottomBar.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => EventPageState();
}

Future<List<dynamic>> getEvents() async {
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
  return ret;
}

class EventPageState extends State<EventPage> {
  final Future<List<dynamic>>? events = Future<List<dynamic>>.delayed(
    const Duration(seconds: 2),
    getEvents,
  );

  void onEventsChange(List<dynamic> events) {
    setState(() {
      eventState = events;
    });
  }

  List<dynamic> eventState = [];

  @override
  Widget build(BuildContext context) {
    List<dynamic> eventsState;
    print("_____________________");
    print(events);
    return SizedBox(
        child: FutureBuilder<List<dynamic>>(
            future: events, // a previously-obtained Future<Weather> or null
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              List<Widget> children;
              return SizedBox(
                  child: Center(
                child: DefaultTabController(
                    initialIndex: 0,
                    length: 2,
                    child: Scaffold(
                      appBar: const AppBarComponent(),
                      body: (() {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          if (eventState.length == 0) {
                            eventState = snapshot.data!;
                          }
                          return TabBarView(children: <Widget>[
                            Diary(
                                object: eventState,
                                onEventsChange: onEventsChange),
                            const Text("TEST"),
                          ]);
                        } else {
                          return const Center(
                              child: SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(),
                          ));
                        }
                      }()),
                      bottomNavigationBar: const BottomBar(),
                    )),
              ));
            }));
  }
}
