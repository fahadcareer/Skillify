import 'package:Skillify/src/cubit/evaluation/evaluation_state.dart';
import 'package:Skillify/src/services/repositoty.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EvaluationCubit extends Cubit<AssessmentState> {
  final Repository repository;

  EvaluationCubit({required this.repository}) : super(AssessmentInitialState());

  void evaluateAssessment({
    required Map<String, dynamic> assessment,
    required List<Map<String, dynamic>> userResponses,
  }) async {
    try {
      emit(EvaluationLoadingState());
      final result = await repository.evaluateResponses(
        assessment: assessment,
        userResponses: userResponses,
      );
      emit(EvaluationSuccessState(evaluationResult: result));
    } catch (e) {
      emit(EvaluationErrorState(error: e.toString()));
    }
  }
}
