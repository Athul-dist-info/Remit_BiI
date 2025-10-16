import 'package:remit_bi/model/rem5_model.dart';

class NationalityCustomersData {
  static DateTime fromDate = DateTime(2022, 1, 1);
  static DateTime toDate = DateTime(2022, 3, 31);

  static List<REM5model> remittanceData = [
    REM5model(
      nationality: 'SRI LANKAN',
      totalFxAmt: 2500.0,
      totalEquvAmt: 20.66,
      totalProvProfit: 7.5,
      txnCount: 1,
    ),
    REM5model(
      nationality: 'INDIAN',
      totalFxAmt: 3841868.74,
      totalEquvAmt: 23280.317,
      totalProvProfit: 3519.904,
      txnCount: 260,
    ),
    REM5model(
      nationality: 'IRANIAN',
      totalFxAmt: 945887.0,
      totalEquvAmt: 3037.73,
      totalProvProfit: 1113.355,
      txnCount: 12,
    ),
    REM5model(
      nationality: 'KUWAITI',
      totalFxAmt: 56634.0,
      totalEquvAmt: 402.0,
      totalProvProfit: 169.902,
      txnCount: 2,
    ),
  ];
}
