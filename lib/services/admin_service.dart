import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getPendingUsersStream() {
    return _firestore
        .collection('usuarios')
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  Future<void> approveUser(String userId) async {
    try {
      await _firestore
          .collection('usuarios')
          .doc(userId)
          .update({'status': 'approved'});
    } catch (e) {
      print('Error al aprobar usuario: $e');
      rethrow;
    }
  }

  Future<void> denyUser(String userId) async {
    try {
      await _firestore
          .collection('usuarios')
          .doc(userId)
          .update({'status': 'rejected'});
    } catch (e) {
      print('Error al denegar usuario: $e');
      rethrow;
    }
  }
}
