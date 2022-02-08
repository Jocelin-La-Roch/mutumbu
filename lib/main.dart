import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mutumbu/provider/AudioProvider.dart';
import 'package:mutumbu/views/pages/MainPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.openBox("mutumbuBox");
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=>AudioProvider()),
        ],
        child: MyApp(),
      )
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mutumbu',
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
