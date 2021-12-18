import 'package:flutter/material.dart';
import 'package:initiative_tracker/share_prefs/user_preferences.dart';
import 'package:initiative_tracker/widgets/menu_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const String routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _secondaryColor;
  late String _gender;
  late String _name;

  late TextEditingController _textController;

  final prefs = UserPreferences();
  @override
  void initState() {
    super.initState();
    _name = prefs.name;
    _gender = prefs.gender;
    _secondaryColor = prefs.secondaryColor;

    _textController = TextEditingController(text: _name);
  }

  _setSelectedRadio(String? value) async {
    prefs.gender = value as String;
    setState(() {
      _gender = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: const Center(child: Text('Settings')),
          backgroundColor: (prefs.secondaryColor) ? Colors.teal : Colors.blue,
          elevation: 0,
        ),
        drawer: const MenuWidget(),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Settings',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('color Secundario'),
              value: _secondaryColor,
              onChanged: (bool value) {
                setState(() {
                  _secondaryColor = value;
                  prefs.secondaryColor = value;
                });
              },
            ),
            const Divider(),
            RadioListTile(
              title: const Text('Masculino'),
              value: 'M',
              groupValue: _gender,
              onChanged: _setSelectedRadio,
            ),
            RadioListTile(
              title: const Text('Femenino'),
              value: 'F',
              groupValue: _gender,
              onChanged: _setSelectedRadio,
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  //  border: OutlineInputBorder(),
                  labelText: 'name',
                  helperText: 'name de la persona',
                ),
                onChanged: (value) => {
                  prefs.name = value,
                  setState(() {
                    _name = value;
                  })
                },
              ),
            )
          ],
        ));
  }
}
