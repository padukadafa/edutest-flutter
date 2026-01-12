import 'package:equatable/equatable.dart';

class MLPrediction extends Equatable {
  final String predictedStyle;
  final String styleName;
  final double confidence;
  final Map<String, double> probabilities;
  final List<String> recommendations;
  final DateTime timestamp;

  const MLPrediction({
    required this.predictedStyle,
    required this.styleName,
    required this.confidence,
    required this.probabilities,
    required this.recommendations,
    required this.timestamp,
  });

  String get styleIcon {
    switch (predictedStyle) {
      case 'V':
        return '👁️';
      case 'A':
        return '👂';
      case 'R':
        return '📖';
      case 'K':
        return '✋';
      default:
        return '❓';
    }
  }

  String get confidencePercentage {
    return '${(confidence * 100).toStringAsFixed(1)}%';
  }

  bool get isHighConfidence => confidence >= 0.7;

  @override
  List<Object?> get props => [
    predictedStyle,
    styleName,
    confidence,
    probabilities,
    recommendations,
    timestamp,
  ];
}
