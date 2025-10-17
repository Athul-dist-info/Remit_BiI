import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remit_bi/controller/remittance_controller.dart';
import 'package:remit_bi/core/chart_formater.dart';
import 'package:remit_bi/core/utils/corp_branch_rem_data.dart';
import 'package:remit_bi/core/utils/corp_individual_rem_data.dart';
import 'package:remit_bi/core/utils/country_branch_rem_data.dart';
import 'package:remit_bi/core/utils/foreign_cur_sale_data.dart';
import 'package:remit_bi/core/utils/nationlty_customers_data.dart';
import 'package:remit_bi/core/utils/new_retained_cust_data.dart';
import 'package:remit_bi/core/utils/service_rem_dummy_data.dart';
import 'package:remit_bi/model/barchart_grouping_model.dart';
import 'package:remit_bi/model/piechart_grouping_model.dart';
import 'package:remit_bi/model/rem5_model.dart';
import 'package:remit_bi/view/screens/corp_branch_wise_rem_analysis.dart';
import 'package:remit_bi/view/screens/corp_individual_branch_wise_analysis.dart';
import 'package:remit_bi/view/screens/country_branch_wise_rem_analysis.dart';
import 'package:remit_bi/view/screens/foreign_cur_sale_wise_analysis.dart';
import 'package:remit_bi/view/screens/nationlty_wise_customer_analysis.dart';
import 'package:remit_bi/view/screens/new_customers_analysis.dart';
import 'package:remit_bi/view/screens/service_wise_rem_analysis.dart';
import 'package:remit_bi/view/widgets/custom_horizontal_bar_graph.dart';
import 'package:remit_bi/view/widgets/custom_pie_chart.dart';
import 'package:remit_bi/view/widgets/loading_indicator.dart';
import 'package:remit_bi/view/widgets/stacked_vertical_bar_graph.dart';
import 'package:remit_bi/view/widgets/vertical_bar_graph.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final remContrler = Get.put(RemittanceController());

  @override
  void initState() {
    super.initState();
    remContrler.getAllAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    final allAnalysisCards = {
      "REM1": _buildAnalysisCard(
        title: 'Product Wise Remittance Analysis',
        code: 'REM1',
        chart: CustomHorizontalBarChart(
          chartData:
              ServiceRemDummyData.remittanceData
                  .map((model) => REM1ChartData(model))
                  .toList(),
          // fromDate: ServiceRemDummyData.fromDate,
          // toDate: ServiceRemDummyData.toDate,
          serviceColors: ServiceRemDummyData.getServiceColors(),
          legendItems: ServiceRemDummyData.legendItems,
          yAxisLabel: 'Months',
          xAxisLabel: 'Transaction Count',
          sortByMonth: true,
        ),
        ontap: () {
          Get.to(
            () => ServiceWiseRemittanceAnalysis(
              title: 'Product Wise Remittance Analysis',
              analysisCode: 'REM1',
            ),
          );
        },
      ),
      "REM2": _buildAnalysisCard(
        from: 100,
        title: 'Country&Branch Wise Remittance Analysis',
        code: 'REM2',
        chart: Transform.scale(
          scaleX: 0.9,
          child: StackedVerticalBarGraph(
            chartHeight: 180,
            chartData:
                CountryBranchRemData.remittanceData
                    .map((model) => REM2ChartData(model))
                    .toList(),
            serviceColors: CountryBranchRemData.getServiceColors(),
            legendItems: CountryBranchRemData.legendItems,
            valueFormatter: ChartFormatters.formatInteger,
            xAxisLabel: 'Country',
            yAxisLabel: 'No of Trans',
          ),
        ),
        ontap: () {
          Get.to(
            () => CountryBranchWiseRemAnalysis(
              title: 'Country&Branch Wise Remittance Analysis',
              analysisCode: 'REM2',
            ),
          );
        },
      ),
      "REM3": _buildAnalysisCard(
        from: 150,
        title: 'Corp/Branch Wise Remittance Analysis',
        code: 'REM3',
        chart: CustomHorizontalBarChart(
          chartData:
              CorpBranchRemData.remittanceData
                  .map((model) => REM3ChartData(model))
                  .toList(),
          // fromDate: ServiceRemDummyData.fromDate,
          // toDate: ServiceRemDummyData.toDate,
          serviceColors: CorpBranchRemData.getServiceColors(),
          legendItems: CorpBranchRemData.legendItems,
          yAxisLabel: 'Bank Name',
          xAxisLabel: 'No of Trans',
        ),
        ontap: () {
          Get.to(
            () => CorpBranchWiseRemAnalysis(
              title: 'Corp/Branch Wise Remittance Analysis',
              analysisCode: 'REM3',
            ),
          );
        },
      ),
      "REM4": _buildAnalysisCard(
        from: 200,
        title: 'Foreign Currency Sale Branch wise Remittance Analysis',
        code: 'REM4',
        chart: Transform.scale(
          scaleX: 0.9,
          child: StackedVerticalBarGraph(
            chartHeight: 150,
            chartData:
                ForeignCurSaleData.remittanceData
                    .map((model) => REM4ChartData(model))
                    .toList(),
            serviceColors: ForeignCurSaleData.getServiceColors(),
            legendItems: ForeignCurSaleData.legendItems,
            valueFormatter: ChartFormatters.formatToBillion,
            xAxisLabel: 'Currency',
            yAxisLabel: 'FxAmount',
          ),
        ),
        ontap: () {
          Get.to(
            () => ForeignCurSaleWiseAnalysis(
              title: 'Foreign Currency Sale Branch wise Remittance Analysis',
              analysisCode: 'REM4',
            ),
          );
        },
      ),
      "REM5": _buildAnalysisCard(
        from: 250,
        title: 'Nationality wise customers',
        code: 'REM5',
        chart: Transform.scale(
          scaleX: 0.9,
          child: VerticalBarGraph(
            chartHeight: 200,
            chartData:
                NationalityCustomersData.remittanceData.map((model) {
                  return model.toBarChartData(
                    labelExtractor: (model) => model.nationality ?? 'Unknown',
                    valueExtractor: (model) => model.txnCount.toDouble(),
                  );
                }).toList(),
            xAxisLabel: 'Nationality',
            yAxisLabel: 'No of Trans',
            valueFormatter: ChartFormatters.formatToBillion,
          ),
        ),
        ontap: () {
          Get.to(
            () => NationalityWiseCustomerAnalysis(
              title: 'Nationality wise customers',
              analysisCode: 'REM5',
            ),
          );
        },
      ),
      "REM6": _buildAnalysisCard(
        from: 300,
        title: 'New Retained customers',
        code: 'REM6',
        chart: CustomPieChart(
          chartHeight: 200,
          useWideLayout: true,
          chartData:
              NewRetainedCustomersData.remittanceData
                  .map((model) => REM6PieData(model))
                  .toList(),
          serviceColors: NewRetainedCustomersData.getServiceColors(),
        ),
        ontap: () {
          Get.to(
            () => NewRetainedCustomersAnalysis(
              title: 'New Retained customers',
              analysisCode: 'REM6',
            ),
          );
        },
      ),
      "REM7": _buildAnalysisCard(
        from: 350,
        title: 'Corporate/Individual Branch Wise',
        code: 'REM7',
        chart: Transform.scale(
          scale: 0.9,
          child: StackedVerticalBarGraph(
            chartHeight: 180,
            chartData:
                CorpIndividualRemData.remittanceData
                    .map((model) => REM7ChartData(model))
                    .toList(),
            serviceColors: CorpIndividualRemData.getServiceColors(),
            legendItems: CorpIndividualRemData.legendItems,
            valueFormatter: ChartFormatters.formatToBillion,
            xAxisLabel: 'Branch',
            yAxisLabel: 'No of Trans',
          ),
        ),
        ontap: () {
          Get.to(
            () => CorpIndividualBranchWiseAnalysis(
              title: 'Corporate/Individual Branch Wise',
              analysisCode: 'REM7',
            ),
          );
        },
      ),
    };
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
              child: TextFormField(
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  hintText: 'Search',
                  prefixIcon: Icon(CupertinoIcons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => remContrler.searchQuery.value = value,
              ),
            ),

            Obx(() {
              final filteredAnalysisCards =
                  remContrler.filteredAnalysisList
                      .map((code) => allAnalysisCards[code.code])
                      .whereType<Widget>()
                      .toList();
              return remContrler.isLoading.isTrue
                  ? Center(child: LoadingIndicator())
                  : remContrler.filteredAnalysisList.isEmpty
                  ? Center(child: Text('No Data Found'))
                  : Column(
                    children: List.generate(filteredAnalysisCards.length, (
                      index,
                    ) {
                      final card = filteredAnalysisCards[index];

                      return card;
                    }),
                  );
            }),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 38, 99, 205),
      actionsPadding: EdgeInsets.only(right: 10),
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.currency_exchange,
            color: Color.fromARGB(255, 38, 99, 205),
          ),
        ),
      ),
      title: Text(
        'REMIT BI',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      // actions: [
      //   CircleAvatar(
      //     backgroundColor: Colors.white,
      //     child: Icon(
      //       Icons.person_outline,
      //       color: Color.fromARGB(255, 38, 99, 205),
      //     ),
      //   ),
      // ],
    );
  }

  FadeInUp _buildAnalysisCard({
    required String title,
    required String code,
    required Widget chart,
    VoidCallback? ontap,
    double from = 50,
  }) {
    return FadeInUp(
      from: from,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('Code: $code', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                // Blurred chart
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: chart,
                ),

                InkWell(
                  onTap: ontap,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 38, 99, 205).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5,
                      children: [
                        Text(
                          'Click to view',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.crop_free_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
