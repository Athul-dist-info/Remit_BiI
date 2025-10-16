abstract class PieChartDataModel {
  String get categoryKey; // For legend and grouping
  double get valueKey; // For pie slice value
}

class REM1PieData implements PieChartDataModel {
  final dynamic originalModel; // REM1model
  REM1PieData(this.originalModel);

  @override
  String get categoryKey => originalModel.monthName;

  @override
  double get valueKey => originalModel.txnCount.toDouble();
}

class REM2PieData implements PieChartDataModel {
  final dynamic originalModel; // REM2Model
  REM2PieData(this.originalModel);

  @override
  String get categoryKey => originalModel.country;

  @override
  double get valueKey => originalModel.txnCount.toDouble();
}

class REM3PieData implements PieChartDataModel {
  final dynamic originalModel; // REM3model
  REM3PieData(this.originalModel);

  @override
  String get categoryKey => originalModel.organisationDescription;

  @override
  double get valueKey => originalModel.txnCount.toDouble();
}

class REM4PieData implements PieChartDataModel {
  final dynamic originalModel; // REM4Model
  REM4PieData(this.originalModel);

  @override
  String get categoryKey => originalModel.curCode;

  @override
  double get valueKey => originalModel.totalFxAmt.toDouble();
}

class REM5PieData implements PieChartDataModel {
  final dynamic originalModel; // REM5Model
  REM5PieData(this.originalModel);

  @override
  String get categoryKey => originalModel.nationality;

  @override
  double get valueKey => originalModel.txnCount.toDouble();
}

class REM6PieData implements PieChartDataModel {
  final dynamic originalModel; // REM6Model
  REM6PieData(this.originalModel);

  @override
  String get categoryKey => originalModel.branchDescription;

  @override
  double get valueKey => originalModel.txnCount.toDouble();
}

class REM7PieData implements PieChartDataModel {
  final dynamic originalModel; // REM7Model
  REM7PieData(this.originalModel);

  @override
  String get categoryKey => originalModel.custType;

  @override
  double get valueKey => originalModel.txnCount.toDouble();
}
