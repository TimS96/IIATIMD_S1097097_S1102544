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
  String luxString = 'geen';
  String savedLuxString = "Begin met meten";
  String savedSunStrenghtString = "Begin met meten";
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
      savedLuxString = prefs?.getString("SavedLuxString") ?? "";
      savedSunStrenghtString = prefs?.getString("SavedSunStrenghtString") ?? "";
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
      savedLuxString = luxString;
      prefs?.setString(
          'SavedSunStrenghtString', calculateSunStrenght().toString());
      prefs?.setString('SavedLuxString', luxString);
    });
    stopListening();
    setState(() {
      test = !test;
      savedSunStrenghtString = prefs?.getString("SavedSunStrenghtString") ?? "";
    });
  }

  //op een bewolke dag is zonne sterken 1000 lux, direct zonlicht gaat van 30.000 tot 130.000
  //Na meten in direct zonlicht lijk het ook echt tot 130.000 tegaan
  //We reken dus 13000 lux gaat de zonkracht met 1 omhoog
  calculateSunStrenght() {
    int sunStrenghtDenominator = 13000;
    double savedLuxStrenght = double.parse(luxString);
    double sunStrenght = 1;

    if (savedLuxStrenght > sunStrenghtDenominator) {
      sunStrenght = savedLuxStrenght / sunStrenghtDenominator;
    }
    return sunStrenght.toInt();
  }

  @override
  Widget build(BuildContext context) {
    double topMargin = MediaQuery.of(context).size.width > 600 ? 128.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meet zonnesterkte'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/background2.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FractionallySizedBox(
                widthFactor: 0.8, // Adjust the width as needed
                child: Container(
                  margin: EdgeInsets.only(top: topMargin),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Huidige lux waarde: $luxString\n',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Text(
                        'Laatste lux meting: $savedLuxString\n',
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      Text('Zonne sterkte: $savedSunStrenghtString\n',
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
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
      ),
    );
  }
}
