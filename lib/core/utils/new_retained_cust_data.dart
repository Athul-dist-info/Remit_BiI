import 'package:flutter/material.dart';
import 'package:remit_bi/core/constants.dart';
import 'package:remit_bi/model/rem6_model.dart';

class NewRetainedCustomersData {
  static DateTime fromDate = DateTime(2022, 1, 1);
  static DateTime toDate = DateTime(2022, 3, 31);

  static List<String> legendItems = ['HEAD OFFICE', 'MALIYA', 'AL RAYAN'];

  static List<Map<String, Color>> getServiceColors() {
    return legendItems.map((category) {
      return {category: Constants.serviceColors[legendItems.indexOf(category)]};
    }).toList();
  }

  static List<REM6Model> remittanceData = [
    REM6Model(
      branchDescription: 'HEAD OFFICE',
      totalFxAmt: 3613931.59,
      totalEquvAmt: 21219.97,
      totalProvProfit: 4217.193,
      txnCount: 191,
      customerGroup: 'RETAINED CUSTOMERS',
    ),
    REM6Model(
      branchDescription: 'MALIYA',
      totalFxAmt: 361393.0,
      totalEquvAmt: 2121.41,
      totalProvProfit: 421.6,
      txnCount: 87,
      customerGroup: 'RETAINED CUSTOMERS',
    ),
    REM6Model(
      branchDescription: 'AL RAYAN',
      totalFxAmt: 61393.0,
      totalEquvAmt: 1356.41,
      totalProvProfit: 234.6,
      txnCount: 42,
      customerGroup: 'RETAINED CUSTOMERS',
    ),
  ];
}
