import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/models.dart';

class CampaignCard extends StatelessWidget {
  final Campaign campaign;

  const CampaignCard({Key? key, required this.campaign}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            width: double.infinity,
            height: 450,
            decoration: _cardBorders(),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                _BackgroundImage(campaign),
                _CampaignDetails(campaign),
                Positioned(
                    top: 0, right: 0, child: _CampaignLevelTag(campaign)),
                Positioned(top: 0, left: 0, child: _CampaignTag(campaign)),
              ],
            )));
  }

  BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.indigoAccent,
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
  final Campaign campaign;

  const _CampaignTag(this.campaign) : super();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 30,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: 300,
        height: 50,
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
              campaign.name ?? '',
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

class _CampaignLevelTag extends StatelessWidget {
  final Campaign campaign;

  const _CampaignLevelTag(this.campaign) : super();
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        height: 50,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
            )),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('id: ${campaign.id}',
                style: const TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ));
  }
}

class _CampaignDetails extends StatelessWidget {
  final Campaign campaign;

  const _CampaignDetails(this.campaign) : super();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 67,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              campaign.name ?? '',
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              campaign.description ?? '',
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
  final Campaign campaign;

  const _BackgroundImage(this.campaign) : super();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: Hero(
        tag: campaign.id!,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          child: SizedBox(
            width: double.infinity,
            height: 400,
            child: campaign.picture == null
                ? const Image(
                    image: AssetImage('assets/images/ditto.png'),
                    fit: BoxFit.cover)
                : FadeInImage(
                    placeholder: const AssetImage('assets/images/dados-35.gif'),
                    image: NetworkImage(campaign.picture!),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
