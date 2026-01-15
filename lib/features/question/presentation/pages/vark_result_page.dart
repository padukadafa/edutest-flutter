import 'package:edutest/features/question/data/models/vark_question_model.dart';
import 'package:edutest/features/question/domain/entities/ml_prediction.dart';
import 'package:flutter/material.dart';

class VarkResultPage extends StatelessWidget {
  final VarkQuizResult result;
  final MLPrediction? prediction;

  const VarkResultPage({super.key, required this.result, this.prediction});

  VarkType _getVarkTypeFromLetter(String letter) {
    switch (letter) {
      case 'V':
        return VarkType.visual;
      case 'A':
        return VarkType.auditory;
      case 'R':
        return VarkType.readWrite;
      case 'K':
        return VarkType.kinesthetic;
      default:
        return VarkType.visual;
    }
  }

  bool get _isMLBased => prediction != null;

  VarkType get _dominantStyle {
    if (_isMLBased) {
      return _getVarkTypeFromLetter(prediction!.predictedStyle);
    }
    return result.dominantStyle;
  }

  String get _confidenceText {
    if (_isMLBased) {
      return prediction!.confidencePercentage;
    }
    return result.results
        .firstWhere((r) => r.type == result.dominantStyle)
        .percentage
        .toStringAsFixed(0);
  }

  VarkQuizResult get _effectiveResult {
    if (!_isMLBased) return result;

    final mappedResults = prediction!.probabilities.entries.map((entry) {
      return LearningStyleResult(
        type: _getVarkTypeFromLetter(entry.key),
        score: 0,
        percentage: entry.value * 100,
      );
    }).toList()..sort((a, b) => b.percentage.compareTo(a.percentage));

    return VarkQuizResult(
      results: mappedResults,
      scores: const {},
      dominantStyle: mappedResults.first.type,
      totalQuestions: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil VARK'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDominantStyleCard(),
            const SizedBox(height: 24),
            if (_isMLBased) _buildMLConfidenceCard(),
            const SizedBox(height: 24),
            _buildScoreBreakdown(_effectiveResult),
          ],
        ),
      ),
    );
  }

  Widget _buildDominantStyleCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.orange.shade300],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(_dominantStyle.icon, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          Text(
            _isMLBased ? 'Prediksi ML' : 'Gaya Belajar Dominan',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            _dominantStyle.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_confidenceText}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMLConfidenceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.green),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Machine Learning Prediction',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Text('Confidence: ${prediction!.confidencePercentage}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBreakdown(VarkQuizResult data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isMLBased ? 'Probabilitas ML' : 'Rincian Skor',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...data.sortedResults.map((r) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${r.type.displayName} - ${r.percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: r.percentage / 100,
                    minHeight: 8,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
