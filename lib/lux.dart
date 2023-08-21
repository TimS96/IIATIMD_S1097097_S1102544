import 'package:flutter/material.dart';
import 'dart:async';
import 'package:light/light.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculateLux extends StatefulWidget {
  const CalculateLux({super.key});

  @override
  _CalculateLuxState createState() => _CalculateLuxState();
}

class _CalculateLuxState extends State<CalculateLux> {
  String luxString = 'Unknown';
  String SavedLuxString = "Begin met meten";
  Light? light;
  StreamSubscription? subscription;
  SharedPreferences? prefs;

  void onData(int luxValue) async {
    setState(() {
      luxString = "$luxValue";
    });
  }

  void stopListening() {
    subscription?.cancel();
  }

  void startListening() {
    light = Light();
    try {
      subscription = light?.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      print(exception);
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      SavedLuxString = prefs?.getString("SavedLuxString") ?? "";
    });
  }

  bool test = true;

  void startMeasurement() {
    startListening();
    setState(() {
      test = !test;
    });
  }

  void stopMeasurement() {
    setState(() {
      SavedLuxString = luxString;
      prefs?.setString('SavedLuxString', luxString);
    });
    stopListening();
    setState(() {
      test = !test;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Light Example App'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Lux value: $luxString\n'),
              Text('Laatste meting: $SavedLuxString\n'),
              (test == true
                  ? ElevatedButton(
                      onPressed: () {
                        startMeasurement();
                      },
                      child: const Text('Begin met meten!'),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        stopMeasurement();
                      },
                      child: const Text('meten!'),
                    )),
            ]),
      ),
    );
  }
}
