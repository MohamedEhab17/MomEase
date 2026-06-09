class CryAnalysis {
  final int cryId;
  final String audioUrl;
  final String result;
  final double confidence;
  final String advice;
  final int childId;
  final DateTime createdAt;
  final Map<String, double>? allScores;

  const CryAnalysis({
    required this.cryId,
    required this.audioUrl,
    required this.result,
    required this.confidence,
    required this.advice,
    required this.childId,
    required this.createdAt,
    this.allScores,
  });
}
