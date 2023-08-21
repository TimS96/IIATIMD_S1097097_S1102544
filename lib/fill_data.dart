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
    _loadData();
  }

  void _loadData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      skinType = prefs?.getString("Huidtype") ?? "";
      sunScreenFactor = prefs?.getString("ZonnebrandFactor") ?? "";
    });
  }

  void _saveData(String value, String key) async {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('vul in'),
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Huidtype'),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[1-6]$')),
            ],
            onChanged: (value) {
              setState(() {
                skinType = value;
                _saveData(value, 'Huidtype');
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Zonnebrand factor'),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _MaxInputFormatter(50),
            ],
            onChanged: (value) {
              setState(() {
                sunScreenFactor = value;
                _saveData(value, 'ZonnebrandFactor');
              });
            },
          ),
          SizedBox(height: 20),
          Text('Huidtype: $skinType'),
          Text('Zonnebrand factor: $sunScreenFactor'),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Opslaan!'),
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
