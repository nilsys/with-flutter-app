import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Api {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;
  CollectionReference ref;

  Api(this.path) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.get();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }

  Stream<DocumentSnapshot> streamDoc(String id) {
    return ref.doc(id).snapshots();
  }

  Future<void> removeDocument(String id) {
    return ref.doc(id).delete();
  }

  Future<void> addDocument(Map data, {String id}) {
    if (id != null) {
      print('id: $id');
      return ref.doc(id).set(data);
    }
    return ref.add(data);
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.doc(id).set(
        data,
        SetOptions(
          merge: true,
        ));
  }
}
