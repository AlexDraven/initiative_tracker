import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:initiative_tracker/models/campaign.dart';
import 'package:initiative_tracker/providers/campaign_form_provider.dart';
import 'package:initiative_tracker/screens/screens.dart';
import 'package:initiative_tracker/services/services.dart';
import 'package:initiative_tracker/widgets/campaign_image.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';

class CampaignAdminScreen extends StatelessWidget {
  const CampaignAdminScreen({Key? key}) : super(key: key);
  static const String routeName = '/campaign/admin';
  @override
  Widget build(BuildContext context) {
    final campaignsService = Provider.of<CampaignsService>(context);
    return ChangeNotifierProvider(
        create: (context) =>
            CampaignFormProvider(campaignsService.selectedCampaign),
        child: _CampaignScreenBody(campaignsService: campaignsService));
  }
}

class _CampaignScreenBody extends StatelessWidget {
  const _CampaignScreenBody({
    Key? key,
    required this.campaignsService,
  }) : super(key: key);

  final CampaignsService campaignsService;

  @override
  Widget build(BuildContext context) {
    final campaignForm = Provider.of<CampaignFormProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(campaignsService.selectedCampaign.name ?? '-'),
      ),
      body: Center(
        child: Column(children: [
          const SizedBox(height: 5),
          _CampaignAdminForm(campaignsService: campaignsService),
        ]),
      ),
    );
  }
}

class _CharactersList extends StatelessWidget {
  const _CharactersList({
    Key? key,
    required this.campaignsService,
  }) : super(key: key);

  final CampaignsService campaignsService;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
              const SizedBox(
                height: 5,
              )
            ] +
            [_CharacterList(context)]);
  }

  Widget _CharacterList(BuildContext context) {
    if (campaignsService.selectedCampaign.characters == null ||
        campaignsService.selectedCampaign.characters!.isEmpty) {
      return const Text('No hay jugadores! D:!',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color.fromARGB(255, 88, 88, 88),
              fontWeight: FontWeight.bold));
    } else {
      return Column(
        children: <Widget>[
          const SizedBox(
            height: 5,
          ),
          const Text('Jugadores',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 88, 88, 88),
                  fontWeight: FontWeight.bold)),
          ...List<Widget>.generate(
              campaignsService.selectedCampaign.characters!.length,
              (int index) {
            return _CharacterListItem(
              campaignsService.selectedCampaign.characters![index],
            );
          }),
        ],
      );
    }
  }

  Widget _CharacterListItem(
    Character character,
  ) {
    return Wrap(
      children: [
        MaterialButton(
          onPressed: () {},
          color: Colors.cyan,
          minWidth: 290,
          child: Text(character.name ?? '-',
              style: const TextStyle(color: Colors.white)),
        ),
        const SizedBox(
          width: 5,
        ),
        MaterialButton(
          onPressed: () {},
          color: Colors.red,
          minWidth: 10,
          child: const Text('x', style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}

class _CampaignAdminForm extends StatelessWidget {
  const _CampaignAdminForm({
    Key? key,
    required this.campaignsService,
  }) : super(key: key);

  final CampaignsService campaignsService;
  @override
  Widget build(BuildContext context) {
    final campaignForm = Provider.of<CampaignFormProvider>(context);
    final campaign = campaignForm.campaign;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            key: campaignForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                // code
                const Text('Codigo de referencia',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text(campaignsService.selectedCampaign.code ?? '- Sin Codigo -',
                    style: const TextStyle(fontSize: 20)),

                _CharactersList(campaignsService: campaignsService),
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
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 5),
              blurRadius: 10)
        ],
      );
}
