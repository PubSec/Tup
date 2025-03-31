import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tup/providers/sim_card_provider.dart';
import 'package:tup/views/scan_view.dart';
import 'package:ussd_launcher/ussd_launcher.dart';


Future<void> makeMyRequest() async {
  var status = Permission.phone.request();
  if (await status.isGranted) {
    int subscriptionId = 1; // SIM card subscription ID
    String code = "*804#"; // USSD code payload
    try {

      final response = await UssdLauncher.sendUssdRequest(
        ussdCode: code,
        subscriptionId:subscriptionId,
      );

      print("Success! Message: $response");
    } catch (e) {
      debugPrint("Error! Code: ${e.toString()}");
    }
  }else{
    print('Permission lost');
  }
}



class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  String lengthofSim = '0';
  String value = "Hello";
  String value1 = "Hello";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final simCardsInfo = ref.watch(simProvider);
    return Scaffold(
      appBar: AppBar(title: Text("TUp"),),
      body:Center(
        child: Column(
          children: [
            Text(lengthofSim),
            Text(value),
            Text(value1),
            if (isLoading) CircularProgressIndicator(),
            TextButton(
              onPressed: ()  {
                ref.watch(simProvider.notifier).loadSimCards();
               setState(() {
                 value = simCardsInfo[0].carrierName;
                 value1 = simCardsInfo[0].subscriptionId.toString();
                 lengthofSim = simCardsInfo.length.toString();
               });
               makeMyRequest();
              },
              child: Text('Press me'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScanView()));
              },
              child: Text("Recharge"),
            ),
          ],
        ),
        ),
      );
  }

}

