import 'package:Skillify/src/data/local/model/generate%20assesment/assessment_model.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class AssessmentState {}

class AssessmentInitialState extends AssessmentState {}

class AssessmentLoadingState extends AssessmentState {}

class AssessmentGeneratedState extends AssessmentState {
  final Assessment assessment;
  AssessmentGeneratedState({required this.assessment});
}

class AssessmentErrorState extends AssessmentState {
  final String error;
  AssessmentErrorState({required this.error});
}
