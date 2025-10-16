// REM7: Corporate Individual Branch Wise
class REM7Model {
  final String branchDescription;
  final String custType;
  final double totalFxAmt;
  final double totalEquvAmt;
  final double totalProvProfit;
  final int txnCount;

  REM7Model({
    required this.branchDescription,
    required this.custType,
    required this.totalFxAmt,
    required this.totalEquvAmt,
    required this.totalProvProfit,
    required this.txnCount,
  });

  factory REM7Model.fromJson(Map<String, dynamic> json) {
    return REM7Model(
      branchDescription: json['BRANCH_DESCRIPTION'] ?? '',
      custType: json['CUSTTYPE'] ?? '',
      totalFxAmt: double.tryParse(json['TOTAL_FXAMT'].toString()) ?? 0.0,
      totalEquvAmt: double.tryParse(json['TOTAL_EQUVAMT'].toString()) ?? 0.0,
      totalProvProfit:
          double.tryParse(json['TOTAL_PROVPROFIT'].toString()) ?? 0.0,
      txnCount: int.tryParse(json['TXN_COUNT'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BRANCH_DESCRIPTION': branchDescription,
      'CUSTTYPE': custType,
      'TOTAL_FXAMT': totalFxAmt.toString(),
      'TOTAL_EQUVAMT': totalEquvAmt.toString(),
      'TOTAL_PROVPROFIT': totalProvProfit.toString(),
      'TXN_COUNT': txnCount.toString(),
    };
  }
}
