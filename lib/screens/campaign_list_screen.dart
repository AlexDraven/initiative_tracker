import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/character.dart';
import 'package:initiative_tracker/screens/screens.dart';
import 'package:initiative_tracker/services/services.dart';
import 'package:initiative_tracker/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CampaignListScreen extends StatelessWidget {
  const CampaignListScreen({Key? key}) : super(key: key);

  static const String routeName = '/campaigns';

  @override
  Widget build(BuildContext context) {
    final charactersService = Provider.of<CharactersService>(context);
    // ignore: unused_local_variable
    final initiativeWsService = Provider.of<InitiativeWsService>(context);

    if (charactersService.isLoading) return const LoadingScreen();
    return Scaffold(
        // backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: const Center(child: Text('Campañas')),
        ),
        drawer: const MenuWidget(),
        body: ListView.builder(
          itemCount: charactersService.characters.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
              child:
                  CharacterCard(character: charactersService.characters[index]),
              onTap: () {
                charactersService.selectedCharacter =
                    charactersService.characters[index].copy();
                Navigator.pushNamed(context, CharacterScreen.routeName);
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            charactersService.selectedCharacter = Character(
                name: '',
                level: 1,
                description: '',
                notes: '',
                race: '',
                rolClass: '',
                isActive: true);
            Navigator.pushNamed(context, CharacterScreen.routeName);
          },
        ));
  }
}
