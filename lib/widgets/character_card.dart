import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/models.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({Key? key, required this.character}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            width: double.infinity,
            height: 400,
            decoration: _cardBorders(),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                _BackgroundImage(character.picture),
                _CharacterDetails(character),
                Positioned(
                    top: 0, right: 0, child: _CharacterLevelTag(character)),
                // ignore: todo
                // TODO: condicion
                Positioned(top: 0, left: 0, child: _RolClassTag(character))
              ],
            )));
  }

  BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 7),
            blurRadius: 10,
          ),
        ],
      );
}

class _RolClassTag extends StatelessWidget {
  final Character character;

  const _RolClassTag(this.character) : super();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(character.rolClass,
                style: const TextStyle(fontSize: 20, color: Colors.white)),
          ),
        ),
      ),
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.yellow[800],
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      ),
    );
  }
}

class _CharacterLevelTag extends StatelessWidget {
  final Character character;

  const _CharacterLevelTag(this.character) : super();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Lvl: ${character.level}',
                style: const TextStyle(fontSize: 20, color: Colors.white)),
          ),
        ),
        width: 100,
        height: 70,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25))));
  }
}

class _CharacterDetails extends StatelessWidget {
  final Character character;

  const _CharacterDetails(this.character) : super();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 30,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              character.name,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              character.race,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      );
}

class _BackgroundImage extends StatelessWidget {
  final String? url;

  const _BackgroundImage(this.url) : super();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: SizedBox(
          width: double.infinity,
          height: 400,
          child: url == null
              ? const Image(
                  image: AssetImage('assets/images/ditto.png'),
                  fit: BoxFit.cover)
              : FadeInImage(
                  placeholder:
                      const AssetImage('assets/images/jar-loading.gif'),
                  image: NetworkImage(url!),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
