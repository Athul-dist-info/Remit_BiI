import 'package:dio/dio.dart';
import 'package:remit_bi/model/analysis_model.dart';
import 'package:remit_bi/service/api_constants.dart';

class RemittanceApiService {
  static Future<List<AnalysisModel>> getAllAnalysis() async {
    final res = await apiPost(apiEndpoint: ApiEndPoints.getAllAnalysis);
    return res['StatusCode'] == 'SCFG001' && res['OutputBody']?['data'] != null
        ? (res['OutputBody']['data'] as List<dynamic>)
            .map((e) => AnalysisModel.fromJson(e))
            .toList()
        : [];
  }

  static dynamic apiPost({
    required String apiEndpoint,
    Map<String, dynamic>? requestBody,
  }) async {
    final Dio dio = Dio();

    try {
      final response = await dio.post(
        baseUrl + apiEndpoint,
        data: requestBody,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network Error: ${e.message}');
      }
      throw Exception('Error: $e');
    }
  }
}
