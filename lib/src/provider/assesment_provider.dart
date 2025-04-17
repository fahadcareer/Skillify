import 'package:Skillify/src/res/strings/network_string.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Question {
  final String id;
  final String questionText;
  final String category;
  final String type;
  final String difficulty;
  final List<String>? options;
  String? userAnswer;

  Question({
    required this.id,
    required this.questionText,
    required this.category,
    required this.type,
    required this.difficulty,
    this.options,
    this.userAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      questionText: json['question'] ?? '',
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      difficulty: json['difficulty'] ?? '',
      options:
          json['options'] != null ? List<String>.from(json['options']) : null,
    );
  }
}

class QuestionsProvider extends ChangeNotifier {
  final String evaluateUrl = NetworkString.evaluateResponses;
  List<Question> _questions = [];
  bool _isLoading = false;
  String _error = '';
  Map<String, dynamic>? _evaluationResult;

  List<Question> get questions => _questions;
  bool get isLoading => _isLoading;
  String get error => _error;
  Map<String, dynamic>? get evaluationResult => _evaluationResult;

  void setQuestions(List<dynamic> questionsJson) {
    _questions = questionsJson.map((q) => Question.fromJson(q)).toList();
    notifyListeners();
  }

  void updateQuestionAnswer(String questionId, String answer) {
    final questionIndex = _questions.indexWhere((q) => q.id == questionId);
    if (questionIndex != -1) {
      _questions[questionIndex].userAnswer = answer;
      notifyListeners();
    }
  }

  Future<bool> submitAssessment(Map<String, dynamic> assessment) async {
    final unansweredQuestions =
        _questions.where((q) => q.userAnswer == null).length;
    if (unansweredQuestions > 0) {
      _error = 'Please answer all questions before submitting.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final userResponses = {for (var q in _questions) q.id: q.userAnswer};

      final response = await http.post(
        Uri.parse(evaluateUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'assessment': assessment,
          'user_responses': userResponses,
        }),
      );

      if (response.statusCode == 200) {
        _evaluationResult = json.decode(response.body);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to submit assessment. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String generateResultText() {
    if (_evaluationResult == null) {
      return 'No evaluation results available.';
    }

    String resultText = '';

    if (_evaluationResult!['overall_score'] >= 80) {
      resultText +=
          "Excellent performance! You've demonstrated strong skills and knowledge. ";
    } else if (_evaluationResult!['overall_score'] >= 60) {
      resultText +=
          "Good performance with potential for growth. You're on the right track! ";
    } else {
      resultText +=
          "There are significant opportunities for skill development. Don't get discouraged! ";
    }

    resultText +=
        "\nOverall Score: ${_evaluationResult!['overall_score'].round()}%\n";

    if (_evaluationResult!['category_scores'] != null) {
      resultText += "\nCategory Scores:\n";
      _evaluationResult!['category_scores'].forEach((category, scoreInfo) {
        resultText +=
            "• $category: ${scoreInfo['score']}% (${scoreInfo['performance']})\n";
      });
    }

    if (_evaluationResult!['strengths'] != null &&
        _evaluationResult!['strengths'].isNotEmpty) {
      resultText += "\nYour Strengths:\n";
      for (var strength in _evaluationResult!['strengths']) {
        resultText += "• $strength\n";
      }
    }

    if (_evaluationResult!['improvement_areas'] != null &&
        _evaluationResult!['improvement_areas'].isNotEmpty) {
      resultText += "\nAreas for Improvement:\n";
      for (var area in _evaluationResult!['improvement_areas']) {
        resultText += "• $area\n";
      }
    }

    if (_evaluationResult!['recommended_learning_path'] != null &&
        _evaluationResult!['recommended_learning_path'].isNotEmpty) {
      resultText += "\nRecommended Learning Path:\n";
      for (var recommendation
          in _evaluationResult!['recommended_learning_path']) {
        resultText += "• $recommendation\n";
      }
    }

    if (_evaluationResult!['learning_plan'] != null) {
      resultText += "\n1-Month Learning Plan:\n";
      _evaluationResult!['learning_plan'].forEach((week, activities) {
        resultText +=
            "\n${week.toString().replaceAll('_', ' ').toUpperCase()}:\n";
        for (var activity in activities) {
          resultText += "• $activity\n";
        }
      });
    }

    return resultText.trim();
  }

  void reset() {
    _questions = [];
    _isLoading = false;
    _error = '';
    _evaluationResult = null;
    notifyListeners();
  }
}
