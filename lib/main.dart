import 'package:assignment_tracker/auth/services.dart';
import 'package:assignment_tracker/screens/home.dart';
import 'package:assignment_tracker/screens/signIn.dart';
import 'package:assignment_tracker/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static int focusPeriod = 0;
  static bool isWaiting = false;
  static bool isAdding = false;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment Tracker',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        accentColor: Colors.green[600],
        primarySwatch: Colors.red,

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          subtitle1: TextStyle(fontSize: 18.0),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hindi'),
        ),
      ),
      home: Builder(builder: (BuildContext context) {
        Shared.init(context);
        return StreamBuilder<Object>(
          stream: AuthService.auth.idTokenChanges(),
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Assignment Tracker"),
                actions: [
                  snapshot.hasData
                      ? ElevatedButton.icon(
                          onPressed: () => {AuthService.signOut()},
                          icon: Icon(Icons.person),
                          label: Text("Log out"))
                      : Container()
                ],
              ),
              body: MyApp.isWaiting
                  ? Center(child: CircularProgressIndicator())
                  : snapshot.hasData
                      ? GestureDetector(
                          onTap: FocusScope.of(context).unfocus,
                          child: Home(),
                        )
                      : SignIn(),
            );
          },
        );
      }),
    );
  }
}
