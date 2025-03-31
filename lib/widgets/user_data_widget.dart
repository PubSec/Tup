// Will show a logo of the carrier is the backgroud
// Will show data about the sim user and sim card amount
import 'package:flutter/material.dart';
import 'package:tup/model/carrier_model.dart';

Widget getUserData(CarrierModel carrierModel) {
  return Column(
    children: [
      Text(carrierModel.carrierName),
      Text(carrierModel.subscriptionId.toString()),
    ],
  );
}
