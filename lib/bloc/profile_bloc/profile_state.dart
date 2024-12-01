part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class ProfileFetching extends ProfileState{}
class ProfileFetched extends ProfileState {
  final CurrentUserModel? user;
  ProfileFetched({this.user});
}
class ProfileError extends ProfileState {}
