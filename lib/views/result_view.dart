import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ussd_launcher/ussd_launcher.dart';

class ResultView extends StatefulWidget {
  final int subscriptionId;
  final String text;

  const ResultView({
    super.key,
    required this.text,
    required this.subscriptionId,
  });

  @override
  State<ResultView> createState() => _ResultViewState();
}

Future<void> makeMyRequest(String cardPin, int subscriptionId) async {
  var status = Permission.phone.request();
  if (await status.isGranted) {
    String code = "*804*$cardPin#"; // USSD code payload
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

class _ResultViewState extends State<ResultView> {
  List<String> returnList(String text) {
    List<String> textToList = text.split('\n');
    return textToList;
  }

  @override
  void initState() {
    super.initState();
    print(widget.text);
    makeMyRequest("12345r", widget.subscriptionId);
  }

  @override
  Widget build(BuildContext context) {
    final value = returnList(widget.text);

    return Scaffold(
      appBar: AppBar(title: const Text('Result'), centerTitle: true),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Text(widget.text, style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
