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
}