import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Skillify/src/services/repositoty.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final Repository repository;

  RegisterCubit({required this.repository}) : super(RegisterInitialState());

  void register(Map<String, dynamic> req) async {
    try {
      emit(RegisterLoadingState());
      final response = await repository.register(req);
      if (response['msg'] != null) {
        emit(RegisterSuccessState(message: response['msg']));
      } else {
        emit(RegisterErrorState(error: 'Something went wrong'));
      }
    } catch (e) {
      emit(RegisterErrorState(error: e.toString()));
    }
  }
}
