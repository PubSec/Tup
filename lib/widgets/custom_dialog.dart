import 'package:flutter/material.dart';

Widget customDialog(context, {bool isError = false}) {
  if (isError == false) {
    return Dialog(
      child: Column(
        children: [
          Text('Error'),
          Text('Error'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Try again'),
              ),
            ],
          ),
        ],
      ),
    );
  } else {
    return Dialog(
      child: Column(
        children: [
          Text('Success'),
          Text('Success'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No Try again'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
