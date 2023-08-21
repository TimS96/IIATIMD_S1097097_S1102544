import 'package:flutter/material.dart';
import 'package:iatimd_uv_app/lux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fill_data.dart'; // Import the FillDataWidget

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String skinType = 'vul nog even in.';
  String sunScreenFactor = 'vul nog even in.';
  String sunStrenght = 'Meet nog op!';
  String advice = 'Vul alle data in voor advies';

  setAdvice() {
    if (skinType.length < 5 &&
        sunScreenFactor.length < 5 &&
        sunStrenght.length < 10 &&
        sunScreenFactor != "0") {
      int skinTypeNumber = int.parse(skinType);
      int sunScreenFactorNumber = int.parse(sunScreenFactor);
      int sunStrenghtNumber = int.parse(sunStrenght);
      int skinTypeNumberCalculated = 60;

      switch (skinTypeNumber) {
        case 1:
          skinTypeNumberCalculated = 60;
          break;
        case 2:
          skinTypeNumberCalculated = 100;
          break;
        case 3:
          skinTypeNumberCalculated = 200;
          break;
        case > 3:
          skinTypeNumberCalculated = 300;
          break;
        default:
          skinTypeNumberCalculated = 60;
      }

      return (skinTypeNumberCalculated /
              sunStrenghtNumber *
              sunScreenFactorNumber)
          .toString();
    }
    return "Vul alle data in voor advies";
  }

  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    loadData();
    setAdvice();
  }

  void saveData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs?.setString('Advice', setAdvice());
    });
  }

  void loadData() async {
    prefs = await SharedPreferences.getInstance();
    saveData();
    setState(() {
      skinType = prefs?.getString("Huidtype") ?? "";
      sunScreenFactor = prefs?.getString("ZonnebrandFactor") ?? "";
      sunStrenght = prefs?.getString("SavedSunStrenghtString") ?? "";
      advice = prefs?.getString("Advice") ?? "";
      advice = setAdvice();
    });
  }

  _navigateToFillData() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FillDataWidget(),
      ),
    );
    loadData();
    saveData();
  }

  _navigateToSunStrenght() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CalculateLux(),
      ),
    );
    loadData();
    saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zonne app!')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Huidtype: $skinType\n', style: TextStyle(fontSize: 24)),
            Text('Zonnebrand factor: $sunScreenFactor\n',
                style: TextStyle(fontSize: 24)),
            ElevatedButton(
              child: const Text('Vul in!'),
              onPressed: () {
                _navigateToFillData().then((_) {
                  loadData();
                  saveData();
                });
              },
            ),
            Text('Zonnesterkte: $sunStrenght\n',
                style: TextStyle(fontSize: 24)),
            ElevatedButton(
              child: const Text('Vul in!'),
              onPressed: () {
                _navigateToSunStrenght().then((_) {
                  loadData();
                  saveData();
                });
              },
            ),
            (advice.length < 10
                ? Text('Advies: maximaal $advice\n minuten in de zon!',
                    style: TextStyle(fontSize: 24))
                : Text(advice, style: TextStyle(fontSize: 24))),
          ],
        ),
      ),
    );
  }
}
