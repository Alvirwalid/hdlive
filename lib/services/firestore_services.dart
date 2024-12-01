import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hdlive_latest/models/chat_model.dart';
import 'package:hdlive_latest/models/current_user_model.dart';
import 'package:hdlive_latest/models/level_model.dart';
import 'package:hdlive_latest/models/live_model.dart';
import 'package:hdlive_latest/models/viewer_model.dart';
import 'package:hdlive_latest/services/level_service.dart';
import 'package:hdlive_latest/services/profile_update_services.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';

class FirestoreServices {
  // static Future setLocalDescription(String description) async {}
  //
  static Future onWillPop(String id) async {
    print("idddddddd===$id");
    try {
      var _fire = FirebaseFirestore.instance;
      await _fire.collection("live_streams").doc(id).update({"live": false});
    } catch (e) {}
  }

  static Future onMute(String id, bool isMute) async {
    try {
      var _fire = FirebaseFirestore.instance;
      await _fire.collection("live_streams").doc(id).update({"isMute": isMute,"isSpeak": false,});
    } catch (e) {}
  }

  static Future onBroadCasterSpeak(String id, bool isSpeak) async {
    try {
      var _fire = FirebaseFirestore.instance;
      await _fire.collection("live_streams").doc(id).update({"isSpeak": isSpeak,});
    } catch (e) {}
  }

  static Future oncamera(String id, bool iscamera) async {
    try {
      var _fire = FirebaseFirestore.instance;
      await _fire
          .collection("live_streams")
          .doc(id)
          .update({"iscamera": iscamera});
    } catch (e) {}
  }

  static Future onGuestLeave(String id) async {
    try {
      CurrentUserModel user = await TokenManagerServices().getData();
      await FirebaseFirestore.instance
          .collection("live_streams")
          .doc(id)
          .collection("viewers")
          .doc(user.userId)
          .update({"status": 5});
    } catch (e) {}
  }

  static Future createNewLive(String id, String liveName, BuildContext context,
      int type, int seats) async {
    try {
      var _fire = FirebaseFirestore.instance;
      var i = await TokenManagerServices().getData();
      CurrentUserModel? user = await ProfileUpdateServices().getUserInfo(i.userId, true);
      Levelmodel? v = await LevelService().getUserLevel(i.userId!);

      await _fire.collection("live_streams").doc(id).set({
        "id": id,
        "uid": user?.userId??"",
        "name": user?.name??"",
        "photoUrl": user?.image??"",
        "live": true,
        "live_name": liveName != "" ? liveName : user!.name??"",
        "start_time": DateTime.now(),
        'seats': seats,
        "isMute": false,
        // "iscamera": false,
        "uniqid": user?.uniqueId??"",
        "gender": user?.gender??"",
        "beanscount": user?.beansCount??"",
        "starcount": user?.diamondcount??"",
        "isSpeak": false,
        "type": type == 1
            ? "video"
            : type == 0
                ? "multi_video"
                : "audio"
        //Tobe changed later
      });
      await _fire.collection("live_streams").doc(id).collection("chats").add({
        "user_id": user!.userId,
        "name": 'null',
        //"message": "Broadcaster",
        "message":
            "Broadcasted:'Vulgarity, pornography, any content that is copyrighted and abusive will be banned. Live broadcasters are monitored 24 hours a day.'\nCaution: Third-party top-ups or recharges will result in suspension or permanent ban'",
        "runningLevel": v!.data!.runningLevel,
        "rlColorCode": v.data!.rlColorCode,
        "rlIcon": v.data!.rlIcon,
        "gift_url": 'null',
        "time": DateTime.now()
      });

      await _fire.collection("live_streams").doc(id).collection("chats").add({
        "user_id": user!.userId??"",
        "name": user!.name??"",
        "message": "Broadcaster",
        // "message":
        //     "Broadcasted '\n 'Obscenity, pornography, any content that is copyrighted and abusive will be banned. Live broadcasters are monitored 24 hours a day.'\n Caution: Third-party top-ups or recharges will result in suspension or permanent ban'",
        "runningLevel": v.data?.runningLevel,
        "rlColorCode": v.data?.rlColorCode,
        "rlIcon": v.data?.rlIcon,
        "gift_url": 'null',
        "time": DateTime.now()
      });
    } catch (e) {
      print(e);
    }
  }

