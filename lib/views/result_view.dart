// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:ussd_launcher/ussd_launcher.dart';
// import 'dart:core';

// RegExp re = RegExp(r"^[0-9]*$", multiLine: true, unicode: true);
// RegExp exp = RegExp(r"[0-9]+birr");

// class ResultView extends StatefulWidget {
//   final int subscriptionId;
//   final String text;

//   const ResultView({
//     super.key,
//     required this.text,
//     required this.subscriptionId,
//   });

//   @override
//   State<ResultView> createState() => _ResultViewState();
// }

// Future<void> makeMyRequest(int subscriptionId, String text) async {
//   var status = Permission.phone.request();
//   if (await status.isGranted) {
//     try {
//       final sReplaced = text.replaceAll(' ', '');
//       String cardPin = re.firstMatch(sReplaced)?[0] ?? 'noo';
//       String cardAmount = exp.firstMatch(sReplaced)?[0] ?? 'No';
//       if (cardPin.contains(RegExp('[A-Za-z*_#%&!]'))) {
//         print('error');
//       } else {
//         String code = "*805*$cardPin#";
//         final response = await UssdLauncher.sendUssdRequest(
//           ussdCode: code,
//           subscriptionId: subscriptionId,
//         );
//         if (response.toLowerCase().contains('sorry')) {
//           print('failed');
//         }
//       }
//     } catch (e) {
//       debugPrint("Error! Code: ${e.toString()}");
//     }
//   } else {
//     debugPrint('Permission lost');
//   }
// }

// class _ResultViewState extends State<ResultView> {
//   @override
//   void initState() {
//     super.initState();
//     debugPrint(widget.text);
//     makeMyRequest(widget.subscriptionId, widget.text);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Result'),
//         centerTitle: true,
//         leading: BackButton(
//           onPressed: () {
//             Navigator.of(context).popUntil((route) => route.isFirst);
//           },
//         ),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(30.0),
//         child: Text('', style: TextStyle(fontSize: 20)),
//       ),
//     );
//   }
// }
