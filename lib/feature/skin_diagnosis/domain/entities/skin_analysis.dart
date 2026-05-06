class SkinAnalysis {
  final int skinAnalysisId;
  final String imageUrl;
  final String result;
  final String diseaseName;
  final String advice;
  final double confidence;
  final DateTime createdAt;

  const SkinAnalysis({
    required this.skinAnalysisId,
    required this.imageUrl,
    required this.result,
    required this.diseaseName,
    required this.advice,
    required this.confidence,
    required this.createdAt,
  });
}
