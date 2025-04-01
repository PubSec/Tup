import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tup/providers/sim_card_provider.dart';
import 'package:tup/views/scan_view.dart';

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
          return FutureBuilder(
            future: simCardsInfo[index].getAmountOnSim(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  title: Text("${simCardsInfo[index].carrierName}  Loading..."),
                  subtitle: Text(simCardsInfo[index].number),
                );
              } else if (snapshot.hasError) {
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 20),
                  leading: Icon(Icons.sim_card_rounded),
                  title: Text(
                    "${simCardsInfo[index].carrierName}"
                    " ${snapshot.error.toString() ?? "0"} birr",
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
                              child: Text(
                                simCardsInfo[index].carrierData.toString(),
                              ),
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
                              subscritpionId:
                                  simCardsInfo[index].subscriptionId,
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
                                subscritpionId:
                                    simCardsInfo[index].subscriptionId,
                              ),
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_forward_ios_outlined),
                    label: Text('Top Up'),
                  ),
                );
              } else {
                return ListTile(
                  contentPadding: EdgeInsets.only(left: 20),
                  leading: Text("Sim ${(index + 1).toString()}"),
                  title: Text(
                    "${simCardsInfo[index].carrierName}"
                    " ${snapshot.data ?? "0"} birr",
                  ),
                  subtitle: Text(
                    "Phone Number: ${simCardsInfo[index].number.toString()}",
                  ),
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
                              child: Text(
                                simCardsInfo[index].carrierData.toString(),
                              ),
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
                              subscritpionId:
                                  simCardsInfo[index].subscriptionId,
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
                                subscritpionId:
                                    simCardsInfo[index].subscriptionId,
                              ),
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_forward_ios_outlined),
                    label: Text('Top Up'),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
