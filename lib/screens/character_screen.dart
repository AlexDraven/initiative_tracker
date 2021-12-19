import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:initiative_tracker/providers/character_form_provider.dart';
import 'package:initiative_tracker/services/services.dart';
import 'package:initiative_tracker/widgets/character_image.dart';
import 'package:provider/provider.dart';

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({Key? key}) : super(key: key);
  static const String routeName = '/product';
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
                    top: 60,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          size: 40, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    )),
                Positioned(
                    top: 60,
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
            _CharacterForm(),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
          child: charactersService.isSaving
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Icon(Icons.save_outlined),
          onPressed: charactersService.isSaving
              ? null
              : () async {
                  if (!characterForm.isValidForm()) return;
                  final String? imageUrl =
                      await charactersService.uploadImage();
                  if (imageUrl != null) {
                    characterForm.character.picture = imageUrl;
                  }
                  await charactersService
                      .saveOrCreateCharacter(characterForm.character);
                }),
    );
  }
}

class _CharacterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final characterForm = Provider.of<CharacterFormProvider>(context);
    final character = characterForm.character;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            key: characterForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: character.name,
                  onChanged: (value) => character.name = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese un nombre';
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Nombre del Personaje',
                    labelText: 'characterName',
                  ),
                ),
                const SizedBox(
                  height: 30,
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
                    hintText: 'nivel del personaje',
                    labelText: 'lvl',
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SwitchListTile.adaptive(
                    value: character.active,
                    title: const Text('Activo'),
                    activeColor: Colors.indigo,
                    onChanged: characterForm.updateActive),
                const SizedBox(
                  height: 30,
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
}
