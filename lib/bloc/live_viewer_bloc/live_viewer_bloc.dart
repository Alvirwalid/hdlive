import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'live_viewer_event.dart';
part 'live_viewer_state.dart';

class LiveViewerBloc extends Bloc<LiveViewerEvent, LiveViewerState> {
  LiveViewerBloc() : super(LiveViewerInitial());

  @override
  Stream<LiveViewerState> mapEventToState(
    LiveViewerEvent event,
  ) async* {
    if(event is FetchLiveViewer){
      try{
        yield LiveViewerFetching();

        print(event.channelName);
        int liveCount = await FirebaseFirestore.instance.collection("live_streams").doc(event.channelName).collection("viewers").get().then((value){
          print(value.docs.length);
          return value.docs.length;
        });
        yield LiveViewerFetched(liveViewerCount: liveCount);
      }catch(e){
        yield LiveViewerFetchingError();
      }
    }
  }
}
