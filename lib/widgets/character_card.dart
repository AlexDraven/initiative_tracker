import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/models.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({Key? key, required this.character}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 0),
            width: double.infinity,
            height: 450,
            decoration: _cardBorders(),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                _BackgroundImage(character),
                _CharacterDetails(character),
                Positioned(
                    top: 0, right: 0, child: _CharacterLevelTag(character)),
                // ignore: todo
                // TODO: condicion
                // Positioned(top: 0, left: 0, child: _CampaignTag(character))
                Positioned(top: 0, left: 0, child: _CampaignTag(character)),
                // _CampaignTag(character)
              ],
            )));
  }

  BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 7),
            blurRadius: 10,
          ),
        ],
      );
}

class _CampaignTag extends StatelessWidget {
  final Character character;

  const _CampaignTag(this.character) : super();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 30,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: 300,
        height: 51,
        decoration: const BoxDecoration(
          color: Colors.indigoAccent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              character.campaign?.name ?? '',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
        width: 100,
        height: 51,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15))),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('LVL: ${character.level}',
                style: const TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ));
  }
}

class _CharacterDetails extends StatelessWidget {
  final Character character;

  const _CharacterDetails(this.character) : super();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 61,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              character.name ?? '',
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${character.race} / ${character.rolClass}',
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
        color: Colors.indigoAccent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      );
}

class _BackgroundImage extends StatelessWidget {
  final Character character;

  const _BackgroundImage(this.character) : super();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: Hero(
        tag: character.id!,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          child: SizedBox(
            width: double.infinity,
            height: 400,
            child: character.picture == null
                ? const Image(
                    image: AssetImage('assets/images/ditto.png'),
                    fit: BoxFit.cover)
                : FadeInImage(
                    placeholder:
                        const AssetImage('assets/images/jar-loading.gif'),
                    image: NetworkImage(character.picture!),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
