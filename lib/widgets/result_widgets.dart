import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ussd_launcher/ussd_launcher.dart';

RegExp re = RegExp(r"^[0-9]*$", multiLine: true, unicode: true);
RegExp exp = RegExp(r"[0-9]+birr");

Future<String> makeMyRequest(int subscriptionId, String text) async {
  var status = Permission.phone.request();
  if (await status.isGranted) {
    try {
      final sReplaced = text.replaceAll(' ', '');
      String cardPin = re.firstMatch(sReplaced)?[0] ?? 'noo';
      String cardAmount = exp.firstMatch(sReplaced)?[0] ?? 'No';
      if (cardPin.contains(RegExp('[A-Za-z*_#%&!]'))) {
        print('error');
      } else {
        String code = "*805*$cardPin#";
        final response = await UssdLauncher.sendUssdRequest(
          ussdCode: code,
          subscriptionId: subscriptionId,
        );
        if (response!.toLowerCase().contains('sorry')) {
          return "Recharge unsuccessful";
        } else {
          return "Recharge unsuccessful";
        }
      }
    } catch (e) {
      debugPrint("Error! Code: ${e.toString()}");
    }
  } else {
    debugPrint('Permission lost');
  }
  return "Recharge Failed";
}

Future<dynamic> resultWidget(
  BuildContext context,
  int subscriptionId,
  String text,
) async {
  String rechargeStatus = await makeMyRequest(subscriptionId, text);
  return showAdaptiveDialog(
    context: context,
    builder: (context) {
      return Dialog(child: Text(rechargeStatus));
    },
  );
}
