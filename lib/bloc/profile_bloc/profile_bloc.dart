import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/current_user_model.dart';
import '../../services/profile_update_services.dart';
import '../../services/shared_storage_services.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is FetchProfileInfo) {
      // try {
      yield ProfileFetching();
      var id;

      if (event.me!) {
        id = await LocalStorageHelper.read("userId");
      } else {
        id = event.id;
      }

      CurrentUserModel? user = await ProfileUpdateServices().getUserInfo(id, event.me);
      if (user != null) {
        yield ProfileFetched(user: user);
      } else {
        yield ProfileError();
      }
      // } catch (e) {
      //   print('Error in fetching Api  $e');
      //   yield ProfileError();
      // }
    }
  }
}
