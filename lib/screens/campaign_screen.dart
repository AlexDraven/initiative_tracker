import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:initiative_tracker/models/campaign.dart';
import 'package:initiative_tracker/providers/campaign_form_provider.dart';
import 'package:initiative_tracker/screens/screens.dart';
import 'package:initiative_tracker/services/services.dart';
import 'package:initiative_tracker/widgets/campaign_image.dart';
import 'package:provider/provider.dart';

class CampaignScreen extends StatelessWidget {
  const CampaignScreen({Key? key}) : super(key: key);
  static const String routeName = '/campaign';
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
                        if (!campaignForm.isValidForm()) return;
                        final String? imageUrl =
                            await campaignsService.uploadImage();
                        if (imageUrl != null) {
                          campaignForm.campaign.picture = imageUrl;
                        }
                        await campaignsService
                            .saveOrCreateCampaign(campaignForm.campaign);
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
                        campaignsService
                            .updateSelectedCampaignImage(pickedFile.path);
                      },
                    ))
              ],
            ),
            _CampaignForm(campaignsService: campaignsService),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // floatingActionButton: FloatingActionButton(
      //     onPressed: campaignsService.isSaving
      //         ? null
      //         : () async {
      //             if (!campaignForm.isValidForm()) return;
      //             final String? imageUrl = await campaignsService.uploadImage();
      //             if (imageUrl != null) {
      //               campaignForm.campaign.picture = imageUrl;
      //             }
      //             await campaignsService
      //                 .saveOrCreateCampaign(campaignForm.campaign);
      //             Navigator.of(context).pop();
      //           },
      //     child: campaignsService.isSaving
      //         ? const CircularProgressIndicator(
      //             color: Colors.white,
      //           )
      //         : const Icon(Icons.save_outlined)),
    );
  }
}

class _CampaignForm extends StatelessWidget {
  const _CampaignForm({
    Key? key,
    required this.campaignsService,
  }) : super(key: key);

  final CampaignsService campaignsService;
  @override
  Widget build(BuildContext context) {
    final campaignForm = Provider.of<CampaignFormProvider>(context);
    final campaign = campaignForm.campaign;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                TextFormField(
                  initialValue: campaign.name,
                  onChanged: (value) => campaign.name = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese un nombre';
                    } else if (value.length > 50) {
                      return 'El nombre es muy largo';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Nombre de la campaña',
                    labelText: 'Nombre',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: null,
                  initialValue: campaign.description,
                  onChanged: (value) => campaign.description = value,
                  decoration: const InputDecoration(
                    hintText: 'Descripción de la campaña',
                    labelText: 'Descripción',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(400, 40),
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    // TODO: Open initiative screen
                    print('OPEN INITIATIVE SCREEN');
                  },
                  child: const Text(
                    "Roll Initiative!",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: null,
                  initialValue: campaign.notes,
                  onChanged: (value) => campaign.notes = value,
                  decoration: const InputDecoration(
                    hintText: 'Notas de la campaña',
                    labelText: 'Notas',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size(400, 40),
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: () {
                    // TODO: Open admin  screen
                    print('OPEN ADMIN SCREEN');
                    Navigator.pushNamed(context, CampaignAdminScreen.routeName);
                  },
                  child: const Text(
                    "Administrar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
}
