import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ussd_launcher/ussd_launcher.dart';
import 'dart:core';

RegExp extractAmountInResponse = RegExp(r"([0-9].[0-9]*)+birr");
RegExp extractNumberInResponse = RegExp(r"[0-9]*");

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
        if (response == null) {
          return "No Amount";
        } else {
          String cardAmount =
              "${extractAmountInResponse.firstMatch(response.toLowerCase())?[0]}";
          return cardAmount;
        }
      } catch (e) {
        debugPrint("Error! Code: ${e.toString()}");
      }
    } else {
      debugPrint('Permission denied');
    }

    return 'An error occured.';
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
        if (response == null) {
          return "Unable to get number";
        } else {
          String phoneNumber =
              "${extractAmountInResponse.firstMatch(response)![0]}";
          return phoneNumber;
        }
      } catch (e) {
        debugPrint("Error! Code: ${e.toString()}");
      }
    } else {
      debugPrint('Permission denied');
    }

    return 'An error occured.';
  }
}
