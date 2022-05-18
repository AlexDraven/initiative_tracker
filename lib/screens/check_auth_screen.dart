import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:initiative_tracker/screens/campaign_list_screen.dart';
import 'package:initiative_tracker/screens/screens.dart';
import 'package:initiative_tracker/services/mode_service.dart';
import 'package:initiative_tracker/services/services.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CheckAuthScreen extends StatelessWidget {
  static const String routeName = '/checking-auth';

  const CheckAuthScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final modeService = Provider.of<ModeService>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            if (snapshot.data == '') {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return LoginScreen();
                      },
                      transitionDuration: const Duration(seconds: 0),
                    ));
              });
            } else {
              Future.microtask(() {
                if (modeService.currentMode == modeService.modePlayer) {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return const CharacterListScreen();
                        },
                        transitionDuration: const Duration(seconds: 0),
                      ));
                }
                if (modeService.currentMode == modeService.modeMaster) {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return const CampaignListScreen();
                        },
                        transitionDuration: const Duration(seconds: 0),
                      ));
                }
              });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
