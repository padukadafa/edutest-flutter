import 'package:edutest/features/question/data/models/vark_question_model.dart';
import 'package:edutest/features/question/domain/entities/ml_prediction.dart';
import 'package:flutter/material.dart';

class VarkResultPage extends StatelessWidget {
  final VarkQuizResult result;
  final MLPrediction? prediction;
  final Map<String, int>? traditionalScores;

  const VarkResultPage({
    super.key,
    required this.result,
    this.prediction,
    this.traditionalScores,
  });

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

  VarkType get _dominantStyle {
    if (prediction != null) {
      return _getVarkTypeFromLetter(prediction!.predictedStyle);
    }
    return result.dominantStyle;
  }

  String get _confidenceText {
    if (prediction != null) {
      return prediction!.confidencePercentage;
    }
    final mlPercentage = result.results
        .firstWhere(
          (r) => r.type == result.dominantStyle,
          orElse: () => LearningStyleResult(
            type: result.dominantStyle,
            score: 0,
            percentage: 0,
          ),
        )
        .percentage;
    return '${mlPercentage.toStringAsFixed(0)}%';
  }

  bool get _isMLBased => prediction != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil VARK'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDominantStyleCard(_dominantStyle),
            const SizedBox(height: 24),
            if (_isMLBased) _buildMLConfidenceCard(),
            const SizedBox(height: 24),
            _buildScoreBreakdown(result),
            const SizedBox(height: 24),
            _buildDescription(_dominantStyle),
            const SizedBox(height: 24),
            _buildStudyTips(_dominantStyle),
            if (_isMLBased && prediction!.recommendations.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildMLRecommendations(),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDominantStyleCard(VarkType dominantStyle) {
    final colors = {
      VarkType.visual: const Color(0xFF4285F4),
      VarkType.auditory: const Color(0xFFEA4335),
      VarkType.readWrite: const Color(0xFFFBBC05),
      VarkType.kinesthetic: const Color(0xFF34A853),
    };

    final color = colors[dominantStyle] ?? Colors.blue;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(dominantStyle.icon, style: const TextStyle(fontSize: 60)),
          const SizedBox(height: 12),
          Text(
            _isMLBased ? 'Prediksi ML' : 'Gaya Belajar Dominan Anda',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            dominantStyle.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _confidenceText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.green),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Machine Learning Prediction',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Confidence: ${prediction!.confidencePercentage}',
                  style: TextStyle(fontSize: 14, color: Colors.green.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMLRecommendations() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.purple),
              SizedBox(width: 8),
              Text(
                'Rekomendasi ML',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...prediction!.recommendations.asMap().entries.map((entry) {
            final index = entry.key;
            final recommendation = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.purple.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      recommendation,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF444444),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // Helper method to get VarkType from ML probability key
  VarkType _getVarkTypeFromKey(String key) {
    switch (key.toUpperCase()) {
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

  Widget _buildScoreBreakdown(VarkQuizResult result) {
    final colors = {
      VarkType.visual: const Color(0xFF4285F4),
      VarkType.auditory: const Color(0xFFEA4335),
      VarkType.readWrite: const Color(0xFFFBBC05),
      VarkType.kinesthetic: const Color(0xFF34A853),
    };

    // Get the data to display - ML probabilities or traditional scores
    final List<MapEntry<VarkType, double>> stylePercentages;

    if (_isMLBased && prediction != null) {
      // Use ML probabilities
      stylePercentages = prediction!.probabilities.entries.map((entry) {
        return MapEntry(_getVarkTypeFromKey(entry.key), entry.value * 100);
      }).toList()..sort((a, b) => b.value.compareTo(a.value));
    } else {
      // Use traditional scores
      stylePercentages = result.sortedResults
          .map((r) => MapEntry(r.type, r.percentage))
          .toList();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isMLBased ? Icons.auto_graph : Icons.analytics,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                _isMLBased ? 'Probabilitas ML' : 'Rincian Skor',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...stylePercentages.map((entry) {
            final type = entry.key;
            final color = colors[type] ?? Colors.blue;
            final percentage = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                type.icon,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            type.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDescription(VarkType type) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Tentang Gaya ${type.displayName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getDescription(type),
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF444444),
            ),
          ),
        ],
      ),
    );
  }

  String _getDescription(VarkType type) {
    switch (type) {
      case VarkType.visual:
        return 'Anda lebih mudah memahami informasi yang disajikan secara visual. '
            'Grafik, diagram, video, dan warna membantu Anda memahami konsep dengan lebih baik.';
      case VarkType.auditory:
        return 'Anda lebih mudah memahami informasi melalui pendengaran. '
            'Diskusi, ceramah, dan penjelasan verbal sangat efektif untuk Anda.';
      case VarkType.readWrite:
        return 'Anda lebih menyukai informasi dalam bentuk teks tertulis. '
            'Membaca, menulis, dan membuat catatan adalah cara terbaik Anda untuk belajar.';
      case VarkType.kinesthetic:
        return 'Anda belajar terbaik melalui pengalaman langsung dan praktik. '
            'Hands-on activities dan eksperimen sangat efektif untuk Anda.';
    }
  }

  Widget _buildStudyTips(VarkType type) {
    final tips = _getStudyTips(type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Colors.amber),
            SizedBox(width: 8),
            Text(
              'Tips Belajar untuk Anda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: tips.asMap().entries.map((entry) {
              final index = entry.key;
              final tip = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.amber.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  List<String> _getStudyTips(VarkType type) {
    switch (type) {
      case VarkType.visual:
        return [
          'Gunakan grafik, diagram, dan peta pikiran',
          'Tonton video pembelajaran',
          'Gunakan warna untuk mencatat',
          'Buat flashcards dengan gambar',
          'Gunakan Presentasi visual saat belajar',
        ];
      case VarkType.auditory:
        return [
          'Rekam dan dengarkan catatan Anda',
          'Bergabung dalam kelompok diskusi',
          'Jelaskan materi dengan suara keras',
          'Dengarkan podcast edukasi',
          'Gunakan mnemonik verbal',
        ];
      case VarkType.readWrite:
        return [
          'Buat catatan yang terstruktur',
          'Tulis ulang ringkasan materi',
          'Baca berulang kali',
          'Buat daftar dan checklist',
          'Tulis esai tentang materi yang dipelajari',
        ];
      case VarkType.kinesthetic:
        return [
          'Lakukan eksperimen langsung',
          'Gunakan simulasi dan role-play',
          'Berjalan saat mempelajari materi',
          'Bawa objek untuk manipulatif',
          'Istirahat aktif di antara sesi belajar',
        ];
    }
  }
}
