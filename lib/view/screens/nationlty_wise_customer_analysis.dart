import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remit_bi/controller/remittance_controller.dart';
import 'package:remit_bi/core/chart_formater.dart';
import 'package:remit_bi/model/piechart_grouping_model.dart';
import 'package:remit_bi/model/rem5_model.dart';
import 'package:remit_bi/view/widgets/custom_pie_chart.dart';
import 'package:remit_bi/view/widgets/date_filter_widget.dart';
import 'package:remit_bi/view/widgets/loading_indicator.dart';
import 'package:remit_bi/view/widgets/vertical_bar_graph.dart';

class NationalityWiseCustomerAnalysis extends StatefulWidget {
  const NationalityWiseCustomerAnalysis({
    super.key,
    required this.title,
    required this.analysisCode,
  });

  final String title;
  final String analysisCode;

  @override
  State<NationalityWiseCustomerAnalysis> createState() =>
      _NationalityWiseCustomerAnalysisState();
}

class _NationalityWiseCustomerAnalysisState
    extends State<NationalityWiseCustomerAnalysis> {
  final remittanceController = Get.find<RemittanceController>();
  DateTime fromDate = DateTime(2020, 1, 1);
  DateTime toDate = DateTime(2022, 12, 31);
  List<REM5model> remittanceData = [];
  List<String> legendItemsForPie = [];
  int graphValue = 1;
  bool isLoading = false;
  String errorMessage = '';
  DateRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();

    loadRemittanceData();
  }

  Future<void> loadRemittanceData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    DateTime fdate = _selectedDateRange?.startDate ?? fromDate;
    DateTime tdate = _selectedDateRange?.endDate ?? toDate;

    try {
      final responseData = await remittanceController
          .getNationalityWiseCustomerAnalysis(
            fromDate:
                '${fdate.year}-${fdate.month.toString().padLeft(2, '0')}-01',
            toDate:
                '${tdate.year}-${tdate.month.toString().padLeft(2, '0')}-${tdate.day}',
          );

      legendItemsForPie =
          responseData.map((e) => e.nationality ?? 'Unknown').toSet().toList();

      setState(() {
        remittanceData = responseData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 38, 99, 205),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Text(
              'Code: ${widget.analysisCode}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DateFilterDropdown(
              onDateRangeSelected: (dateRange) {
                _selectedDateRange = dateRange;

                debugPrint('Selected date range: $dateRange');
                loadRemittanceData();
              },
            ),

            SizedBox(height: 20),

            // Display selected date range
            if (_selectedDateRange != null)
              Text('$_selectedDateRange', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),

            // Chart Section
            Expanded(
              child: Container(
                // padding: EdgeInsets.all(16),
                child:
                    isLoading
                        ? Center(child: LoadingIndicator())
                        : errorMessage.isNotEmpty
                        ? Center(child: Text('Error: $errorMessage'))
                        : remittanceData.isEmpty
                        ? Center(child: Text('No data available'))
                        : SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  _buildChartRadioButton(name: 'Bar', value: 1),
                                  _buildChartRadioButton(name: 'Pie', value: 2),
                                ],
                              ),
                              SizedBox(height: 20),
                              graphValue == 1
                                  ? VerticalBarGraph(
                                    chartData:
                                        remittanceData.map((model) {
                                          return model.toBarChartData(
                                            labelExtractor:
                                                (model) =>
                                                    model.nationality ??
                                                    'Unknown',
                                            valueExtractor:
                                                (model) =>
                                                    model.txnCount.toDouble(),
                                          );
                                        }).toList(),
                                    xAxisLabel: 'Nationality',
                                    yAxisLabel: 'No of Trans',
                                    valueFormatter:
                                        ChartFormatters.formatToBillion,
                                  )
                                  : CustomPieChart(
                                    chartData:
                                        remittanceData
                                            .map((model) => REM5PieData(model))
                                            .toList(),
                                    serviceColors: remittanceController
                                        .getServiceColors(legendItemsForPie),
                                    valueLabel: 'transactions',
                                  ),
                            ],
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildChartRadioButton({required String name, required int value}) {
    return Row(
      children: [
        Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        Radio(
          value: value,
          groupValue: graphValue,
          onChanged: (val) {
            setState(() {
              graphValue = value;
            });
          },
        ),
      ],
    );
  }
}
