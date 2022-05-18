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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
          onPressed: campaignsService.isSaving
              ? null
              : () async {
                  if (!campaignForm.isValidForm()) return;
                  final String? imageUrl = await campaignsService.uploadImage();
                  if (imageUrl != null) {
                    campaignForm.campaign.picture = imageUrl;
                  }
                  await campaignsService
                      .saveOrCreateCampaign(campaignForm.campaign);
                  Navigator.of(context).pop();
                },
          child: campaignsService.isSaving
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Icon(Icons.save_outlined)),
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
                    } else if (value.length > 25) {
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
                // const SizedBox(
                //   height: 5,
                // ),
                // TextFormField(
                //   initialValue: '${campaign.level}',
                //   inputFormatters: [
                //     FilteringTextInputFormatter.allow(
                //         RegExp(r'^(\d+)?\.?\d{0,2}'))
                //   ],
                //   onChanged: (value) {
                //     if (int.tryParse(value) == null) {
                //       campaign.level = 0;
                //     } else {
                //       campaign.level = int.parse(value);
                //     }
                //   },
                //   keyboardType: TextInputType.number,
                //   decoration: const InputDecoration(
                //     hintText: 'Nivel del personaje',
                //     labelText: 'Nivel',
                //   ),
                // ),
                // const SizedBox(
                //   height: 5,
                // ),
                // TextFormField(
                //   initialValue: campaign.rolClass,
                //   onChanged: (value) => campaign.rolClass = value,
                //   // validator: (value) {
                //   //   if (value == null || value.isEmpty) {
                //   //     return 'Ingrese una clase';
                //   //   }
                //   // },
                //   decoration: const InputDecoration(
                //     hintText: 'Clase del Personaje',
                //     labelText: 'Clase',
                //   ),
                // ),
                // const SizedBox(
                //   height: 5,
                // ),
                // TextFormField(
                //   initialValue: campaign.race,
                //   onChanged: (value) => campaign.race = value,
                //   // validator: (value) {
                //   //   if (value == null || value.isEmpty) {
                //   //     return 'Ingrese una raza';
                //   //   }
                //   // },
                //   decoration: const InputDecoration(
                //     hintText: 'Raza del Personaje',
                //     labelText: 'Raza',
                //   ),
                // ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: null,
                  initialValue: campaign.description,
                  onChanged: (value) => campaign.description = value,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Descripción';
                  //   }
                  // },
                  decoration: const InputDecoration(
                    hintText: 'Descripción de la campaña',
                    labelText: 'Descripción',
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
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Notas';
                  //   }
                  // },
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
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: () {
                    deleteCampaignDialog(context, campaign);
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
                //     value: campaign.isActive,
                //     title: const Text('Activo'),
                //     activeColor: Colors.indigo,
                //     onChanged: campaignForm.updateActive),
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

  deleteCampaignDialog(BuildContext context, Campaign campaign) {
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
        await campaignsService.deleteCampaign(campaign);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CampaignListScreen()),
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
          "¿Está seguro que desea eliminar el personaje '${campaign.name}'?"),
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
