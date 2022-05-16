import 'package:flutter/material.dart';
import 'package:initiative_tracker/screens/screens.dart';
import 'package:initiative_tracker/services/mode_service.dart';
import 'package:initiative_tracker/services/services.dart';
import 'package:provider/provider.dart';

import '../screens/campaign_list_screen.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final modeService = Provider.of<ModeService>(context, listen: false);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/dnd_wallpaper-1.jpg'),
                    fit: BoxFit.cover)),
            child: Container(),
          ),
          Container(
            child: ListTile(
              title: Text('Modo: ${modeService.getModeLabel()}'),
            ),
          ),
          ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                if (modeService.currentMode == modeService.modeMaster) {
                  Navigator.pushReplacementNamed(
                      context, CampaignListScreen.routeName);
                } else {
                  Navigator.pushReplacementNamed(
                      context, CharacterListScreen.routeName);
                }
              }),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Perfil'),
            onTap: () => Navigator.pushReplacementNamed(
                context, ProfileScreen.routeName),
          ),
          ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Player / Master Mode'),
              onTap: () {
                if (modeService.currentMode == modeService.modePlayer) {
                  modeService.changeMode(modeService.modeMaster);
                  Navigator.pushReplacementNamed(
                      context, CampaignListScreen.routeName);
                } else {
                  modeService.changeMode(modeService.modePlayer);
                  Navigator.pushReplacementNamed(
                      context, CharacterListScreen.routeName);
                }
              }),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuracion'),
            onTap: () => Navigator.pushReplacementNamed(
                context, SettingsScreen.routeName),
          ),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Salir'),
              onTap: () {
                authService.logout();
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              }),
        ],
      ),
    );
  }
}
