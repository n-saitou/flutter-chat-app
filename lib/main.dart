import 'package:chat_app/pages/top_page.dart';
import 'package:chat_app/utils/firebase.dart';
import 'package:chat_app/utils/shared_prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await checkAccount();
  runApp(const MyApp());
}

Future<void> checkAccount() async{
  String uid = await SharedPrefs.getUid();
  if (uid.isEmpty) {
    Firestore.addUser();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TopPage(),
    );
  }
}

