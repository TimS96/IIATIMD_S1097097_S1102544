import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FillDataWidget extends StatefulWidget {
  @override
  _FillDataWidgetState createState() => _FillDataWidgetState();
}

class _FillDataWidgetState extends State<FillDataWidget> {
  String skinType = '';
  String sunScreenFactor = '';

  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      skinType = prefs?.getString("Huidtype") ?? "";
      sunScreenFactor = prefs?.getString("ZonnebrandFactor") ?? "";
    });
  }

  void saveData(String value, String key) async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs?.setString(key, value);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double topMargin = MediaQuery.of(context).size.width > 600 ? 32.0 : 16.0;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text('vul in'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background4.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (!isLandscape)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: topMargin),
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Huidtype',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^[1-6]$')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            skinType = value;
                            saveData(value, 'Huidtype');
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Zonnebrand factor',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _MaxInputFormatter(50),
                      ],
                      onChanged: (value) {
                        setState(() {
                          sunScreenFactor = value;
                          saveData(value, 'ZonnebrandFactor');
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Container(
                    margin: EdgeInsets.only(top: topMargin),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                      child: Column(
                        children: [
                          Text('Huidtype: $skinType',
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.white)),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                                'Weet je je huidtype niet? Draai je scherm!',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          ),
                          Text('Zonnebrand factor: $sunScreenFactor',
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Opslaan!'),
                ),
              ],
            ),
          if (isLandscape)
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/huidtype.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MaxInputFormatter extends TextInputFormatter {
  final int maxValue;

  _MaxInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    if (int.tryParse(newValue.text) != null) {
      final intValue = int.parse(newValue.text);
      if (intValue <= maxValue) {
        return newValue;
      }
    }
    return oldValue;
  }
}
