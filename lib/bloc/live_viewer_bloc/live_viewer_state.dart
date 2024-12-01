part of 'live_viewer_bloc.dart';

@immutable
abstract class LiveViewerState {}

class LiveViewerInitial extends LiveViewerState {}
class LiveViewerFetching extends LiveViewerState{}
class LiveViewerFetched extends LiveViewerState{
  final int? liveViewerCount;
  LiveViewerFetched({this.liveViewerCount});
}

class LiveViewerFetchingError extends LiveViewerState{}