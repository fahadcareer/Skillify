import 'dart:convert';
import 'dart:developer';
import 'package:Skillify/src/services/repositoty.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Skillify/src/cubit/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final Repository repository;

  ProfileCubit({required this.repository}) : super(ProfileInitialState());

  Future<void> getProfile(String email) async {
    emit(ProfileLoadingState());
    try {
      final response = await repository.getProfile(email);
      if (response['msg'] == 'Profile not found') {
        emit(ProfileNotFoundState());
      } else {
        emit(ProfileLoadedState(profile: response));
      }
    } catch (e) {
      emit(ProfileErrorState(error: e.toString()));
    }
  }

  Future<void> saveProfile(Map<String, dynamic> profileData) async {
    emit(ProfileSavingState());
    try {
      log('Sending profile data: ${jsonEncode(profileData)}');
      final response = await repository.saveProfile(profileData);
      log('Save profile response: $response');

      if (response['msg'] == 'Profile saved successfully') {
        emit(ProfileSavedState());
      } else {
        emit(ProfileErrorState(
            error: 'Failed to save profile: ${response['msg']}'));
      }
    } catch (e) {
      log('Save profile error: $e');
      emit(ProfileErrorState(error: e.toString()));
    }
  }
}
