import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:initiative_tracker/models/character.dart';
import 'package:initiative_tracker/providers/character_form_provider.dart';
import 'package:initiative_tracker/screens/screens.dart';
import 'package:initiative_tracker/services/services.dart';
import 'package:initiative_tracker/widgets/character_image.dart';
import 'package:provider/provider.dart';

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({Key? key}) : super(key: key);
  static const String routeName = '/character';
  @override
  Widget build(BuildContext context) {
    final charactersService = Provider.of<CharactersService>(context);
    return ChangeNotifierProvider(
        create: (context) =>
            CharacterFormProvider(charactersService.selectedCharacter),
        child: _CharacterScreenBody(charactersService: charactersService));
  }
}

class _CharacterScreenBody extends StatelessWidget {
  const _CharacterScreenBody({
    Key? key,
    required this.charactersService,
  }) : super(key: key);

  final CharactersService charactersService;

  @override
  Widget build(BuildContext context) {
    final characterForm = Provider.of<CharacterFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                CharacterImage(
                  character: charactersService.selectedCharacter,
                ),
                Positioned(
                    top: 40,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          size: 40, color: Colors.white),
                      onPressed: () async {
                        if (!characterForm.isValidForm()) return;

                        final String? imageUrl =
                            await charactersService.uploadImage();
                        if (imageUrl != null) {
                          characterForm.character.picture = imageUrl;
                        }
                        if (charactersService.isSelectedCharacterEdited()) {
                          await charactersService
                              .saveOrCreateCharacter(characterForm.character);
                        }
                        Navigator.of(context).pop();
                      },
                    )),
                Positioned(
                    top: 40,
                    right: 20,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt_outlined,
                          size: 40, color: Colors.white),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile == null) {
                          // ignore: avoid_print
                          print('no selecciono nada');
                          return;
                        }
                        charactersService
                            .updateSelectedCharacterImage(pickedFile.path);
                      },
                    ))
              ],
            ),
            _CharacterForm(charactersService: charactersService),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // floatingActionButton: FloatingActionButton(
      //     onPressed: charactersService.isSaving
      //         ? null
      //         : () async {
      //             if (!characterForm.isValidForm()) return;
      //             final String? imageUrl =
      //                 await charactersService.uploadImage();
      //             if (imageUrl != null) {
      //               characterForm.character.picture = imageUrl;
      //             }
      //             await charactersService
      //                 .saveOrCreateCharacter(characterForm.character);
      //             Navigator.of(context).pop();
      //           },
      //     child: charactersService.isSaving
      //         ? const CircularProgressIndicator(
      //             color: Colors.white,
      //           )
      //         : const Icon(Icons.save_outlined)),
    );
  }
}

class _CharacterForm extends StatelessWidget {
  _CharacterForm({
    Key? key,
    required this.charactersService,
  }) : super(key: key);

  TextEditingController _textFieldController = TextEditingController();

