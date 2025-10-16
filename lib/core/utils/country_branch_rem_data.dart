import 'package:flutter/material.dart';
import 'package:remit_bi/core/constants.dart';
import 'package:remit_bi/model/rem2_model.dart';

class CountryBranchRemData {
  static DateTime fromDate = DateTime(2022, 1, 1);
  static DateTime toDate = DateTime(2022, 3, 31);
  static List<String> legendItems = ['HEAD OFFICE', 'MALIYA', 'AL-RAYAN'];

  static List<Map<String, Color>> getServiceColors() {
    return legendItems.map((category) {
      return {category: Constants.serviceColors[legendItems.indexOf(category)]};
    }).toList();
  }

  static List<REM2Model> remittanceData = [
    REM2Model(
      branch: 'HEAD OFFICE',
      country: 'ALGERIA',
      totalEqvAmt: 292,
      totalProvProfit: 15,
      txnCount: 140,
    ),
    REM2Model(
      branch: 'HEAD OFFICE',
      country: 'DENMARK',
      totalEqvAmt: 7,
      totalProvProfit: 32,
      txnCount: 88,
    ),
    REM2Model(
      branch: 'HEAD OFFICE',
      country: 'INDIA',
      totalEqvAmt: 878,
      totalProvProfit: 450,
      txnCount: 60,
    ),
    REM2Model(
      branch: 'MALIYA',
      country: 'ALGERIA',
      totalEqvAmt: 120,
      totalProvProfit: 12,
      txnCount: 56,
    ),
    REM2Model(
      branch: 'MALIYA',
      country: 'INDIA',
      totalEqvAmt: 76,
      totalProvProfit: 33,
      txnCount: 223,
    ),
    REM2Model(
      branch: 'AL-RAYAN',
      country: 'INDIA',
      totalEqvAmt: 76,
      totalProvProfit: 33,
      txnCount: 223,
    ),
    REM2Model(
      branch: 'AL-RAYAN',
      country: 'DENMARK',
      totalEqvAmt: 700,
      totalProvProfit: 340,
      txnCount: 45,
    ),
    REM2Model(
      branch: 'HEAD OFFICE',
      country: 'FINLAND',
      totalEqvAmt: 292,
      totalProvProfit: 15,
      txnCount: 140,
    ),
    REM2Model(
      branch: 'HEAD OFFICE',
      country: 'NORWAY',
      totalEqvAmt: 878,
      totalProvProfit: 450,
      txnCount: 60,
    ),
    REM2Model(
      branch: 'MALIYA',
      country: 'FINLAND',
      totalEqvAmt: 120,
      totalProvProfit: 12,
      txnCount: 56,
    ),
    REM2Model(
      branch: 'MALIYA',
      country: 'NORWAY',
      totalEqvAmt: 76,
      totalProvProfit: 33,
      txnCount: 223,
    ),
    REM2Model(
      branch: 'HEAD OFFICE',
      country: 'FRANCE',
      totalEqvAmt: 700,
      totalProvProfit: 340,
      txnCount: 45,
    ),
  ];
}
