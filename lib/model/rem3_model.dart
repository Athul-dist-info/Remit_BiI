// REM3: CorpBranch Wise Remittance Transaction
class REM3model {
  final String branchDescription;
  final String organisationDescription;
  final double totalProvprofit;
  final int txnCount;
  final double totalEquvamt;
  final double totalFxamt;

  REM3model({
    required this.branchDescription,
    required this.organisationDescription,
    required this.totalProvprofit,
    required this.txnCount,
    required this.totalEquvamt,
    required this.totalFxamt,
  });

  factory REM3model.fromJson(Map<String, dynamic> json) {
    return REM3model(
      branchDescription: json['BRANCH_DESCRIPTION'] ?? '',
      organisationDescription: json['ORGANISATION_DESCRIPTION'] ?? '',
      totalProvprofit: (json['TOTAL_PROVPROFIT'] ?? 0).toDouble(),
      txnCount: (json['TXN_COUNT'] ?? 0).toInt(),
      totalEquvamt: (json['TOTAL_EQUVAMT'] ?? 0).toDouble(),
      totalFxamt: (json['TOTAL_FXAMT'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BRANCH_DESCRIPTION': branchDescription,
      'ORGANISATION_DESCRIPTION': organisationDescription,
      'TOTAL_PROVPROFIT': totalProvprofit,
      'TXN_COUNT': txnCount,
      'TOTAL_EQUVAMT': totalEquvamt,
      'TOTAL_FXAMT': totalFxamt,
    };
  }
}
