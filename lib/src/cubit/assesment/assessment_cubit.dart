import 'package:Skillify/src/cubit/assesment/assessment_state.dart';
import 'package:Skillify/src/services/repositoty.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AssessmentCubit extends Cubit<AssessmentState> {
  final Repository repository;

  AssessmentCubit({required this.repository}) : super(AssessmentInitialState());

  void generateAssessment(Map<String, dynamic> userProfile) async {
    try {
      emit(AssessmentLoadingState());
      final assessment = await repository.generateAssessment(userProfile);
      emit(AssessmentGeneratedState(assessment: assessment));
    } catch (e) {
      emit(AssessmentErrorState(error: e.toString()));
    }
  }
}
