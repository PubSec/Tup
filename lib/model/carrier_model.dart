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
}
