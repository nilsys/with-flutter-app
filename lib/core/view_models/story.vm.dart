import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:with_app/core/models/comment.model.dart';
import 'package:with_app/core/models/post.model.dart';
import 'package:with_app/core/models/user.model.dart';
import '../services/api.dart';
import '../models/story.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:provider/provider.dart';
export 'package:with_app/locator.dart';

class StoryVM extends ChangeNotifier {
  Api _api = Api('stories');
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _showDiscussion = false;
  bool _discussionFullView = false;
  bool _keyboardIsOpen = false;
  bool _showCameraPreview = false;
  bool _hasNewComments = false;
  double _expandedDiscussionHeight = 0.0;
  double _expandedHeight = 100.0;
  double _collpasedHeight = 82.0;
  double _prevExpandedHeight = 0.0;
  double _descriptionHeight = 0.0;
  double _discussionHeight = 0.0;
  Story _story;
  UserModel _author;
  List<Comment> _discussion = [];
  List<Post> _posts = [];
  // List<double> _scrollOffsets = [];

  bool get hasNewComments => _hasNewComments;
  bool get showDiscussion => _showDiscussion;
  bool get discussionFullView => _discussionFullView;
  bool get keyboardIsOpen => _keyboardIsOpen;
  bool get showCameraPreview => _showCameraPreview;
  double get expandedDiscussionHeight => _expandedDiscussionHeight;
  double get expandedHeight => _expandedHeight;
  double get prevExpandedHeight => _prevExpandedHeight;
  double get descriptionHeight => _descriptionHeight;
  double get discussionHeight => _discussionHeight;
  double get collpasedHeight => _collpasedHeight;
  // List<double> get scrollOffsets => _scrollOffsets;
  Story get story => _story;
  UserModel get author => _author;
  List<Comment> get discussion => _discussion;
  List<Post> get posts => _posts;

  set hasNewComments(bool val) {
    if (_hasNewComments != val) {
      _hasNewComments = val;
      notifyListeners();
    }
  }

  set story(Story val) {
    _story = val;
    notifyListeners();
  }

  set author(UserModel val) {
    _author = val;
    notifyListeners();
  }

  set discussion(List<Comment> val) {
    _discussion = val;
    notifyListeners();
  }

  set posts(List<Post> val) {
    _posts = val;
    notifyListeners();
  }

  set showDiscussion(bool val) {
    if (_showDiscussion != val) {
      _showDiscussion = val;
      notifyListeners();
    }
  }

  set discussionFullView(bool val) {
    if (_discussionFullView != val) {
      _discussionFullView = val;
      notifyListeners();
    }
  }

  set showCameraPreview(bool val) {
    if (_showCameraPreview != val) {
      _showCameraPreview = val;
      notifyListeners();
    }
  }

  set expandedDiscussionHeight(double val) {
    if (_expandedDiscussionHeight != val) {
      _expandedDiscussionHeight = val;
      notifyListeners();
    }
  }

  set discussionHeight(double val) {
    if (_discussionHeight != val) {
      _discussionHeight = val;
      notifyListeners();
    }
  }

  set keyboardIsOpen(bool val) {
    if (_keyboardIsOpen != val) {
      _keyboardIsOpen = val;
      notifyListeners();
    }
  }

  set expandedHeight(double val) {
    if (_expandedHeight != val) {
      _prevExpandedHeight = _expandedHeight;
      _expandedHeight = val;
      notifyListeners();
    }
  }

  set descriptionHeight(double val) {
    if (_descriptionHeight != val) {
      _descriptionHeight = val;
      notifyListeners();
    }
  }

  void resetState() {
    _showDiscussion = false;
    _discussionFullView = false;
    _keyboardIsOpen = false;
    _showCameraPreview = false;
    _hasNewComments = false;
    _expandedDiscussionHeight = 0.0;
    _posts = [];
    _story = null;
    // _scrollOffsets = [];
    _expandedHeight = 100.0;
    _prevExpandedHeight = 0.0;
    _descriptionHeight = 0.0;
  }

  List<Story> stories;

  // void setScrollOffset(int index, double offset) {
  //   _scrollOffsets.insert(index, offset);
  //   print('index: ${index}: ${_scrollOffsets[index]}');
  // }

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
    DocumentReference ref = _db.collection('stories').doc(storyId);
    return ref.snapshots();
  }

  Stream<List<QuerySnapshot>> streamDiscussion(Timestamp lastEntry) {
    CollectionReference ref = _db.collection('stories/${story.id}/discussion');
    Stream<QuerySnapshot> newPosts = ref
        .where('created_at', isGreaterThan: lastEntry)
        .orderBy('created_at')
        .snapshots();
    Stream<QuerySnapshot> oldPosts = ref
        .where('created_at', isLessThanOrEqualTo: lastEntry)
        .orderBy('created_at')
        .snapshots();
    // return newPosts;
    // return StreamZip([oldPosts, newPosts]);
    return StreamZip([newPosts]);
  }

  Stream<QuerySnapshot> streamPosts() {
    CollectionReference ref = _db.collection('stories/${story.id}/posts');
    Stream<QuerySnapshot> posts = ref.orderBy('timestamp').snapshots();
    return posts;
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

  Future addCommentToStoryDiscussion(String text, List<String> filePath) async {
    CollectionReference ref = _db.collection('stories/${story.id}/discussion');
    DocumentReference postRef = await ref.add({
      'text': text,
      'created_at': new DateTime.now(),
      'author': _auth.currentUser.uid,
      'media': [],
    });
    List<String> uploadUrls = [];
    uploadUrls = await uploadMediaForPost(filePath, postRef.id);
    postRef.update({
      'media': uploadUrls,
    });
  }

  Future<List<String>> uploadMediaForPost(
      List<String> filePath, String postId) async {
    List<String> uploadUrls = [];
    await Future.wait(filePath.map((String path) async {
      String fileName = path.split('/').last;
      final StorageReference storageReference =
          FirebaseStorage().ref().child('posts/$postId/$fileName');
      final StorageUploadTask uploadTask = storageReference.putFile(File(path));
      final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      if (taskSnapshot.error == null) {
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        uploadUrls.add(downloadUrl);
        print('Upload success');
      } else {
        print('Error from image repo ${taskSnapshot.error.toString()}');
        throw ('This file is not an image');
      }
    }));
    return uploadUrls;
  }

  // Future addStory(Story data) async {
  //   var result = await _api.addDocument(data.toJson());

  //   return;
  // }
}
