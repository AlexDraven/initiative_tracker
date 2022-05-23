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
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                CampaignImage(
                  campaign: campaignsService.selectedCampaign,
                ),
                Positioned(
                    top: 40,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          size: 40, color: Colors.white),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    )),
                // Positioned(
                //     top: 40,
                //     right: 20,
                //     child: IconButton(
                //       icon: const Icon(Icons.camera_alt_outlined,
                //           size: 40, color: Colors.white),
                //       onPressed: () async {
                //         final ImagePicker picker = ImagePicker();
                //         final XFile? pickedFile =
                //             await picker.pickImage(source: ImageSource.gallery);
                //         if (pickedFile == null) {
                //           // ignore: avoid_print
                //           print('no selecciono nada');
                //           return;
                //         }
                //         campaignsService
                //             .updateSelectedCampaignImage(pickedFile.path);
                //       },
                //     ))
              ],
            ),
            //  _CampaignForm(campaignsService: campaignsService),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
