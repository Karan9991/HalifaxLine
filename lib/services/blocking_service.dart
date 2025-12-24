// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../utils/constants.dart';
// import 'firestore_service.dart';

// class BlockingService {
//   final fs = FirestoreService();

//   Future<void> block(String me, String other) async {
//     final doc = fs.blocksCol(me).doc(other);
//     await doc.set({'createdAt': FieldValue.serverTimestamp()});
//   }

//   Future<void> unblock(String me, String other) async {
//     final doc = fs.blocksCol(me).doc(other);
//     await doc.delete();
//   }

//   Future<Set<String>> getBlocked(String me) async {
//     final q = await fs.blocksCol(me).get();
//     return q.docs.map((d) => d.id).toSet();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/constants.dart';
import 'firestore_service.dart';

class BlockingService {
  final fs = FirestoreService();

  Future<void> block(String me, String other) async {
    final doc = fs.blocksCol(me).doc(other);
    await doc.set({'createdAt': FieldValue.serverTimestamp()});
  }

  Future<void> unblock(String me, String other) async {
    final doc = fs.blocksCol(me).doc(other);
    await doc.delete();
  }

  Future<Set<String>> getBlocked(String me) async {
    final q = await fs.blocksCol(me).get();
    return q.docs.map((d) => d.id).toSet();
  }

  // NEW: real-time block status (me -> other)
  Stream<bool> blockStream(String me, String other) {
    return fs.blocksCol(me).doc(other).snapshots().map((d) => d.exists);
  }

  // NEW: one-shot check (me -> other)
  Future<bool> isBlocked(String me, String other) async {
    final d = await fs.blocksCol(me).doc(other).get();
    return d.exists;
  }
}