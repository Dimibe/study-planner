import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  FirestoreService();

  Future<DocumentSnapshot> getDocument(String col, String doc) {
    return _instance.collection(col).doc(doc).get();
  }

  Future<void> saveDocument(String col, String doc, var data) {
    return _instance.collection(col).doc(doc).set(data);
  }
}
