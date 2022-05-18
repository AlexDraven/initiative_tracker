import 'package:flutter/material.dart';
import 'package:initiative_tracker/models/campaign.dart';
import 'package:initiative_tracker/screens/screens.dart';
import 'package:initiative_tracker/services/services.dart';
import 'package:initiative_tracker/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CampaignListScreen extends StatelessWidget {
  const CampaignListScreen({Key? key}) : super(key: key);

  static const String routeName = '/campaigns';

  @override
  Widget build(BuildContext context) {
    final campaignsService = Provider.of<CampaignsService>(context);
    // ignore: unused_local_variable
    final initiativeWsService = Provider.of<InitiativeWsService>(context);

    if (campaignsService.isLoading) return const LoadingScreen();
    return Scaffold(
        // backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: const Center(child: Text('Campañas')),
        ),
        drawer: const MenuWidget(),
        body: campaignsService.campaigns.length > 0
            ? ListView.builder(
                itemCount: campaignsService.campaigns.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                        child: CampaignCard(
                            campaign: campaignsService.campaigns[index]),
                        onTap: () {
                          campaignsService.selectedCampaign =
                              campaignsService.campaigns[index].copy();
                          Navigator.pushNamed(
                              context, CampaignScreen.routeName);
                        }),
              )
            : const Center(
                child: Text('Aún no tienes campañas',
                    style: TextStyle(fontSize: 20)),
              ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            campaignsService.selectedCampaign =
                Campaign(name: '', description: '', notes: '', isActive: true);
            Navigator.pushNamed(context, CampaignScreen.routeName);
          },
        ));
  }
}