  final CharactersService charactersService;
  @override
  Widget build(BuildContext context) {
    final characterForm = Provider.of<CharacterFormProvider>(context);
    final character = characterForm.character;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            key: characterForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 0,
                ),
                _buildUniteToCampaignButton(
                    context, charactersService, character),
                const SizedBox(
                  height: 0,
                ),
                TextFormField(
                  initialValue: character.name,
                  onChanged: (value) => character.name = value,
                  validator: (value) {
                    if (value == null) {
                      return 'Ingrese un nombre';
                    } else if (value.length > 35) {
                      return 'El nombre es muy largo';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Nombre del Personaje',
                    labelText: 'Nombre',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: '${character.level}',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  onChanged: (value) {
                    if (int.tryParse(value) == null) {
                      character.level = 0;
                    } else {
                      character.level = int.parse(value);
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Nivel del personaje',
                    labelText: 'Nivel',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: character.rolClass,
                  onChanged: (value) => character.rolClass = value,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Ingrese una clase';
                  //   }
                  // },
                  decoration: const InputDecoration(
                    hintText: 'Clase del Personaje',
                    labelText: 'Clase',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  initialValue: character.race,
                  onChanged: (value) => character.race = value,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Ingrese una raza';
                  //   }
                  // },
                  decoration: const InputDecoration(
                    hintText: 'Raza del Personaje',
                    labelText: 'Raza',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: null,
                  initialValue: character.description,
                  onChanged: (value) => character.description = value,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Descripción';
                  //   }
                  // },
                  decoration: const InputDecoration(
                    hintText: 'Descripción del Personaje',
                    labelText: 'Descripción',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 10,
                  maxLines: null,
                  initialValue: character.notes,
                  onChanged: (value) => character.notes = value,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Notas';
                  //   }
                  // },
                  decoration: const InputDecoration(
                    hintText: 'Notas del Personaje',
                    labelText: 'Notas',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(400, 40),
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: () {
                    deleteCharacterDialog(context, character);
                  },
                  child: const Text(
                    "Eliminar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                // SwitchListTile.adaptive(
                //     value: character.isActive,
                //     title: const Text('Activo'),
                //     activeColor: Colors.indigo,
                //     onChanged: characterForm.updateActive),
                const SizedBox(
                  height: 20,
                ),
              ],
            )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 5),
              blurRadius: 10)
        ],
      );

  deleteCharacterDialog(BuildContext context, Character character) {
    Widget cancelButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey,
        padding: const EdgeInsets.all(10),
      ),
      onPressed: () => Navigator.of(context).pop(),
      child: const Text(
        "Cancelar",
        style: TextStyle(color: Colors.white),
      ),
    );
    Widget continueButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.all(10),
      ),
      onPressed: () async {
        charactersService.deleteCharacter(character);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CharacterListScreen()),
        );
        // ignore: use_build_context_synchronously
        // Navigator.of(context).pop();
        // TODO : reload list
      },
      child: const Text(
        "Confirmar",
        style: TextStyle(color: Colors.white),
      ),
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Eliminar personaje"),
      content: Text(
          "¿Está seguro que desea eliminar el personaje '${character.name}'?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // If not in campaign show 'unite to campaign' button, else show 'unite to campaign' button
  Widget _buildUniteToCampaignButton(BuildContext context,
      CharactersService charactersService, Character character) {
    if (character.id != null &&
        charactersService.characters
                .indexWhere((element) => element.id == character.id) !=
            -1) {
      final originalCharacter = charactersService.characters
          .firstWhere((Character c) => c.id == character.id);
      if (originalCharacter.campaign == null) {
        return TextButton(
          style: TextButton.styleFrom(
            minimumSize: const Size(400, 40),
            backgroundColor: Colors.green,
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          onPressed: () {
            return addToCampaignDialog(context, character);
            //  print('Unite to campaign');
          },
          child: const Text(
            "Unirse a una campaña",
            style: TextStyle(color: Colors.white),
          ),
        );
      } else {
        return TextButton(
          style: TextButton.styleFrom(
            minimumSize: const Size(400, 40),
            backgroundColor: Color.fromARGB(255, 0, 121, 4),
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          onPressed: () {
            // TODO: eliminar de campaña, esto saca dialogo de confirmacion y te saca de la campaña
            print('touch name of campaign');
            //   return removeFromCampaignDialog(context, character);
          },
          child: Text(
            'Campaña: ${originalCharacter.campaign?.name ?? '-'}',
            style: const TextStyle(color: Colors.white),
          ),
        );
      }
    } else {
      return Container();
    }
  }

  // add to campaign
  addToCampaignDialog(BuildContext context, Character character) {
    String codeDialog = '';
    String valueText = '';
    Widget cancelButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey,
        padding: const EdgeInsets.all(10),
      ),
      onPressed: () => Navigator.of(context).pop(),
      child: const Text(
        "Cancelar",
        style: TextStyle(color: Colors.white),
      ),
    );
    Widget continueButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.all(10),
      ),
      onPressed: () async {
        // charactersService.addToCampaign(character); // ???
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CharacterListScreen()),
        );
        // ignore: use_build_context_synchronously
        // Navigator.of(context).pop();
        // TODO : reload list
      },
      child: const Text(
        "Confirmar",
        style: TextStyle(color: Colors.white),
      ),
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Agregar personaje"),
      content: TextField(
        onChanged: (value) {
          valueText = value;
        },
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "Text Field in Dialog"),
      ),
      //  Text(
      //     "¿Está seguro que desea agregar el personaje '${character.name}'?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
