import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tup/widgets/custom_dialog.dart';
import 'package:ussd_launcher/ussd_launcher.dart';

enum RechargeResult { successful, failed }

RegExp re = RegExp(r"^[0-9]*$", multiLine: true, unicode: true);
RegExp exp = RegExp(r"[0-9]+birr");

Future<RechargeResult> makeMyRequest(int subscriptionId, String text) async {
  var status = Permission.phone.request();
  if (await status.isGranted) {
    try {
      final sReplaced = text.replaceAll(' ', '');
      String cardAmount = exp.firstMatch(sReplaced.toLowerCase())?[0] ?? 'No';
      var cardPinMatch = re.allMatches(sReplaced.toLowerCase());
      for (final cardPin in cardPinMatch) {
        if (cardPin[0].toString().length == 14) {
          String code = "*805*$cardPin#";
          print("********* ${sReplaced} **********");
          print(cardPin[0].toString());
          print(cardAmount);

          final response = await UssdLauncher.sendUssdRequest(
            ussdCode: code,
            subscriptionId: subscriptionId,
          );
          if (response!.toLowerCase().contains('sorry') ||
              response!.toLowerCase().contains('wrong') ||
              response!.toLowerCase().contains('failed')) {
            debugPrint(
              "Recharge unsuccessful: $code -> $cardAmount => $response ",
            );
            return RechargeResult.failed;
          } else {
            debugPrint(
              "Recharge successful:  $code  -> $cardAmount => $response",
            );
            return RechargeResult.successful;
          }
        }
      }
    } catch (e) {
      debugPrint("Error! Code: ${e.toString()}");
    }
  } else {
    debugPrint('Permission lost');
  }
  return RechargeResult.failed;
}

// Widget to be displayed after recharge
Future<dynamic> resultWidget(
  BuildContext context,
  int subscriptionId,
  String text,
) async {
  RechargeResult result = await makeMyRequest(subscriptionId, text);
  return showAdaptiveDialog(
    context: context,
    builder: (context) {
      if (result == RechargeResult.failed) {
        return customDialog(context, isError: true);
      } else {
        return customDialog(context);
      }
    },
  );
}
