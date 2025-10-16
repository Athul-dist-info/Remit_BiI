// REM5: Nationality wise customers
import 'package:remit_bi/view/widgets/vertical_bar_graph.dart';

class REM5model {
  final String? nationality;
  final double totalFxAmt;
  final double totalEquvAmt;
  final double totalProvProfit;
  final int txnCount;

  REM5model({
    this.nationality,
    required this.totalFxAmt,
    required this.totalEquvAmt,
    required this.totalProvProfit,
    required this.txnCount,
  });

  factory REM5model.fromJson(Map<String, dynamic> json) {
    return REM5model(
      nationality: json['NATIONALITY'] ?? '',
      totalFxAmt: (json['TOTAL_FXAMT'] ?? 0).toDouble(),
      totalEquvAmt: (json['TOTAL_EQUVAMT'] ?? 0).toDouble(),
      totalProvProfit: (json['TOTAL_PROVPROFIT'] ?? 0).toDouble(),
      txnCount: (json['TXN_COUNT'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NATIONALITY': nationality,
      'TOTAL_FXAMT': totalFxAmt,
      'TOTAL_EQUVAMT': totalEquvAmt,
      'TOTAL_PROVPROFIT': totalProvProfit,
      'TXN_COUNT': txnCount,
    };
  }
}

// Extension method to convert your REM5model to BarChartDataModel
extension REM5ModelExtension on REM5model {
  BarChartDataModel toBarChartData({
    required String Function(REM5model) labelExtractor,
    required double Function(REM5model) valueExtractor,
  }) {
    return BarChartDataModel(
      label: labelExtractor(this),
      value: valueExtractor(this),
    );
  }
}
