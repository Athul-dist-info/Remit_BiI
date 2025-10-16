import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remit_bi/core/constants.dart';
import 'package:remit_bi/model/analysis_model.dart';
import 'package:remit_bi/model/rem1_model.dart';
import 'package:remit_bi/model/rem2_model.dart';
import 'package:remit_bi/model/rem3_model.dart';
import 'package:remit_bi/model/rem4_model.dart';
import 'package:remit_bi/model/rem5_model.dart';
import 'package:remit_bi/model/rem6_model.dart';
import 'package:remit_bi/model/rem7_model.dart';
import 'package:remit_bi/service/api_constants.dart';
import 'package:remit_bi/service/api_service.dart';

class RemittanceController extends GetxController {
  RxBool isLoading = false.obs;
  List<AnalysisModel> analysisList = [];
  RxList<AnalysisModel> filteredAnalysisList = <AnalysisModel>[].obs;

  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Listen for changes in searchQuery
    debounce(
      searchQuery,
      (_) => applyFilter(),
      time: const Duration(milliseconds: 300),
    );
  }

  void applyFilter() {
    final query = searchQuery.value.toLowerCase();

    if (query.isEmpty) {
      filteredAnalysisList.assignAll(analysisList);
    } else {
      filteredAnalysisList.assignAll(
        analysisList.where((analysis) {
          final titleMatch = analysis.analysisType.toLowerCase().contains(
            query,
          );
          final tagsMatch = analysis.tags.any(
            (tag) => tag.toLowerCase().contains(query),
          );
          return titleMatch || tagsMatch;
        }).toList(),
      );
    }
  }

  Future<void> getAllAnalysis() async {
    isLoading.value = true;
    analysisList = await RemittanceApiService.getAllAnalysis();
    filteredAnalysisList.assignAll(analysisList);
    isLoading.value = false;
  }

  List<Map<String, Color>> getServiceColors(List<String> legendItems) {
    return legendItems.map((t) {
      return {t: Constants.serviceColors[legendItems.indexOf(t)]};
    }).toList();
  }

  Future<List<REM1model>> getServiceWiseRemittanceAnalysis({
    required String fromDate,
    required String toDate,
  }) async {
    final response = await RemittanceApiService.apiPost(
      apiEndpoint: ApiEndPoints.serviceWiseRemittanceAnalysis,
      requestBody: {
        "InputBody": {
          "RootNode": {"FromDate": fromDate, "ToDate": toDate},
        },
      },
    );
    return (response['Data'] as List<dynamic>?)
            ?.map((item) => REM1model.fromJson(item))
            .toList() ??
        [];
  }

  Future<List<REM2Model>> getCountryBranchWiseRemittanceAnalysis({
    required String fromDate,
    required String toDate,
  }) async {
    final response = await RemittanceApiService.apiPost(
      apiEndpoint: ApiEndPoints.countryBranchWiseRemAnalysis,
      requestBody: {
        "InputBody": {
          "RootNode": {"FromDate": fromDate, "ToDate": toDate},
        },
      },
    );
    return (response['Data'] as List<dynamic>?)
            ?.map((item) => REM2Model.fromJson(item))
            .toList() ??
        [];
  }

  Future<List<REM3model>> getCorpBranchWiseRemittanceAnalysis({
    required String fromDate,
    required String toDate,
  }) async {
    final response = await RemittanceApiService.apiPost(
      apiEndpoint: ApiEndPoints.corpBranchWiseRemAnalysis,
      requestBody: {
        "InputBody": {
          "RootNode": {"FromDate": fromDate, "ToDate": toDate},
        },
      },
    );
    return (response['Data'] as List<dynamic>?)
            ?.map((item) => REM3model.fromJson(item))
            .toList() ??
        [];
  }

  Future<List<REM4model>> getForeignCurrencySaleRemittanceAnalysis({
    required String fromDate,
    required String toDate,
  }) async {
    final response = await RemittanceApiService.apiPost(
      apiEndpoint: ApiEndPoints.foreignCurSaleRemAnalysis,
      requestBody: {
        "InputBody": {
          "RootNode": {"FromDate": fromDate, "ToDate": toDate},
        },
      },
    );
    return (response['Data'] as List<dynamic>?)
            ?.map((item) => REM4model.fromJson(item))
            .toList() ??
        [];
  }

  Future<List<REM5model>> getNationalityWiseCustomerAnalysis({
    required String fromDate,
    required String toDate,
  }) async {
    final response = await RemittanceApiService.apiPost(
      apiEndpoint: ApiEndPoints.nationalityWiseCustomerAnalysis,
      requestBody: {
        "InputBody": {
          "RootNode": {"FromDate": fromDate, "ToDate": toDate},
        },
      },
    );
    return (response['DATA'] as List<dynamic>?)
            ?.map((item) => REM5model.fromJson(item))
            .toList() ??
        [];
  }

  Future<List<REM6Model>> getNewRetainedCustomersAnalysis({
    required String fromDate,
    required String toDate,
  }) async {
    final response = await RemittanceApiService.apiPost(
      apiEndpoint: ApiEndPoints.newRetainedCustomersAnalysis,
      requestBody: {
        "InputBody": {
          "RootNode": {"FromDate": fromDate, "ToDate": toDate},
        },
      },
    );
    return (response['DATA'] as List<dynamic>?)
            ?.map((item) => REM6Model.fromJson(item))
            .toList() ??
        [];
  }

  Future<List<REM7Model>> getCorpIndividualBranchAnalysis({
    required String fromDate,
    required String toDate,
  }) async {
    final response = await RemittanceApiService.apiPost(
      apiEndpoint: ApiEndPoints.corpIndividualAnalysis,
      requestBody: {
        "InputBody": {
          "RootNode": {"FromDate": fromDate, "ToDate": toDate},
        },
      },
    );
    return (response['Data'] as List<dynamic>?)
            ?.map((item) => REM7Model.fromJson(item))
            .toList() ??
        [];
  }
}
