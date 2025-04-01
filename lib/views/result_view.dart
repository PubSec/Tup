import 'package:flutter/material.dart';

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

class _ResultViewState extends State<ResultView> {
  List<String> returnList(String text) {
    List<String> textToList = text.split('\n');
    return textToList;
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