  static Future newUserJoined(
    String channelName,
  ) async {
    var i = await TokenManagerServices().getData();
    CurrentUserModel? user = await ProfileUpdateServices().getUserInfo(i.userId, true);
    print('Viewer Image  == ${user!.image}');
    await FirebaseFirestore.instance
        .collection("live_streams")
        .doc(channelName)
        .collection("viewers")
        .doc(user.userId)
        .get()
        .then((value) {
      if (!value.exists) {
        value.reference.set({
          "uid": user.userId,
          "name": user.name,
          "photoUrl": user.image,
          "status": 0,
          "gifturl": '',
          "isMute": true,
          "iscamera": false,
          "accepted_time": DateTime.now(),
          "seatno": 0,
          "broadcaster_mute": false,
          "broadcaster_video_mute": false,
          "isSpeak": false,
          "isSpeak": false,
          "gender": user.gender,
        });
      } else {
        value.reference.update({
          "uid": user.userId,
          "name": user.name,
          "photoUrl": user.image,
          "status": 0,
          "gifturl": '',
          "isMute": true,
          "iscamera": false,
          "accepted_time": DateTime.now(),
          "seatno": 0,
          "broadcaster_mute": false,
          "broadcaster_video_mute": false,
          "isSpeak": false,
          "gender": user.gender,
        });
      }
    });
  }

//
// /*
//   * Insert New Comment
//   * */
//
  static Future insertNewComment(String id, String message) async {
    try {
      var _fire = FirebaseFirestore.instance;
      CurrentUserModel user = await TokenManagerServices().getData();
      Levelmodel? v = await LevelService().getUserLevel(user.userId!);
      await _fire.collection("live_streams").doc(id).collection("chats").add({
        "user_id": user.userId,
        "name": user.name,
        "message": message,
        "runningLevel": v!.data?.runningLevel,
        "rlColorCode": v.data?.rlColorCode,
        "rlIcon": v.data?.rlIcon,
        "gift_url": 'null',
        "time": DateTime.now()
      });
    } catch (e) {}
  }

  static Future insertDefaultComment(String id) async {
    try {
      var _fire = FirebaseFirestore.instance;
      CurrentUserModel user = await TokenManagerServices().getData();
      Levelmodel? v = await LevelService().getUserLevel(user.userId!);
      await _fire.collection("live_streams").doc(id).collection("chats").add({
        "user_id": user.userId,
        "name": 'null',
        "message":
        "Broadcasted:'Vulgarity, pornography, any content that is copyrighted and abusive will be banned. Live broadcasters are monitored 24 hours a day.'\nCaution: Third-party top-ups or recharges will result in suspension or permanent ban'",
        "runningLevel": v!.data?.runningLevel,
        "rlColorCode": v.data?.rlColorCode,
        "rlIcon": v.data?.rlIcon,
        "gift_url": 'null',
        "time": DateTime.now()
      });
    } catch (e) {}
  }

  Stream<List<ChatModel>> getChats(id) {
    final chats = FirebaseFirestore.instance
        .collection("live_streams")
        .doc(id)
        .collection("chats")
        .orderBy('time', descending: true)
        .snapshots()
        .map(_getChatsFromSnapshot);

    return chats;
  }

