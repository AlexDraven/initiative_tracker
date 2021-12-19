import 'dart:io';

import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/models.dart';

class CharacterImage extends StatelessWidget {
  final Character? character;

  const CharacterImage({Key? key, this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        decoration: _buildBoxDecopation(),
        width: double.infinity,
        height: 450,
        child: Opacity(
          opacity: 0.9,
          child: Hero(
            tag: character!.id ?? 'newCharacter',
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45)),
                child: getImage(character!.picture)),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecopation() => BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(45), topRight: Radius.circular(45)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 5),
              blurRadius: 10)
        ],
      );

  Widget getImage(String? picture) {
    if (picture == null) {
      return const Image(
        image: AssetImage('assets/images/ditto.png'),
        fit: BoxFit.cover,
      );
    }

    if (picture.startsWith('http')) {
      return FadeInImage(
        placeholder: const AssetImage('assets/images/jar-loading.gif'),
        image: NetworkImage(picture),
        fit: BoxFit.cover,
      );
    }

    return Image.file(File(picture), fit: BoxFit.cover);
  }
}
