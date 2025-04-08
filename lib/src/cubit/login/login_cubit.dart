import 'package:Skillify/src/cubit/login/login_state.dart';
import 'package:Skillify/src/services/repositoty.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginCubit extends Cubit<LoginState> {
  final Repository repository;

  LoginCubit({required this.repository}) : super(LoginInitialState());

  void login(Map<String, dynamic> req) async {
    try {
      emit(LoginLoadingState());
      final loginResponse = await repository.login(req);
      emit(LoginLoadedState(loginModel: loginResponse));
    } catch (e) {
      emit(LoginErrorState(error: e.toString()));
    }
  }
}
