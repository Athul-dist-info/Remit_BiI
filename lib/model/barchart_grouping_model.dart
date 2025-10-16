abstract class ChartDataModel {
  String get groupingKey; // For Y-axis
  String get categoryKey; // For legend
  double get valueKey; // For bar length
}

class REM1ChartData implements ChartDataModel {
  final dynamic originalModel; // REM1model

  REM1ChartData(this.originalModel);

  @override
  String get groupingKey => '${originalModel.monthName} ${originalModel.year}';

  @override
  String get categoryKey => originalModel.category;

  @override
  double get valueKey => originalModel.txnCount.toDouble();
}

class REM2ChartData implements ChartDataModel {
  final dynamic originalModel; // REM2Model

  REM2ChartData(this.originalModel);

  @override
  String get groupingKey => originalModel.country;

  @override
  String get categoryKey => originalModel.branch;

  @override
  double get valueKey => originalModel.txnCount.toDouble();
}

class REM3ChartData implements ChartDataModel {
  final dynamic originalModel; // REM3model

  REM3ChartData(this.originalModel);

  @override
  String get groupingKey => originalModel.organisationDescription;

  @override
  String get categoryKey => originalModel.branchDescription;

  @override
  double get valueKey => originalModel.txnCount.toDouble();
}

class REM4ChartData implements ChartDataModel {
  final dynamic originalModel; // REM4Model

  REM4ChartData(this.originalModel);

  @override
  String get groupingKey => originalModel.curCode;

  @override
  String get categoryKey => originalModel.branchDescription;

  @override
  double get valueKey => originalModel.totalFxAmt.toDouble();
}

class REM7ChartData implements ChartDataModel {
  final dynamic originalModel; // REM7Model

  REM7ChartData(this.originalModel);

  @override
  String get groupingKey => originalModel.custType;

  @override
  String get categoryKey => originalModel.branchDescription;

  @override
  double get valueKey => originalModel.txnCount.toDouble();
}
