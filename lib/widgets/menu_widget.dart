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
      backgroundColor: Color.fromARGB(255, 12, 12, 12),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.90),
                image: DecorationImage(
                    image: AssetImage(
                        'assets/images/icon/icon-logo-dragon-v2.png'),
                    fit: BoxFit.contain)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  ' ${authService.username} ',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 185, 0, 0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Color.fromARGB(255, 0, 0, 0)),
                ),
              ],
            ),
          ),
          Text('Modo: ${modeService.getModeLabel()}',
              style: getTextStyle(context)),
          ListTile(
              leading: Icon(Icons.home, color: getModeColor(context)),
              title: Text('Home', style: getTextStyle(context)),
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
            leading: Icon(Icons.account_circle, color: getModeColor(context)),
            title: Text('Perfil', style: getTextStyle(context)),
            onTap: () => Navigator.pushReplacementNamed(
                context, ProfileScreen.routeName),
          ),
          ListTile(
              leading: Icon(Icons.admin_panel_settings,
                  color: getModeColor(context)),
              title: Text(
                  'Cambiar a ${modeService.currentMode != modeService.modePlayer ? 'Player' : 'Master'}',
                  style: getTextStyle(context)),
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
            leading: Icon(Icons.settings, color: getModeColor(context)),
            title: Text('Configuracion', style: getTextStyle(context)),
            onTap: () => Navigator.pushReplacementNamed(
                context, SettingsScreen.routeName),
          ),
          ListTile(
              leading: Icon(Icons.exit_to_app, color: getModeColor(context)),
              title: Text('Salir', style: getTextStyle(context)),
              onTap: () async {
                await authService.logout();
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              }),
        ],
      ),
    );
  }

  getTextStyle(BuildContext context) {
    final modeService = Provider.of<ModeService>(context, listen: false);
    return TextStyle(
        fontSize: 16,
        color: modeService.currentMode != modeService.modePlayer
            ? Color.fromARGB(255, 185, 0, 0)
            : Color.fromARGB(255, 185, 41, 41),
        fontWeight: FontWeight.bold);
  }

  getModeColor(BuildContext context) {
    final modeService = Provider.of<ModeService>(context, listen: false);
    return modeService.currentMode != modeService.modePlayer
        ? Color.fromARGB(255, 185, 0, 0)
        : Color.fromARGB(255, 185, 41, 41);
  }
}
