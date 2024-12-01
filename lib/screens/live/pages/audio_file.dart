import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioFiles extends StatefulWidget {
  const AudioFiles({
     Key? key,
    required this.files,
  }) : super(key: key);

  final List<File> files;

  @override
  State<AudioFiles> createState() => _AudioFilesState();
}

class _AudioFilesState extends State<AudioFiles> {
  AudioPlayer? player;
  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    player!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .50,
      width: MediaQuery.of(context).size.width * .8,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        itemCount: widget.files?.length ?? 0,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
            title: Text(widget.files[index].path.split('/').last),
            leading: Icon(Icons.audiotrack),
            trailing: Icon(
              Icons.play_arrow,
              color: Colors.redAccent,
            ),
            onTap: () async {
              print("audiooo ${widget.files[index].path}");

              var result = await player!.play(widget.files[index].path as Source);

              // you can add Play/push code over here
            },
          ));
        },
      ),
    );
  }
}
