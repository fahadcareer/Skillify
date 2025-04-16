import 'package:flutter/widgets.dart';

@immutable
abstract class AssessmentState {}

class AssessmentInitialState extends AssessmentState {}

class EvaluationLoadingState extends AssessmentState {}

class EvaluationSuccessState extends AssessmentState {
  final Map<String, dynamic> evaluationResult;
  EvaluationSuccessState({required this.evaluationResult});
}

class EvaluationErrorState extends AssessmentState {
  final String error;
  EvaluationErrorState({required this.error});
}
