import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tup/model/carrier_model.dart';
import 'package:ussd_launcher/ussd_launcher.dart';

class SimCardNotifier extends StateNotifier<List<CarrierModel>> {
  SimCardNotifier() : super([]);

  Future<void> loadSimCards() async {
    var status = await Permission.phone.request();
    if (status.isGranted) {
      try {
        final simCards = await UssdLauncher.getSimCards();
        final List<CarrierModel> carriers =
            simCards.map((simCard) {
              return CarrierModel(
                carrierName: simCard['carrierName'],
                subscriptionId: simCard['subscriptionId'],
                number: simCard['number'] ?? 'No number',
                slotIndex: simCard['slotIndex'],
                carrierData: simCard,
              );
            }).toList();
        state = carriers; // Update the state with the loaded SIM cards
      } catch (e) {
        debugPrint("Error loading SIM cards: $e");
      }
    } else {
      debugPrint("Phone permission not granted");
    }
  }
}

final simProvider = StateNotifierProvider<SimCardNotifier, List<CarrierModel>>((
  ref,
) {
  return SimCardNotifier();
});
