import 'package:flutter/material.dart';
import 'package:remit_bi/core/constants.dart';
import 'package:remit_bi/model/rem4_model.dart';

class ForeignCurSaleData {
  static DateTime fromDate = DateTime(2022, 1, 1);
  static DateTime toDate = DateTime(2022, 3, 31);
  static List<String> legendItems = ['HEAD OFFICE', 'MALIYA', 'AL-RAYAN'];

  static List<Map<String, Color>> getServiceColors() {
    return legendItems.map((category) {
      return {category: Constants.serviceColors[legendItems.indexOf(category)]};
    }).toList();
  }

  static List<REM4model> remittanceData = [
    REM4model(
      branchDescription: 'HEAD OFFICE',
      curCode: 'INR',
      totalFxAmt: 746000,
      totalEquvAmt: 3062,
      totalProfit: -1,
      txnCount: 1119,
    ),
    REM4model(
      branchDescription: 'HEAD OFFICE',
      curCode: 'BDT',
      totalFxAmt: 546000,
      totalEquvAmt: 2062,
      totalProfit: 1,
      txnCount: 900,
    ),
    REM4model(
      branchDescription: 'MALIYA',
      curCode: 'INR',
      totalFxAmt: 946000,
      totalEquvAmt: 3062,
      totalProfit: -1,
      txnCount: 1119,
    ),
    REM4model(
      branchDescription: 'AL-RAYAN',
      curCode: 'INR',
      totalFxAmt: 746000,
      totalEquvAmt: 3062,
      totalProfit: -1,
      txnCount: 1119,
    ),
  ];
}
