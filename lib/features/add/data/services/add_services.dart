import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AddServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> getCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs;
  }

  Future<void> logWaste(String userId, Map<String, dynamic> logData) async {
    final logRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('logs')
        .add(logData);

    debugPrint("AddServices: Log added with ID: ${logRef.id}");
    
    // Update total points in user document
    await _firestore.collection('users').doc(userId).set({
      'impactPoints': FieldValue.increment(logData['pointsEarned']),
    }, SetOptions(merge: true));
    debugPrint("AddServices: User points incremented by ${logData['pointsEarned']}");
  }
}
