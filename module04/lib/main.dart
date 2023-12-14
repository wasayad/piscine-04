import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:module04/routes/event/event_page.dart';
import 'firebase_options.dart';
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<UserCredential> signInWithGoogle() async {
    return await FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            FirebaseAuth.instance
                .authStateChanges()
                .listen((User? user) async {
              if (user == null) {
                await signInWithGoogle();
              }
            });
            FirebaseAuth.instance
                .authStateChanges()
                .listen((User? user) {
              if (!(user == null)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  EventPage()),
                );
              }
            });
          },
          child: const Text("Sign in with Google"),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
