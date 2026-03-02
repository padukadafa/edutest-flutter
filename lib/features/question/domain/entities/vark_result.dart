import '../../data/models/vark_question_model.dart';

class VarkResult {
  final Map<VarkType, int> scores;
  final List<LearningStyleResult> results;
  final VarkType dominantStyle;
  final int totalQuestions;

  const VarkResult({
    required this.scores,
    required this.results,
    required this.dominantStyle,
    required this.totalQuestions,
  });

  List<LearningStyleResult> get sortedResults {
    return List.from(results)..sort((a, b) => b.score.compareTo(a.score));
  }

  bool hasTie() {
    if (results.isEmpty) return false;
    final maxScore = results.first.score;
    return results.where((r) => r.score == maxScore).length > 1;
  }

  List<VarkType> getTiedStyles() {
    if (results.isEmpty) return [];
    final maxScore = results.first.score;
    return results
        .where((r) => r.score == maxScore)
        .map((r) => r.type)
        .toList();
  }
}
