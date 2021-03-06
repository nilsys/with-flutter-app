import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../services/api.dart';
import '../models/user.model.dart';

export '../models/user.model.dart';
export 'package:with_app/locator.dart';

class UserVM extends ChangeNotifier {
  Api _api = Api('users');
  final _auth = FirebaseAuth.instance;
  bool _emailLinkExpired = false;

  bool get emailLinkExpired => _emailLinkExpired;

  set emailLinkExpired(bool val) {
    _emailLinkExpired = val;
    notifyListeners();
  }

  List<UserModel> users;

  // Future<List<UserModel>> fetchUser() async {
  //   var result = await _api.getDataCollection();
  //   users = result.docs
  //       .map((doc) => UserModel.fromMap(doc.data(), doc.id))
  //       .toList();
  //   return users;
  // }

  Stream<DocumentSnapshot> fetchUserAsStream(String uid) {
    return _api.streamDoc(uid);
  }

  Stream<DocumentSnapshot> fetchCurrentUserAsStream() {
    return _api.streamDoc(_auth.currentUser.uid);
  }

  Future<UserModel> getUserById(String id) async {
    var doc = await _api.getDocumentById(id);
    return UserModel.fromMap(doc.data(), doc.id);
  }

  Future removeUser(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future<void> updateUser(UserModel data, String id) async {
    Map<String, dynamic> _data = data.toJson();
    _data['stories'] = _data['stories'].toJson();
    print(_data);
    await _api.updateDocument(_data, id);
    return;
  }

  Future<String> uploadAvatar(File avatar, String uid) async {
    const String fileName = 'profile_image.jpg';
    final StorageReference storageReference =
        FirebaseStorage().ref().child('users/$uid/settings/$fileName');
    final StorageUploadTask uploadTask = storageReference.putFile(avatar);
    final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    final String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  // TODO: remove this method - depricated (use setUser instead)
  Future addUser(UserModel data, String uid) async {
    Map<String, dynamic> _data = data.toJson();
    _data['stories'] = _data['stories'].toJson();
    await _api.addDocument(_data, id: uid);
    return;
  }

  Future setUser(UserModel data, String uid) async {
    Map<String, dynamic> _data = data.toJson();
    if (_data['stories'] != null) {
      _data['stories'] = _data['stories'].toJson();
    }
    await _api.updateDocument(_data, uid);
    return;
  }

  Future followStory(String storyId, UserModel user) async {
    String exsistingId = user.stories.following.firstWhere(
      (element) => element == storyId,
      orElse: () => null,
    );
    if (exsistingId == null) {
      user.stories.following.add(storyId);
      final _update = Map<String, dynamic>.from({
        'stories': user.stories.toJson(),
      });
      await _api.updateDocument(_update, user.id);
    }
  }

  Future unFollowStory(String storyId, UserModel user) async {
    String exsistingId = user.stories.following.firstWhere(
      (element) => element == storyId,
      orElse: () => null,
    );
    if (exsistingId != null) {
      user.stories.following.remove(storyId);
      final _update = Map<String, dynamic>.from({
        'stories': user.stories.toJson(),
      });
      await _api.updateDocument(_update, user.id);
    }
  }
}
