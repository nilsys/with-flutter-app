import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/user.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCRUDModel extends ChangeNotifier {
  Api _api = Api('users');

  List<UserModel> users;

  Future<List<UserModel>> fetchUsers() async {
    var result = await _api.getDataCollection();
    users = result.docs
        .map((doc) => UserModel.fromMap(doc.data(), doc.id))
        .toList();
    return users;
  }

  Stream<QuerySnapshot> fetchUsersAsStream() {
    return _api.streamDataCollection();
  }

  Future<UserModel> getUserById(String id) async {
    var doc = await _api.getDocumentById(id);
    return UserModel.fromMap(doc.data(), doc.id);
  }

  Future removeUser(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateUser(UserModel data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    return;
  }

  Future addUser(UserModel data) async {
    var result = await _api.addDocument(data.toJson());

    return;
  }
}
