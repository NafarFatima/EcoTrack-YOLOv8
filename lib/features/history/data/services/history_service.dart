import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getWasteLogs(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('logs')
        .snapshots();
  }

  Future<List<QueryDocumentSnapshot>> getCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs;
  }
}
