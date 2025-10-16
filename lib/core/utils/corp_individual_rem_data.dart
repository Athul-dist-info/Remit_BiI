import 'package:flutter/material.dart';
import 'package:remit_bi/core/constants.dart';
import 'package:remit_bi/model/rem7_model.dart';

class CorpIndividualRemData {
  static DateTime fromDate = DateTime(2022, 1, 1);
  static DateTime toDate = DateTime(2022, 3, 31);

  static List<String> legendItems = ['HEAD OFFICE', 'MALIYA'];

  static List<Map<String, Color>> getServiceColors() {
    return legendItems.map((category) {
      return {category: Constants.serviceColors[legendItems.indexOf(category)]};
    }).toList();
  }

  static List<REM7Model> remittanceData = [
    REM7Model(
      branchDescription: 'HEAD OFFICE',
      totalFxAmt: 2666544.59,
      totalEquvAmt: 18166,
      totalProvProfit: 3099,
      txnCount: 177,
      custType: 'I',
    ),
    REM7Model(
      branchDescription: 'HEAD OFFICE',
      totalFxAmt: 2180665.0,
      totalEquvAmt: 8578,
      totalProvProfit: 1718,
      txnCount: 97,
      custType: 'C',
    ),
    REM7Model(
      branchDescription: 'MALIYA',
      totalFxAmt: 180665.0,
      totalEquvAmt: 1578,
      totalProvProfit: 718,
      txnCount: 63,
      custType: 'I',
    ),
  ];
}
