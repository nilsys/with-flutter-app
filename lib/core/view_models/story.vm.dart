import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/story.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryVM extends ChangeNotifier {
  Api _api = Api('stories');

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

  Future addStory(Story data) async {
    var result = await _api.addDocument(data.toJson());

    return;
  }
}
