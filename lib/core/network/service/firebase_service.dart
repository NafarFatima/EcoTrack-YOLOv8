import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'network_info.dart';
import 'base_network_service.dart';

/// A centralized service for Firebase operations that provides
/// standardized exception handling and connectivity checks.
class FirebaseService extends BaseNetworkService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseService({
    required NetworkInfo networkInfo,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        super(networkInfo);

  FirebaseFirestore get firestore => _firestore;
  FirebaseAuth get auth => _auth;

  /// Helper to get the current user safely
  User? get currentUser => _auth.currentUser;

  /// Helper to check if a user is logged in
  bool get isAuthenticated => currentUser != null;
}
