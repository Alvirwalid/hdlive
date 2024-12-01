part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}
class FetchProfileInfo extends ProfileEvent {
    final bool? me;
    final String? id;
    FetchProfileInfo({@required this.me,this.id});
}


