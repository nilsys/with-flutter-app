import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/story.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:provider/provider.dart';

class StoryVM extends ChangeNotifier {
  Api _api = Api('stories');
  final _auth = FirebaseAuth.instance;

  List<Story> stories;

  Future<List<Story>> fetchStories() async {
    var result = await _api.getDataCollection();
    stories =
        result.docs.map((doc) => Story.fromMap(doc.data(), doc.id)).toList();
    return stories;
  }

  Stream<QuerySnapshot> fetchStoriesAsStream() {
    return _api.streamDataCollection();
  }

  Stream<DocumentSnapshot> fetchStoryAsStream(String storyId) {
    return _api.streamDoc(storyId);
  }

  Future<Story> getStoryById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Story.fromMap(doc.data(), doc.id);
  }

  Future removeStory(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateStory(Story data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    return;
  }

  Future duplicateStory(Story story) async {
    Map<String, dynamic> _data = story.toJson();
    await _api.addDocument(_data);
    return;
  }

  Future deleteStory(String storyId) async {
    await _api.removeDocument(storyId);
    return;
  }

  Future follow(Story story) async {
    story.followers.add(_auth.currentUser.uid);
    final _update = Map<String, dynamic>.from({
      'followers': story.followers.toSet().toList(),
    });
    await _api.updateDocument(_update, story.id);
  }

  // Future addStory(Story data) async {
  //   var result = await _api.addDocument(data.toJson());

  //   return;
  // }
}
