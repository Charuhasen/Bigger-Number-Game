import 'package:bigger_number_game/screens/app_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Reference Box (DB)
  final _myBox = Hive.box('userdata');

  int highScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BNG"),
        leading: const Icon(Icons.calculate_rounded),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              color: Colors.deepPurple[100],
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                  child: Text(
                    "Highscore: $highScore",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Select the largest number.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await Get.to(() => const AppPage());
                        setState(() {
                          readData();
                        });
                      },
                      child: const Text("START"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  void readData() {
      highScore = _myBox.get("HighScore") ?? 0;
  }
}
