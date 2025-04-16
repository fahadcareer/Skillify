class Assessment {
  final String assessmentId;
  final List<AssessmentQuestion> assessmentQuestions;
  final Map<String, dynamic> evaluationCriteria;
  final List<String> potentialImprovements;
  final List<String> recommendedLearningPath;

  Assessment({
    required this.assessmentId,
    required this.assessmentQuestions,
    required this.evaluationCriteria,
    required this.potentialImprovements,
    required this.recommendedLearningPath,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      assessmentId: json['assessment_id'],
      assessmentQuestions: (json['assessment_questions'] as List)
          .map((e) => AssessmentQuestion.fromJson(e))
          .toList(),
      evaluationCriteria: json['evaluation_criteria'],
      potentialImprovements: List<String>.from(json['potential_improvements']),
      recommendedLearningPath:
          List<String>.from(json['recommended_learning_path']),
    );
  }
}

class AssessmentQuestion {
  final String id;
  final String question;
  final String type;
  final String difficulty;
  final String category;
  final List<String> options;

  AssessmentQuestion({
    required this.id,
    required this.question,
    required this.type,
    required this.difficulty,
    required this.category,
    required this.options,
  });

  factory AssessmentQuestion.fromJson(Map<String, dynamic> json) {
    return AssessmentQuestion(
      id: json['id'],
      question: json['question'],
      type: json['type'],
      difficulty: json['difficulty'],
      category: json['category'],
      options: List<String>.from(json['options']),
    );
  }
}
