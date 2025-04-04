import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ussd_launcher/ussd_launcher.dart';
import 'dart:core';

RegExp re = RegExp("[0-9]");

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
        debugPrint("Success! Message: $response");
        if (response == null) {
          return "No Amount";
        } else {
          List<String> listOfResponse = response.split(':');
          for (String text in listOfResponse) {
            print("=== ${listOfResponse} ====");

            print("=== ${text[1]} ====");
            if (re.hasMatch(text)) return text;
          }
        }
      } catch (e) {
        debugPrint("Error! Code: ${e.toString()}");
      }
    } else {
      debugPrint('Permission lost');
    }

    return Future.value('An error occured.');
  }

  Future<String?> getSimNumber() async {
    var status = Permission.phone.request();
    if (await status.isGranted) {
      String code = "*111#"; // USSD code payload
      try {
        final response = await UssdLauncher.sendUssdRequest(
          ussdCode: code,
          subscriptionId: subscriptionId,
        );
        debugPrint("Success! Message: $response");
        if (response == null) {
          return "Unable to get number";
        } else {
          List<String> listOfResponse = response.split(':');
          for (String text in listOfResponse) {
            if (re.hasMatch(text)) return text;
          }
        }
      } catch (e) {
        debugPrint("Error! Code: ${e.toString()}");
      }
    } else {
      debugPrint('Permission lost');
    }

    return Future.value('An error occured.');
  }
}
