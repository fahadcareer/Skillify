abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final Map<String, dynamic> profile;

  ProfileLoadedState({required this.profile});
}

class ProfileNotFoundState extends ProfileState {}

class ProfileSavingState extends ProfileState {}

class ProfileSavedState extends ProfileState {}

class ProfileErrorState extends ProfileState {
  final String error;

  ProfileErrorState({required this.error});
}
