import '../../domain/entities/ml_prediction.dart';

class MLPredictionModel extends MLPrediction {
  const MLPredictionModel({
    required super.predictedStyle,
    required super.styleName,
    required super.confidence,
    required super.probabilities,
    required super.recommendations,
    required super.timestamp,
  });

  factory MLPredictionModel.fromJson(Map<String, dynamic> json) {
    return MLPredictionModel(
      predictedStyle: json['predicted_style'] as String,
      styleName: json['style_name'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      probabilities: Map<String, double>.from(
        (json['probabilities'] as Map).map(
          (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
        ),
      ),
      recommendations: List<String>.from(json['recommendations'] as List),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'predicted_style': predictedStyle,
      'style_name': styleName,
      'confidence': confidence,
      'probabilities': probabilities,
      'recommendations': recommendations,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Copy with method untuk immutability
  MLPredictionModel copyWith({
    String? predictedStyle,
    String? styleName,
    double? confidence,
    Map<String, double>? probabilities,
    List<String>? recommendations,
    DateTime? timestamp,
  }) {
    return MLPredictionModel(
      predictedStyle: predictedStyle ?? this.predictedStyle,
      styleName: styleName ?? this.styleName,
      confidence: confidence ?? this.confidence,
      probabilities: probabilities ?? this.probabilities,
      recommendations: recommendations ?? this.recommendations,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
