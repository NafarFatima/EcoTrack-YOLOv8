import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entity/eco_mission.dart';
import '../../domain/repository/mission_repository.dart';
import '../model/eco_mission_model.dart';

class MissionRepositoryImp implements MissionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<EcoMission>> getDailyMissions(String userId) {
    final today = _getTodayDateString();
    final controller = StreamController<List<EcoMission>>();
    
    StreamSubscription? missionsSub;
    StreamSubscription? completedSub;
    
    List<QueryDocumentSnapshot>? lastMissionsDocs;
    List<String>? lastCompletedIds;

    void emit() {
      if (lastMissionsDocs != null && lastCompletedIds != null) {
        final missions = lastMissionsDocs!.map((doc) {
          final isCompleted = lastCompletedIds!.contains(doc.id);
          return EcoMissionModel.fromMap(doc.id, doc.data() as Map<String, dynamic>, isCompleted);
        }).toList();
        if (!controller.isClosed) {
          controller.add(missions);
        }
      }
    }

    // React to both missions collection and user's daily completion document
    missionsSub = _firestore.collection('missions').snapshots().listen((snap) {
      lastMissionsDocs = snap.docs;
      if (lastCompletedIds == null) {
        // Optimization: if we don't have completions yet, we can't emit fully,
        // but we can try to fetch the completions once if snapshots take time
      }
      emit();
    }, onError: controller.addError);

    completedSub = _firestore
        .collection('users')
        .doc(userId)
        .collection('completedMissions')
        .doc(today)
        .snapshots()
        .listen((snap) {
      if (snap.exists) {
        lastCompletedIds = List<String>.from(snap.data()?['missionIds'] ?? []);
      } else {
        lastCompletedIds = [];
      }
      emit();
    }, onError: controller.addError);

    controller.onCancel = () {
      missionsSub?.cancel();
      completedSub?.cancel();
      controller.close();
    };

    return controller.stream;
  }

  @override
  Future<void> completeMission(String userId, String missionId) async {
    final today = _getTodayDateString();
    final userMissionRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('completedMissions')
        .doc(today);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(userMissionRef);
      
      if (!doc.exists) {
        transaction.set(userMissionRef, {
          'missionIds': [missionId],
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        final missionIds = List<String>.from(doc.data()?['missionIds'] ?? []);
        if (!missionIds.contains(missionId)) {
          missionIds.add(missionId);
          transaction.update(userMissionRef, {'missionIds': missionIds});
        }
      }

      // Also increment user points
      final missionDoc = await _firestore.collection('missions').doc(missionId).get();
      final points = missionDoc.data()?['points'] ?? 0;
      
      final userRef = _firestore.collection('users').doc(userId);
      transaction.update(userRef, {
        'impactPoints': FieldValue.increment(points),
      });
    });
  }

  String _getTodayDateString() {
    final now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }
}
