// REM4: Foreign Currency Sale Branch wise
class REM4model {
  final String branchDescription;
  final String curCode;
  final double totalFxAmt;
  final double totalEquvAmt;
  final double totalProfit;
  final int txnCount;

  REM4model({
    required this.branchDescription,
    required this.curCode,
    required this.totalFxAmt,
    required this.totalEquvAmt,
    required this.totalProfit,
    required this.txnCount,
  });

  factory REM4model.fromJson(Map<String, dynamic> json) {
    return REM4model(
      branchDescription: json['BRANCH_DESCRIPTION'] ?? '',
      curCode: json['CURCODE'] ?? '',
      totalFxAmt: (json['TOTAL_FXAMT'] ?? 0).toDouble(),
      totalEquvAmt: (json['TOTAL_EQUVAMT'] ?? 0).toDouble(),
      totalProfit: (json['TOTAL_PROFIT'] ?? 0).toDouble(),
      txnCount: (json['TXN_COUNT'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BRANCH_DESCRIPTION': branchDescription,
      'CURCODE': curCode,
      'TOTAL_FXAMT': totalFxAmt,
      'TOTAL_EQUVAMT': totalEquvAmt,
      'TOTAL_PROFIT': totalProfit,
      'TXN_COUNT': txnCount,
    };
  }
}