  List<ChatModel> _getChatsFromSnapshot(QuerySnapshot snap) {
    if (snap.docs.length == 0) return [];
    return snap.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return ChatModel(
          userId: data['user_id'],
          name: data['name'],
          runningLevel: data['runningLevel'],
          rlColorCode: data['rlColorCode'],
          rlIcon: data['rlIcon'],
          giftUrl: data['gift_url'],
          time:
              DateTime.fromMillisecondsSinceEpoch(data['time'].seconds * 1000),
          message: data['message']);
    }).toList();
  }

  static Future joinUserMuteUnmute(
      String channelName, bool mute, String userId) async {
    await FirebaseFirestore.instance
        .collection("live_streams")
        .doc(channelName)
        .collection("viewers")
        .doc(userId)
        .update({
      "isMute": mute,
      "isSpeak": false,
    });
  }

  static Future joinUserStream(
      String channelName, bool stream, String userId) async {
    await FirebaseFirestore.instance
        .collection("live_streams")
        .doc(channelName)
        .collection("viewers")
        .doc(userId)
        .update({
      "iscamera": stream,
    });
  }

  static Future broadcasterRightUserMuteUnmute(
      String channelName, bool mute, String userId) async {
    await FirebaseFirestore.instance
        .collection("live_streams")
        .doc(channelName)
        .collection("viewers")
        .doc(userId)
        .update({"isMute": mute, "broadcaster_mute": mute, "isSpeak": false,});
  }

  static Future broadcasterRightUserVideoMuteUnmute(
      String channelName, bool mute, String userId) async {
    await FirebaseFirestore.instance
        .collection("live_streams")
        .doc(channelName)
        .collection("viewers")
        .doc(userId)
        .update({"iscamera": mute, "broadcaster_video_mute": mute});
  }

  static Future joinUserRemove(String channelName, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection("live_streams")
          .doc(channelName)
          .collection("viewers")
          .doc(userId)
          .update({
        "status": 6,
        "isMute": false,
        "iscamera": false,
        "broadcaster_mute": false,
        "broadcaster_video_mute": false,
        "isSpeak": false,
      });
    } catch (e) {}
  }


  static Future userSpeakerActive(String channelName, String userId,bool speak) async {
    try {
      await FirebaseFirestore.instance
          .collection("live_streams")
          .doc(channelName)
          .collection("viewers")
          .doc(userId)
          .update({
        "isSpeak": speak
      });
    } catch (e) {}
  }

  static Future joinVideo(
    int type,
    String channelName,
  ) async {
    CurrentUserModel user = await TokenManagerServices().getData();
    await FirebaseFirestore.instance
        .collection("live_streams")
        .doc(channelName)
        .collection("viewers")
        .doc(user.userId)
        .update({
      "status": type,
    });
  }

  updateUserStatus(String channelName, id) async {
    return FirebaseFirestore.instance
        .collection("live_streams")
        .doc(channelName)
        .collection("viewers")
        .where('uid')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        var i = element.data();
        print(' values === ${i['status']}');
        if (i['status'].toString().contains('5')) {
          FirebaseFirestore.instance
              .collection("live_streams")
              .doc(channelName)
              .collection("viewers")
              .doc(id.toString())
              .update({
            "status": 0,
          });
        }
      });
    });
  }

  Stream<List<ViewerModel>>? getViewersList(String channelName, id) {
    try {
      /*Comment for status error Join 28-02*/
      // updateUserStatus(channelName, id);
      var oi = FirebaseFirestore.instance
          .collection("live_streams")
          .doc(channelName)
          .collection("viewers")
          .where(
            'status',
            whereIn: [0, 3, 1, 4],
          )
          .limit(4)
          .snapshots()
          .map(_getVideoWaitingViewerFromSnapshot);
      oi.forEach((element) {
        print('Name ---' + element.length.toString());
      });
      // print('Length ==== ${}');
      print("c$oi");
      return oi;
    } catch (e) {
      print('Error in Get View = $e');
    }
  }

  Stream<List<ViewerModel>>? getAllViewersList(String channelName, id) {
    try {
      /*Comment for status error Join 28-02*/
      // updateUserStatus(channelName, id);
      var oi = FirebaseFirestore.instance
          .collection("live_streams")
          .doc(channelName)
          .collection("viewers")
          .where(
            'status',
            whereIn: [0, 3, 1, 4],
          )
          .snapshots()
          .map(_getVideoWaitingViewerFromSnapshot);
      oi.forEach((element) {
        print('Name ---' + element.length.toString());
      });
      // print('Length ==== ${}');
      print("c$oi");
      return oi;
    } catch (e) {
      print('Error in Get View = $e');
    }
  }

  Stream<List<ViewerModel>>? getVideoViewers(String channelName) {
    try {
      print('users length  ${_getVideoWaitingViewerFromSnapshot}');
      return FirebaseFirestore.instance
          .collection("live_streams")
          .doc(channelName)
          .collection("viewers")
          .snapshots()
          .map(_getVideoWaitingViewerFromSnapshot);
    } catch (e) {
      print('Error in Video Viewer == $e');
    }
  }

  Stream<List<ViewerModel>> getVideoWaitingViewer(String channelName) {
    return FirebaseFirestore.instance
        .collection("live_streams")
        .doc(channelName)
        .collection("viewers")
        .where('status', whereIn: [1, 2])
        .snapshots()
        .map(_getVideoWaitingViewerFromSnapshot);
  }

  List<ViewerModel> _getVideoWaitingViewerFromSnapshot(QuerySnapshot q) {
    print('query document length ' + q.docs.length.toString());
    if (q.docs.length == 0) {
      return [];
    }

    return q.docs.map((DocumentSnapshot doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      print('query document length ' + data.toString());
      return ViewerModel(
          uid: doc.id,
          name: data['name'],
          photoUrl: data['photoUrl'],
          isMute: data['isMute'],
          gifturl: data['gifturl'],
          isCamera: data['iscamera'],
          status: data['status'],
          broadcaster_mute: data['broadcaster_mute'],
          broadcaster_video_mute: data['broadcaster_video_mute'],
          isSpeak: data['isSpeak'],
          gender: data['gender'],
          seatno: data['seatno']);
    }).toList(growable: true);
  }

  Stream<List<ViewerModel>>? getVideoGuestViewer(String channelName) {
    try {
      var data = FirebaseFirestore.instance
          .collection("live_streams")
          .doc(channelName)
          .collection("viewers")
          .where('status', whereIn: [3, 4])
          .snapshots()
          .map(_getVideoWaitingViewerFromSnapshot);

      print('Firebase adata === ${data.length}');
      return data;
    } catch (e) {
      print("EXCEPTION----$e");
    }
  }

  Stream<List<ViewerModel>>? getVideoViewer(String channelName) {
    try {
      var data = FirebaseFirestore.instance
          .collection("live_streams")
          .doc(channelName)
          .collection("viewers")
          .where('status', whereIn: [3, 4])
          .snapshots()
          .map(_getVideoWaitingViewerFromSnapshot);

      print('Firebase adata === ${data.length}');
      return data;
    } catch (e) {
      print("EXCEPTION----$e");
    }
  }

  static Future addUserToVideoLive(
      int status, String channelName, String userId) async {
    await FirebaseFirestore.instance
        .collection("live_streams")
        .doc(channelName)
        .collection("viewers")
        .doc(userId)
        .update({
      "status": status == 1 ? 3 : 4,
      "isMute": false,
      "iscamera": false,
      "accepted_time": DateTime.now()
    });
  }

  static Future removeUserFromLive(
      ViewerModel viewer, String channelName) async {
    await FirebaseFirestore.instance
        .collection("live_streams")
        .doc(channelName)
        .collection("viewers")
        .doc(viewer.uid)
        .update({
      "status": 6,
    });
  }

  Stream<List<LiveModel>> getLiveStreams(type) {
    if (type == "both") {
      final lives = FirebaseFirestore.instance
          .collection("live_streams")
          .where("live", isEqualTo: true)
          .where("type", whereIn: ["video", "multi_video"])
          .snapshots()
          .map(_getLiveStreamsFromSnapshot);
      return lives;
    } else {
      final lives = FirebaseFirestore.instance
          .collection("live_streams")
          .where("live", isEqualTo: true)
          .where("type", isEqualTo: type)
          .snapshots()
          .map(_getLiveStreamsFromSnapshot);
      return lives;
    }
  }

  Stream<List<LiveModel>> getAllLiveStreams() {
    final lives = FirebaseFirestore.instance
          .collection("live_streams")
          .where("live", isEqualTo: true)
          .snapshots()
          .map(_getLiveStreamsFromSnapshot);
      return lives;
  }

  List<LiveModel> _getLiveStreamsFromSnapshot(QuerySnapshot snapshot) {
    if (snapshot.docs.length == 0) {
      return [];
    }

    return snapshot.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return LiveModel(
        live: data['live'],
        liveId: e.id,
        userId: data['uid'],
        name: data['name'],
        photoUrl: data['photoUrl'],
        liveName: data['live_name'],
        liveType: data['type'],
        seats: data['seats'],
        uniqid: data['uniqid'],
        gender: data['gender'],
        beanscount: data['beanscount'],
        starcount: data['starcount'],
        bio: data['bio'],
        startTime: DateTime.fromMillisecondsSinceEpoch(
            data['start_time'].seconds * 1000),
      );
    }).toList();
  }

  //
