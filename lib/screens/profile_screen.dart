import 'package:flutter/material.dart';
import 'package:initiative_tracker/share_prefs/user_preferences.dart';
import 'package:initiative_tracker/widgets/menu_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();
    return Scaffold(
        // backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: const Center(child: Text('TEST')),
          backgroundColor: (prefs.secondaryColor) ? Colors.teal : Colors.blue,
          elevation: 0,
        ),
        drawer: const MenuWidget(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Nombre: ${prefs.name}'),
              const Divider(),
              Text('Clase: ${prefs.gender}'),
              const Divider(),
              const Text('ETC:EZ'),
              const Divider(),
            ],
          ),
        ));
  }
}
