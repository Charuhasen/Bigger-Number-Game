import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  //Reference Box
  final _myBox = Hive.box('userdata');

  int score = 0;
  int timeLeft = 8;
  Timer? timer;
  int triesLeft = 3;
  Set<int> setOfInts = {};
  List<int> list = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("BNG"),
          leading: IconButton(
              onPressed: () {
                _stopTimer();
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new)),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Score: ${(score)}",
                        style: const TextStyle(fontSize: 40),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.timer_sharp),
                          Text(
                            "${timeLeft}s",
                            style: const TextStyle(fontSize: 40),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Text("Tries Left: ${(triesLeft)}",
                style: const TextStyle(fontSize: 30)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 8,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                checkIfHighestInt(index);
                                randomNumberGenerator();
                              });
                            },
                            child: Text(setOfInts.elementAt(index).toString()),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    randomNumberGenerator();
    _startTimer();
  }

  void randomNumberGenerator() {
    setOfInts.clear();
    list.clear();
    while (setOfInts.length < 8) {
      setOfInts.add(Random().nextInt(30));
    }
    list = setOfInts.toList();
    list.sort();
  }

  //Countdown timer
  void _startTimer() {
    timeLeft = upIntensity();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (triesLeft > 0) {
        if (timeLeft > 0) {
          setState(() {
            timeLeft--;
          });
        } else {
          setState(() {
            HapticFeedback.vibrate();
            showToastMessage("NO SELECTION", Colors.yellow);
            triesLeft = max(triesLeft - 1, 0);
            _stopTimer();
            randomNumberGenerator();
            _startTimer();
          });
        }
      } else {
        _stopTimer();
        writeData();
        Get.back();
      }
    });
  }

  void _stopTimer() {
    timer?.cancel();
  }

  void _onCorrectSelection() {
    showToastMessage("Correct", Colors.green);
    score += 1;
    _stopTimer();
    _startTimer();
  }

  void _onWrongSelection() {
    HapticFeedback.vibrate();
    showToastMessage("Incorrect", Colors.red);
    triesLeft = max(triesLeft - 1, 0);
    score = max(score - 1, 0);
    _stopTimer();
    _startTimer();
  }

  int upIntensity() {
    int seconds = 8;
    if (score > 10) {
      seconds = 5;
    } if (score > 20) {
      seconds = 3;
    }
    return seconds;
  }

  void writeData() {
    if (score > _myBox.get("HighScore")) {
      _myBox.put("HighScore", score);
    }
  }

  void showToastMessage(String message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void checkIfHighestInt(int index) {
    if (setOfInts.elementAt(index) == list.last) {
      _onCorrectSelection();
    } else {
      _onWrongSelection();
    }
  }
}
