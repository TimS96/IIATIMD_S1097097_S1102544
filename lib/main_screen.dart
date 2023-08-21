import 'package:flutter/material.dart';
import 'package:iatimd_uv_app/lux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fill_data.dart'; // Import the FillDataWidget

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String skinType = 'Klik op de knop om in te vullen';
  String sunScreenFactor = 'Klik op de knop om in te vullen';
  String sunStrenght = 'Klik op de knop om te meten';
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Huidtype: $skinType\n',
                            style: const TextStyle(fontSize: 24)),
                        Text('Zonnebrand factor: $sunScreenFactor\n',
                            style: const TextStyle(fontSize: 24)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          child: const Text('Wijzig waardes'),
                          onPressed: () {
                            _navigateToFillData().then((_) {
                              loadData();
                              saveData();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text('Zonnesterkte: $sunStrenght\n',
                  style: const TextStyle(fontSize: 24)),
              ElevatedButton(
                child: const Text('Meet zonnesterkte'),
                onPressed: () {
                  _navigateToSunStrenght().then((_) {
                    loadData();
                    saveData();
                  });
                },
              ),
              Container(
                height: MediaQuery.of(context)
                    .size
                    .height, // Make the container take all available height
                child: Center(
                  child: advice.length < 10
                      ? Text('Advies: maximaal $advice\n minuten in de zon!',
                          style: const TextStyle(fontSize: 24))
                      : Text(advice, style: const TextStyle(fontSize: 24)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
