import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/user.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserVM extends ChangeNotifier {
  Api _api = Api('users');

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

  // Future<UserModel> getUserById(String id) async {
  //   var doc = await _api.getDocumentById(id);
  //   return UserModel.fromMap(doc.data(), doc.id);
  // }

  Future removeUser(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateUser(UserModel data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    return;
  }

  Future addUser(UserModel data, String uid) async {
    Map<String, dynamic> _data = data.toJson();
    _data['stories'] = _data['stories'].toJson();
    await _api.addDocument(_data, id: uid);
    return;
  }
}
