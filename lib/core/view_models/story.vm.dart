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
  bool _showDiscussion = false;
  bool _discussionFullView = false;
  double _expandedDiscussionHeight = 0.0;
  double _expandedHeight = 100.0;
  double _prevExpandedHeight = 0.0;
  double _descriptionHeight = 0.0;

  bool get showDiscussion => _showDiscussion;
  bool get discussionFullView => _discussionFullView;
  double get expandedDiscussionHeight => _expandedDiscussionHeight;
  double get expandedHeight => _expandedHeight;
  double get prevExpandedHeight => _prevExpandedHeight;
  double get descriptionHeight => _descriptionHeight;

  set showDiscussion(bool val) {
    _showDiscussion = val;
    notifyListeners();
  }

  set discussionFullView(bool val) {
    _discussionFullView = val;
    notifyListeners();
  }

  set expandedDiscussionHeight(double val) {
    _expandedDiscussionHeight = val;
    notifyListeners();
  }

  set expandedHeight(double val) {
    _prevExpandedHeight = _expandedHeight;
    _expandedHeight = val;
    notifyListeners();
  }

  set descriptionHeight(double val) {
    _descriptionHeight = val;
    notifyListeners();
  }

  void resetState() {
    _showDiscussion = false;
    _discussionFullView = false;
    _expandedDiscussionHeight = 0.0;
    _expandedHeight = 100.0;
    _prevExpandedHeight = 0.0;
    _descriptionHeight = 0.0;
  }

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

  Future addFollower(Story story) async {
    String exsistingId = story.followers.firstWhere(
      (element) => element == _auth.currentUser.uid,
      orElse: () => null,
    );
    if (exsistingId == null) {
      story.followers.add(_auth.currentUser.uid);
      final _update = Map<String, dynamic>.from({
        'followers': story.followers,
      });
      await _api.updateDocument(_update, story.id);
    }
  }

  Future removeFollower(Story story) async {
    String exsistingId = story.followers.firstWhere(
      (element) => element == _auth.currentUser.uid,
      orElse: () => null,
    );
    if (exsistingId != null) {
      story.followers.remove(_auth.currentUser.uid);
      final _update = Map<String, dynamic>.from({
        'followers': story.followers,
      });
      await _api.updateDocument(_update, story.id);
    }
  }

  // Future addStory(Story data) async {
  //   var result = await _api.addDocument(data.toJson());

  //   return;
  // }
}
