import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ussd_launcher/ussd_launcher.dart';

class CarrierModel {
  String carrierName;
  int subscriptionId;
  // String displayName;
  String number;
  // int slotIndex;
  // String countryIso;
  // int carrierId;
  // bool isEmbedded;
  // dynamic iccId;
  dynamic carrierData;
  CarrierModel({
    required this.carrierName,
    required this.subscriptionId,
    required this.carrierData,
    required this.number,
  });

  Future<String?> getAmountOnSim() async {
    var status = Permission.phone.request();
    if (await status.isGranted) {
      String code = "*804#"; // USSD code payload
      try {
        final response = await UssdLauncher.sendUssdRequest(
          ussdCode: code,
          subscriptionId: subscriptionId,
        );

        print("Success! Message: $response");
        return response;
      } catch (e) {
        debugPrint("Error! Code: ${e.toString()}");
      }
    } else {
      print('Permission lost');
    }

    return Future.value('dasd');
  }
}
