import 'package:equatable/equatable.dart';

enum VarkTypeResult { visual, auditory, readWrite, kinesthetic }

extension VarkTypeResultExtension on VarkTypeResult {
  String get letter {
    switch (this) {
      case VarkTypeResult.visual:
        return 'V';
      case VarkTypeResult.auditory:
        return 'A';
      case VarkTypeResult.readWrite:
        return 'R';
      case VarkTypeResult.kinesthetic:
        return 'K';
    }
  }

  String get displayName {
    switch (this) {
      case VarkTypeResult.visual:
        return 'Visual';
      case VarkTypeResult.auditory:
        return 'Auditory';
      case VarkTypeResult.readWrite:
        return 'Read/Write';
      case VarkTypeResult.kinesthetic:
        return 'Kinesthetic';
    }
  }

  String get icon {
    switch (this) {
      case VarkTypeResult.visual:
        return '👁️';
      case VarkTypeResult.auditory:
        return '👂';
      case VarkTypeResult.readWrite:
        return '📖';
      case VarkTypeResult.kinesthetic:
        return '✋';
    }
  }

  static VarkTypeResult fromString(String value) {
    switch (value) {
      case 'V':
        return VarkTypeResult.visual;
      case 'A':
        return VarkTypeResult.auditory;
      case 'R':
        return VarkTypeResult.readWrite;
      case 'K':
        return VarkTypeResult.kinesthetic;
      default:
        return VarkTypeResult.visual;
    }
  }
}

class VarkTestResult extends Equatable {
  final String id;
  final String uid;
  final VarkTypeResult dominantStyle;
  final Map<String, int> scores;
  final String? mlPrediction;
  final String? mlConfidence;
  final DateTime completedAt;

  const VarkTestResult({
    required this.id,
    required this.uid,
    required this.dominantStyle,
    required this.scores,
    this.mlPrediction,
    this.mlConfidence,
    required this.completedAt,
  });

  factory VarkTestResult.fromFirestore(String id, Map<String, dynamic> data) {
    return VarkTestResult(
      id: id,
      uid: data['uid'] ?? '',
      dominantStyle: VarkTypeResultExtension.fromString(
        data['dominantStyle'] ?? 'V',
      ),
      scores: Map<String, int>.from(data['scores'] ?? {}),
      mlPrediction: data['mlPrediction'],
      mlConfidence: data['mlConfidence'],
      completedAt: DateTime.parse(data['completedAt'] as String),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'dominantStyle': dominantStyle.letter,
      'scores': scores,
      'mlPrediction': mlPrediction,
      'mlConfidence': mlConfidence,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        uid,
        dominantStyle,
        scores,
        mlPrediction,
        mlConfidence,
        completedAt,
      ];
}
