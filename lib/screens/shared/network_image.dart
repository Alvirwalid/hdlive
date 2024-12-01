import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'loading.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? url;
  NetworkImageWidget({this.url});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(
        fit: BoxFit.fill,
        image: NetworkImage(url??""),
      ),
    );
  }
}

class HexagonProfilePicNetworkImage extends StatelessWidget {
  final String? url;
  HexagonProfilePicNetworkImage({this.url});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return CachedNetworkImage(
      width: width * .25,
      height: 120,
      fit: BoxFit.cover,
      imageUrl: url??"",
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          Container(width: 5, child: Loading()),
      errorWidget: (context, url, error) => Image.asset(
        "images/profile.jpeg",
        fit: BoxFit.cover,
      ),
    );
  }
}

class HexagonProfilePicFile extends StatelessWidget {
  final File? file;
  HexagonProfilePicFile({this.file});
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: Image(
        width: width * .25,
        height: 120,
        fit: BoxFit.cover,
        image: FileImage(file!),
      ),
    );
  }
}

class CoverPhotoFileImage extends StatelessWidget {
  final File? file;
  CoverPhotoFileImage({this.file});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(
        fit: BoxFit.cover,
        image: FileImage(file!),
      ),
    );
  }
}

class CoverPhotoNetworkImage extends StatelessWidget {
  final String? url;
  CoverPhotoNetworkImage({this.url});
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: url??"",
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          Container(width: 20, child: Loading()),
      errorWidget: (context, url, error) => Image.asset(
        "images/profile.jpeg",
        fit: BoxFit.cover,
      ),
    );
  }
}
