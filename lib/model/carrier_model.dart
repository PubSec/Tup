import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ussd_launcher/ussd_launcher.dart';
import 'dart:core';

RegExp extractAmountInResponse = RegExp(r"([0-9].[0-9]*)+birr");
RegExp extractNumberInResponse = RegExp(r"[0-9]*");

// The commented parts might be used to automatically de/serialize the json
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

  // Ask for the card amount on the sim. UssdLauncher is difficult to work so
  // I'm working on a better ussd service provider.
  Future<String> getAmountOnSim() async {
    var status = Permission.phone.request();
    if (await status.isGranted) {
      String code = "*804#"; // USSD code payload
      try {
        final response = await UssdLauncher.sendUssdRequest(
          ussdCode: code,
          subscriptionId: subscriptionId,
        );
        if (response == null) {
          return "Data unavailable";
        } else {
          String cardAmount =
              extractAmountInResponse.firstMatch(response.toLowerCase())?[0] ??
              '';
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

  /// Provides the sim data how to home view
  /// Only works sometimes. Issue with the response from ethio tel
  Future<String> getSimNumber() async {
    var status = Permission.phone.request();
    if (await status.isGranted) {
      String code = "*111#"; // USSD code payload
      try {
        final response = await UssdLauncher.sendUssdRequest(
          ussdCode: code,
          subscriptionId: subscriptionId,
        );

        if (response == null) {
          return "Data unavailable";
        } else {
          String phoneNumber =
              extractAmountInResponse.firstMatch(response)?[0].toString() ?? '';
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
