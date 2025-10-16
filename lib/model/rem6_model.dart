// REM6: New RetainedCustomers
import 'package:remit_bi/view/widgets/vertical_bar_graph.dart';

class REM6Model {
  final String branchDescription;
  final double totalFxAmt;
  final double totalEquvAmt;
  final double totalProvProfit;
  final int txnCount;
  final String customerGroup;

  REM6Model({
    required this.branchDescription,
    required this.totalFxAmt,
    required this.totalEquvAmt,
    required this.totalProvProfit,
    required this.txnCount,
    required this.customerGroup,
  });

  factory REM6Model.fromJson(Map<String, dynamic> json) {
    return REM6Model(
      branchDescription: json['BRANCH_DESCRIPTION'] ?? '',
      totalFxAmt: (json['TOTAL_FXAMT'] ?? 0).toDouble(),
      totalEquvAmt: (json['TOTAL_EQUVAMT'] ?? 0).toDouble(),
      totalProvProfit: (json['TOTAL_PROVPROFIT'] ?? 0).toDouble(),
      txnCount: (json['TXN_COUNT'] ?? 0).toInt(),
      customerGroup: json['CUSTOMER_GROUP'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BRANCH_DESCRIPTION': branchDescription,
      'TOTAL_FXAMT': totalFxAmt,
      'TOTAL_EQUVAMT': totalEquvAmt,
      'TOTAL_PROVPROFIT': totalProvProfit,
      'TXN_COUNT': txnCount,
      'CUSTOMER_GROUP': customerGroup,
    };
  }
}

// Extension method to convert your REM6Model to BarChartDataModel
extension REM5ModelExtension on REM6Model {
  BarChartDataModel toBarChartData({
    required String Function(REM6Model) labelExtractor,
    required double Function(REM6Model) valueExtractor,
  }) {
    return BarChartDataModel(
      label: labelExtractor(this),
      value: valueExtractor(this),
    );
  }
}
