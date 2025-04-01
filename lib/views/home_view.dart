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
        subscriptionId: subscriptionId,
      );

      print("Success! Message: $response");
    } catch (e) {
      debugPrint("Error! Code: ${e.toString()}");
    }
  } else {
    print('Permission lost');
  }
}

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(simProvider.notifier).loadSimCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    final simCardsInfo = ref.watch(simProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("TUp"),
        bottom: PreferredSize(
          preferredSize: Size(10, 10),
          child: Text(simCardsInfo.firstOrNull?.carrierName ?? 'No carrier'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.watch(simProvider.notifier).loadSimCards();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: simCardsInfo.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: EdgeInsets.only(left: 20),
            leading: Icon(Icons.sim_card_rounded),
            title: Text(
              "${simCardsInfo[index].carrierName}"
              " ${simCardsInfo[index].subscriptionId.toString()}",
            ),
            subtitle: Text(simCardsInfo[index].number.toString()),
            onLongPress: () {
              showModalBottomSheet(
                showDragHandle: true,
                context: context,
                builder: (context) {
                  return BottomSheet(
                    onClosing: () {},
                    builder: (context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 10,
                        child: Text(simCardsInfo[index].carrierData.toString()),
                      );
                    },
                  );
                },
              );
            },
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => ScanView(
                        subscritpionId: simCardsInfo[index].subscriptionId,
                      ),
                ),
              );
            },
            trailing: TextButton.icon(
              iconAlignment: IconAlignment.end,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => ScanView(
                          subscritpionId: simCardsInfo[index].subscriptionId,
                        ),
                  ),
                );
              },
              icon: Icon(Icons.arrow_forward_ios_outlined),
              label: Text('Top Up'),
            ),
          );
        },
      ),
    );
  }
}
