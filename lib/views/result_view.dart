import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ussd_launcher/ussd_launcher.dart';
import 'dart:core';

RegExp re = RegExp("[0-9][0-9][0-9]");

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
      Iterable<Match> matches = re.allMatches(response!);
      for (final Match m in matches) {
        String match = m[0]!;
        print(match);
      }

      debugPrint("Success! Message: $response");
    } catch (e) {
      debugPrint("Error! Code: ${e.toString()}");
    }
  } else {
    debugPrint('Permission lost');
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
    debugPrint(widget.text);
    makeMyRequest("12345r", widget.subscriptionId);
  }

  @override
  Widget build(BuildContext context) {
    // final value = returnList(widget.text);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Text(,style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
