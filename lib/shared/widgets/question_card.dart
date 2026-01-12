import 'package:flutter/material.dart';
import 'package:edutest/features/question/data/models/vark_question_model.dart';

class QuestionCard extends StatelessWidget {
  final VarkQuestion question;
  final int questionIndex;
  final int total;
  final VarkType? selectedType;
  final Function(VarkType) onSelect;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionIndex,
    required this.total,
    this.selectedType,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header
          _buildHeader(),
          const SizedBox(height: 20),

          // Question text
          _buildQuestionText(),
          const SizedBox(height: 24),

          // Options
          ..._buildOptions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Pertanyaan $questionIndex dari $total',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildQuestionText() {
    return Text(
      question.question,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  List<Widget> _buildOptions() {
    final optionsList = question.getOptionsList();
    return optionsList.mapIndexed((index, entry) {
      final type = entry.key;
      final text = entry.value;
      final isSelected = selectedType == type;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildOptionItem(type, text, isSelected, index),
      );
    }).toList();
  }

  Widget _buildOptionItem(
    VarkType type,
    String text,
    bool isSelected,
    int index,
  ) {
    final colors = {
      VarkType.visual: const Color(0xFF4285F4), // Blue
      VarkType.auditory: const Color(0xFFEA4335), // Red
      VarkType.readWrite: const Color(0xFFFBBC05), // Yellow
      VarkType.kinesthetic: const Color(0xFF34A853), // Green
    };

    final color = colors[type] ?? Colors.blue;
    final icon = type.icon;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelect(type),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: isSelected ? 2.5 : 1.5,
            ),
            color: isSelected ? color.withOpacity(0.08) : Colors.white,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              // Type indicator
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 16),
              // Option text
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? color : const Color(0xFF333333),
                  ),
                ),
              ),
              // Selection indicator
              if (isSelected)
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Extension for indexed iteration
extension IndexedIterableExtension<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E element) f) {
    var index = 0;
    return map((e) => f(index++, e));
  }
}
