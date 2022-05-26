import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:initiative_tracker/models/campaign.dart';
import 'package:initiative_tracker/providers/campaign_form_provider.dart';
import 'package:initiative_tracker/screens/screens.dart';
import 'package:initiative_tracker/services/services.dart';
import 'package:initiative_tracker/widgets/campaign_image.dart';
import 'package:provider/provider.dart';

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
        child: Column(
            children: List<Widget>.generate(
                campaignsService.selectedCampaign.characters!.length,
                (int index) {
          return MaterialButton(
            onPressed: () {},
            color: Colors.blue,
            child: Text(
                campaignsService.selectedCampaign.characters![index].name ??
                    '-',
                style: const TextStyle(color: Colors.white)),
          );
        })),
      ),
    );
  }
}
