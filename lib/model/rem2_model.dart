// REM2: Country&Branch Wise Remittance Transaction
class REM2Model {
  final double totalEqvAmt;
  final String branch;
  final String country;
  final double totalProvProfit;
  final int txnCount;

  REM2Model({
    required this.totalEqvAmt,
    required this.branch,
    required this.country,
    required this.totalProvProfit,
    required this.txnCount,
  });

  factory REM2Model.fromJson(Map<String, dynamic> json) {
    return REM2Model(
      totalEqvAmt: (json['TOTAL_EQVAMT'] ?? 0).toDouble(),
      branch: json['BRANCH'] ?? '',
      country: json['COUNTRY'] ?? '',
      totalProvProfit: (json['TOTAL_PROVPROFIT'] ?? 0).toDouble(),
      txnCount: json['TXN_COUNT'] ?? 0,
    );
  }
}
