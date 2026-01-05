import 'package:equatable/equatable.dart';

enum VarkType { visual, auditory, readWrite, kinesthetic }

extension VarkTypeExtension on VarkType {
  String get letter {
    switch (this) {
      case VarkType.visual:
        return 'V';
      case VarkType.auditory:
        return 'A';
      case VarkType.readWrite:
        return 'R';
      case VarkType.kinesthetic:
        return 'K';
    }
  }

  String get displayName {
    switch (this) {
      case VarkType.visual:
        return 'Visual';
      case VarkType.auditory:
        return 'Auditory';
      case VarkType.readWrite:
        return 'Read/Write';
      case VarkType.kinesthetic:
        return 'Kinesthetic';
    }
  }

  String get icon {
    switch (this) {
      case VarkType.visual:
        return '👁️';
      case VarkType.auditory:
        return '👂';
      case VarkType.readWrite:
        return '📖';
      case VarkType.kinesthetic:
        return '✋';
    }
  }
}

/// Question model for VARK quiz
class VarkQuestion extends Equatable {
  final int id;
  final String question;
  final Map<VarkType, String> options;
  final String category;

  const VarkQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.category,
  });

  /// Get option for a specific VARK type
  String? getOption(VarkType type) => options[type];

  /// Get all options as a list with their types
  List<MapEntry<VarkType, String>> getOptionsList() {
    return options.entries.toList()
      ..sort((a, b) => a.key.index.compareTo(b.key.index));
  }

  @override
  List<Object?> get props => [id, question, options, category];
}

/// Learning style result model
class LearningStyleResult extends Equatable {
  final VarkType type;
  final int score;
  final double percentage;

  const LearningStyleResult({
    required this.type,
    required this.score,
    required this.percentage,
  });

  @override
  List<Object?> get props => [type, score, percentage];
}

/// Complete quiz result
class VarkQuizResult extends Equatable {
  final Map<VarkType, int> scores;
  final List<LearningStyleResult> results;
  final VarkType dominantStyle;
  final int totalQuestions;

  const VarkQuizResult({
    required this.scores,
    required this.results,
    required this.dominantStyle,
    required this.totalQuestions,
  });

  /// Get results sorted by score (highest first)
  List<LearningStyleResult> get sortedResults {
    return List.from(results)..sort((a, b) => b.score.compareTo(a.score));
  }

  /// Check if there's a tie for dominant style
  bool hasTie() {
    if (results.isEmpty) return false;
    final maxScore = results.first.score;
    return results.where((r) => r.score == maxScore).length > 1;
  }

  /// Get tied styles if any
  List<VarkType> getTiedStyles() {
    if (results.isEmpty) return [];
    final maxScore = results.first.score;
    return results
        .where((r) => r.score == maxScore)
        .map((r) => r.type)
        .toList();
  }

  @override
  List<Object?> get props => [scores, results, dominantStyle, totalQuestions];
}
