class AnalysisModel {
  final String code;
  final String analysisType;
  final List<String> tags;

  AnalysisModel({
    required this.code,
    required this.analysisType,
    required this.tags,
  });

  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    return AnalysisModel(
      code: json['code'] ?? '',
      analysisType: json['analysisType'] ?? '',
      tags:
          (json['tags'] as String? ?? '')
              .split('\n')
              .map((e) => e.replaceAll('#', '').trim())
              .where((e) => e.isNotEmpty)
              .toList(),
    );
  }
}
