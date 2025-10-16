// REM1: Service Wise Remittance Transaction
class REM1model {
  final String category;
  final double monthNum;
  final String monthName;
  final double txnCount;
  final double equvamt;
  final double? provprofit;
  final String year;

  REM1model({
    required this.category,
    required this.monthNum,
    required this.monthName,
    required this.txnCount,
    required this.equvamt,
    this.provprofit,
    required this.year,
  });

  factory REM1model.fromJson(Map<String, dynamic> json) {
    return REM1model(
      category: json['category'] ?? '',
      monthNum: (json['month_num'] ?? 0).toDouble(),
      monthName: json['month_name'] ?? '',
      txnCount: (json['txn_count'] ?? 0).toDouble(),
      equvamt: (json['equvamt'] ?? 0).toDouble(),
      provprofit: json['provprofit']?.toDouble(),
      year: json['year'].toString().replaceAll(".0", ""),
    );
  }
}
