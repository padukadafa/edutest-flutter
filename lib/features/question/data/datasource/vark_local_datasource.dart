import '../models/vark_question_model.dart';
import '../entities/vark_result.dart';
import '../models/ml_prediction_model.dart';
import '../vark_questions.dart';
import '../../domain/entities/ml_prediction.dart';

abstract class VarkLocalDataSource {
  Future<List<VarkQuestion>> getQuestions();
  Future<VarkResult> calculateScores(Map<String, String> answers);
  Future<void> cachePrediction(MLPrediction prediction);
  Future<void> savePredictionToDatabase(MLPrediction prediction);
}

class VarkLocalDataSourceImpl implements VarkLocalDataSource {
  @override
  Future<List<VarkQuestion>> getQuestions() async {
    return VarkQuestions.questions;
  }

  @override
  Future<VarkResult> calculateScores(Map<String, String> answers) async {
    final scores = <String, int>{};

    for (final entry in answers.entries) {
      final questionId = int.tryParse(entry.key) ?? 0;
      final selectedType = entry.value;

      final question = VarkQuestions.questions.firstWhere(
        (q) => q.id == questionId,
        orElse: () =>
            VarkQuestion(id: 0, category: 'VARK', question: '', options: {}),
      );

      for (final optionEntry in question.options.entries) {
        if (optionEntry.value == selectedType) {
          final typeKey = optionEntry.key.letter;
          scores[typeKey] = (scores[typeKey] ?? 0) + 1;
          break;
        }
      }
    }

    final results = <VarkType, int>{};
    for (final type in VarkType.values) {
      results[type] = scores[type.letter] ?? 0;
    }

    final dominantStyle = results.entries
        .reduce((max, e) => e.value > max.value ? e : max)
        .key;

    return VarkResult(
      scores: results,
      results: results.entries.map((e) {
        final total = results.values.fold(0, (sum, v) => sum + v);
        final percentage = total > 0 ? (e.value / total) * 100.0 : 0.0;
        return LearningStyleResult(
          type: e.key,
          score: e.value,
          percentage: percentage,
        );
      }).toList(),
      dominantStyle: dominantStyle,
      totalQuestions: VarkQuestions.totalQuestions,
    );
  }

  @override
  Future<void> cachePrediction(MLPrediction prediction) async {
    // TODO: Implement caching if needed
  }

  @override
  Future<void> savePredictionToDatabase(MLPrediction prediction) async {
    // TODO: Implement database save if needed
  }
}
