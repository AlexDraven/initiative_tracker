import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/character.dart';
import 'package:initiative_tracker/screens/screens.dart';
import 'package:initiative_tracker/services/services.dart';
import 'package:initiative_tracker/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CharacterListScreen extends StatelessWidget {
  const CharacterListScreen({Key? key}) : super(key: key);

  static const String routeName = '/characterList';

  @override
  Widget build(BuildContext context) {
    final charactersService = Provider.of<CharactersService>(context);

    if (charactersService.isLoading) return const LoadingScreen();
    return Scaffold(
        // backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: const Center(child: Text('Characters')),
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
                race: '',
                rolClass: '',
                active: true,
                playerId: '0');
            Navigator.pushNamed(context, CharacterScreen.routeName);
          },
        ));
  }
}
