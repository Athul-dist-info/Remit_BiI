import 'package:flutter/material.dart';
import 'package:remit_bi/core/constants.dart';
import 'package:remit_bi/model/rem3_model.dart';

class CorpBranchRemData {
  static DateTime fromDate = DateTime(2022, 1, 1);
  static DateTime toDate = DateTime(2022, 3, 31);
  static List<String> legendItems = ['HEAD OFFICE', 'MALIYA', 'AL-RAYAN'];

  static List<Map<String, Color>> getServiceColors() {
    return legendItems.map((category) {
      return {category: Constants.serviceColors[legendItems.indexOf(category)]};
    }).toList();
  }

  static List<REM3model> remittanceData = [
    REM3model(
      branchDescription: 'HEAD OFFICE',
      organisationDescription: 'BANK OF CEYLON',
      totalProvprofit: 0.0,
      txnCount: 21,
      totalEquvamt: 3926.4,
      totalFxamt: 524000.0,
    ),

    REM3model(
      branchDescription: 'HEAD OFFICE',
      organisationDescription: 'YES BANK',
      totalProvprofit: 893.234,
      txnCount: 41,
      totalEquvamt: 2113.21,
      totalFxamt: 287737.0,
    ),
    REM3model(
      branchDescription: 'MALIYA',
      organisationDescription: 'YES BANK',
      totalProvprofit: 0.6,
      txnCount: 10,
      totalEquvamt: 43.41,
      totalFxamt: 2000.0,
    ),
    REM3model(
      branchDescription: 'AL-RAYAN',
      organisationDescription: 'YES BANK',
      totalProvprofit: 456.234,
      txnCount: 23,
      totalEquvamt: 1878.21,
      totalFxamt: 187737.0,
    ),
    REM3model(
      branchDescription: 'HEAD OFFICE',
      organisationDescription: 'SOUTH INDIAN BANK',
      totalProvprofit: 0.001,
      txnCount: 27,
      totalEquvamt: 10.69,
      totalFxamt: 3000.0,
    ),
    REM3model(
      branchDescription: 'MALIYA',
      organisationDescription: 'SOUTH INDIAN BANK',
      totalProvprofit: 0.6,
      txnCount: 15,
      totalEquvamt: 43.41,
      totalFxamt: 2000.0,
    ),
  ];
}
