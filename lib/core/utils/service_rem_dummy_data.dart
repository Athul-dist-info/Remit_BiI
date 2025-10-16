import 'package:flutter/material.dart';
import 'package:remit_bi/core/constants.dart';
import 'package:remit_bi/model/rem1_model.dart';

class ServiceRemDummyData {
  static DateTime fromDate = DateTime(2022, 1, 1);
  static DateTime toDate = DateTime(2022, 3, 31);
  static List<String> legendItems = ['RTB', 'CASH'];

  static List<Map<String, Color>> getServiceColors() {
    return legendItems.map((category) {
      return {category: Constants.serviceColors[legendItems.indexOf(category)]};
    }).toList();
  }

  static List<REM1model> remittanceData = [
    // January
    REM1model(
      category: 'RTB',
      monthNum: 1,
      monthName: 'Jan',
      txnCount: 1600,
      equvamt: 25600.50,
      provprofit: 850.25,
      year: '2022',
    ),
    REM1model(
      category: 'CASH',
      monthNum: 1,
      monthName: 'Jan',
      txnCount: 2900,
      equvamt: 48900.75,
      provprofit: 1245.80,
      year: '2022',
    ),

    // February
    REM1model(
      category: 'RTB',
      monthNum: 2,
      monthName: 'Feb',
      txnCount: 4500,
      equvamt: 67800.25,
      provprofit: 1890.40,
      year: '2022',
    ),

    // March
    REM1model(
      category: 'RTB',
      monthNum: 3,
      monthName: 'Mar',
      txnCount: 5700,
      equvamt: 89450.80,
      provprofit: 2456.75,
      year: '2022',
    ),
  ];
}