//   static Future<String> uploadImageToFirebase(_imageFile, filePath) async {
//     final FirebaseAuth auth = FirebaseAuth.instance;
//     final User user = auth.currentUser;
//
//     String newFileName = user.uid + filePath;
//     Reference firebaseStorageRef =
//     FirebaseStorage.instance.ref().child('$filePath/$newFileName');
//     UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
//     TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
//     return taskSnapshot.ref.getDownloadURL().then((value) {
//       return value;
//     });
//   }
//
//   static Future<String> uploadCoverPic(_imageFile, filePath, index) async {
//     final FirebaseAuth auth = FirebaseAuth.instance;
//     final User user = auth.currentUser;
//
//     String newFileName = user.uid + filePath + index;
//     Reference firebaseStorageRef =
//     FirebaseStorage.instance.ref().child('$filePath/$newFileName');
//     UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
//     TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
//     return taskSnapshot.ref.getDownloadURL().then((value) {
//       return value;
//     });
//   }
//
//   static Future editProfileInfo(File profilePic,
//       List<File> coverPics,
//       List<String> coverPicUrls,
//       String name,
//       String location,
//       int gender,
//       List<String> tags,
//       String introduction,
//       String constellation) async {
//     try {
//       final FirebaseAuth auth = FirebaseAuth.instance;
//       final User user = auth.currentUser;
//       await user.updateProfile(displayName: name);
//       if (profilePic != null) {
//         String profilePicUrl =
//         await uploadImageToFirebase(profilePic, 'profile_pic');
//         print(profilePicUrl);
//         await user.updateProfile(photoURL: profilePicUrl);
//       }
//
//       for (var i = 0; i < coverPics.length; i++) {
//         if (coverPics[i] != null) {
//           String coverUrl =
//           await uploadCoverPic(coverPics[i], "cover_pic", i.toString());
//           coverPicUrls[i] = coverUrl;
//         }
//       }
//
//       Map<String, dynamic> data = {
//         'location': location.isEmpty ? null : location,
//         'gender': gender,
//         'tags': tags,
//         'introduction': introduction.isEmpty ? null : introduction,
//         'contellation': constellation.isEmpty ? null : constellation,
//         'cover_pics': coverPicUrls
//       };
//
//       var update = await FirebaseFirestore.instance
//           .collection("users")
//           .doc(user.uid)
//           .update(data);
//       return 1;
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   static Future createNewUser(User user, String name) async {
//     await FirebaseFirestore.instance
//         .collection("lovello_ids")
//         .doc("max")
//         .get()
//         .then((d) async {
//       var max = d.data()['max'] ?? 0;
//       max += 1;
//
//       var update = await FirebaseFirestore.instance
//           .collection("users")
//           .doc(user.uid)
//           .set({
//         'location': null,
//         'name': name,
//         'photoUrl': user.photoURL,
//         "gender": 2,
//         "birthday": null,
//         'tags': [],
//         "introduction": null,
//         "contellation": null,
//         "cover_pics": [null, null, null, null, null],
//         'fans': 0,
//         'following': 0,
//         'level': 0,
//         'beans': 0,
//         'diamond': 0,
//         'bio': null,
//         "countryId": null,
//         "countryName": null,
//         "countryFlag": null,
//         "preference_ids": [],
//         "preference_names": [],
//         'lovello_id': max.toString(),
//         'lovello_id_edited': false
//       });
//
//       d.reference.update({"max": max});
//     });
//   }
//
//   Stream<List<PersonalChatModel>> getChat(String channelId) {
//     print(channelId);
//     return FirebaseFirestore.instance
//         .collection("chat")
//         .doc(channelId)
//         .collection("messages")
//         .orderBy('createdAt')
//         .snapshots()
//         .map(_getPersonalChatsMessagesFromSnapshot);
//   }
//
//   List<PersonalChatModel> _getPersonalChatsMessagesFromSnapshot(
//       QuerySnapshot snapshot) {
//     print(snapshot.docs.length);
//     return snapshot.docs.map((d) {
//       Timestamp createdAt = d.data()['createdAt'];
//       print(createdAt);
//       return PersonalChatModel(
//           id: d.data()['id'],
//           text: d.data()['text'],
//           createdAt:
//           DateTime.fromMillisecondsSinceEpoch(createdAt.seconds * 1000));
//     }).toList();
//   }
//
//   static Future storeChat(String message, String id, String channelName) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection("chat")
//           .doc(channelName)
//           .collection("messages")
//           .add({
//         'text': message,
//         'id': id,
//         'createdAt': DateTime.now(),
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
  static Future storeMultiGuests(String channelName, String docId) async {
    try {
      CurrentUserModel user = await TokenManagerServices().getData();
      await FirebaseFirestore.instance
          .collection("live_streams")
          .doc(channelName)
          .collection("multi_guests")
          .doc(docId)
          .set({"id": user.userId, "name": user.name, "photoUrl": user.image});
    } catch (e) {
      print(e);
    }
  }

  static Future<Map<int, dynamic>?> getMultiGuests(String channelName) async {
    try {
      Map<int, dynamic> guests = await FirebaseFirestore.instance
          .collection("live_streams")
          .doc(channelName)
          .collection("multi_guests")
          .get()
          .then((q) {
        Map<int, dynamic> g = {};
        q.docs.forEach((e) {
          g[int.parse(e.id)] = {
            "id": e.data()["id"],
            "name": e.data()["name"],
            "photoUrl": e.data()["photoUrl"]
          };
        });

        return g;
      });
      return guests;
    } catch (e) {
      print(e);
    }
  }

  static Future sendGift(String channelName, String uid, String image) async {
    try {
      FirebaseFirestore.instance
          .collection("live_streams")
          .doc(channelName)
          .collection("viewers")
          .where('uid')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          var i = element.data();
          if (i['status'].toString().contains('5')) {
          } else {
            FirebaseFirestore.instance
                .collection("live_streams")
                .doc(channelName)
                .collection("viewers")
                .doc(uid)
                .update({
              "gifturl": image,
            });
          }
        });
      });
    } catch (e) {}
  }

  static Future sendGiftNew(String channelName, String image) async {
    FirebaseFirestore.instance
        .collection('live_streams')
        .doc(channelName)
        .collection("gifts")
        .doc(channelName)
        .get()
        .then((value) {
      if (value.exists) {
        try {
          FirebaseFirestore.instance
              .collection("live_streams")
              .doc(channelName)
              .collection("gifts")
              .doc(channelName)
              .update({"gifturl": image, "time": DateTime.now().toString()});
        } catch (e) {
          print(e);
        }
      } else {
        value.reference
            .set({"gifturl": image, "time": DateTime.now().toString()});
      }
    });
  }

  static Future sendGiftMessage(
      String id, String message, String gifturl) async {
    try {
      var _fire = FirebaseFirestore.instance;
      CurrentUserModel user = await TokenManagerServices().getData();
      Levelmodel? v = await LevelService().getUserLevel(user.userId!);
      await _fire.collection("live_streams").doc(id).collection("chats").add({
        "user_id": user.userId,
        "name": user.name,
        "message": message,
        "runningLevel": v!.data!.runningLevel,
        "rlColorCode": v.data!.rlColorCode,
        "rlIcon": v.data!.rlIcon,
        "gift_url": gifturl,
        "time": DateTime.now()
      });
    } catch (e) {}
  }

  static Future sendInvition(String channelName, String viewerid) async {
    await FirebaseFirestore.instance
        .collection("live_streams")
        .doc(channelName)
        .collection("invite")
        .doc(viewerid)
        .get()
        .then((value) {
      if (!value.exists) {
        value.reference
            .set({"uid": viewerid, "time": DateTime.now().toString()});
      } else {
        value.reference
            .update({"uid": viewerid, "time": DateTime.now().toString()});
      }
    });
  }

  static Future callInvitionAccept(
      String viewerId, String channelName, int seat) async {
    await FirebaseFirestore.instance
        .collection("live_streams")
        .doc(channelName)
        .collection("viewers")
        .doc(viewerId)
        .update({
      "status": 3,
      "isMute": false,
      "iscamera": false,
      "accepted_time": DateTime.now(),
      "seatno": seat
    });
  }

  static Future addSeatUserToVideoLive(
      ViewerModel viewer, String channelName, int seat) async {
    await FirebaseFirestore.instance
        .collection("live_streams")
        .doc(channelName)
        .collection("viewers")
        .doc(viewer.uid)
        .update({
      "status": viewer.status == 1 ? 3 : 4,
      "isMute": false,
      "iscamera": false,
      "accepted_time": DateTime.now(),
      "seatno": seat
    });
  }

  Stream<List<ViewerModel>>? getUserSeatList(String channelName) {
    try {
      var oi = FirebaseFirestore.instance
          .collection("live_streams")
          .doc(channelName)
          .collection("viewers")
          .where(
            'status',
            whereIn: [3],
          )
          .snapshots()
          .map(_getVideoWaitingViewerFromSnapshot);
      oi.forEach((element) {
        print('Name ---' + element.length.toString());
      });
      // print('Length ==== ${}');
      print("c$oi");
      return oi;
    } catch (e) {
      print('Error in Get View = $e');
    }
  }

  static Future setBroadcasterView(String channelName, String url) async {
    FirebaseFirestore.instance
        .collection('live_streams')
        .doc(channelName)
        .collection("broadcaster_view")
        .doc(channelName)
        .get()
        .then((value) {
      if (value.exists) {
        try {
          FirebaseFirestore.instance
              .collection("live_streams")
              .doc(channelName)
              .collection("broadcaster_view")
              .doc(channelName)
              .update(
                  {"background_url": url, "time": DateTime.now().toString()});
        } catch (e) {
          print(e);
        }
      } else {
        value.reference
            .set({"background_url": url, "time": DateTime.now().toString()});
      }
    });
  }

  static Future userBlock(String viewerId, String channelName) async {
    await FirebaseFirestore.instance
        .collection("live_streams")
        .doc(channelName)
        .collection("viewers")
        .doc(viewerId)
        .get()
        .then((value) {
      if (!value.exists) {
        value.reference.set({"block": 1});
      } else {
        value.reference.update({"block": 1});
      }
    });
  }

  Stream<List<ViewerModel>> getViewerLive(String channelName){
    return FirebaseFirestore.instance
        .collection("live_streams")
        .doc(channelName)
        .collection("viewers")
        .where('status', whereIn: [3, 4])
        .snapshots()
        .map(_getVideoWaitingViewerFromSnapshot);
  }
}
