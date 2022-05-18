import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/models.dart';

class CampaignFormProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  Campaign campaign;

  CampaignFormProvider(this.campaign);

  updateActive(bool value) {
    campaign.isActive = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
