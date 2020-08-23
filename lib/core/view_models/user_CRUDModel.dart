import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/user.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCRUDModel extends ChangeNotifier {
  Api _api = Api('users');

  List<User> users;

  Future<List<User>> fetchUsers() async {
    var result = await _api.getDataCollection();
    users = result.docs.map((doc) => User.fromMap(doc.data(), doc.id)).toList();
    return users;
  }

  Stream<QuerySnapshot> fetchUsersAsStream() {
    return _api.streamDataCollection();
  }

  Future<User> getUserById(String id) async {
    var doc = await _api.getDocumentById(id);
    return User.fromMap(doc.data(), doc.id);
  }

  Future removeUser(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateUser(User data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    return;
  }

  Future addUser(User data) async {
    var result = await _api.addDocument(data.toJson());

    return;
  }
}
