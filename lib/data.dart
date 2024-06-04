import 'package:cloud_firestore/cloud_firestore.dart';

class GetData {
  Stream<List<String>> getNotesFromFirestore() {
    return FirebaseFirestore.instance.collection('notes').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)?['note'] as String)
          .where((note) => note != null)
          .toList();
    });
  }
}
