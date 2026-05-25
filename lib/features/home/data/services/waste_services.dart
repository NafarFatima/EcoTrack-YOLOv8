import 'package:cloud_firestore/cloud_firestore.dart';

class WasteServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> getCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs;
  }

  Stream<QuerySnapshot> getWasteLogs(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('logs')
        .snapshots();
  }

  Future<void> logWaste(String userId, Map<String, dynamic> logData) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('logs')
        .add(logData);
    
    // Update total points in user document
    await _firestore.collection('users').doc(userId).set({
      'impactPoints': FieldValue.increment(logData['pointsEarned']),
    }, SetOptions(merge: true));
  }
}
