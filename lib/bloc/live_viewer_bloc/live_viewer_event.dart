part of 'live_viewer_bloc.dart';

@immutable
abstract class LiveViewerEvent {}

class FetchLiveViewer extends LiveViewerEvent{
  final String? channelName;
  FetchLiveViewer({this.channelName});
}