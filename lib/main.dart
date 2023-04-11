import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_page.dart';

void main() async {

  //initialize HIVE
  await Hive.initFlutter();

  //open the box(DB)
  var box = await Hive.openBox("userdata");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Raleway',
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}
