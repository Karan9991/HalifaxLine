// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import '../models/match_model.dart';
// import '../services/firestore_service.dart';

// class MatchProvider extends ChangeNotifier {
//   final fs = FirestoreService();
//   Stream<List<MatchModel>> matchesFor(String uid) {
//     return fs.matchesCol()
//         .where('userIds', arrayContains: uid)
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snap) => snap.docs.map(MatchModel.fromDoc).toList());
//   }
// }

import 'package:flutter/foundation.dart';
import '../models/match_model.dart';
import '../services/firestore_service.dart';

class MatchProvider extends ChangeNotifier {
  final fs = FirestoreService();

  // Avoid composite index by removing orderBy and sorting client side.
  Stream<List<MatchModel>> matchesFor(String uid) {
    return fs.matchesCol()
        .where('userIds', arrayContains: uid)
        .snapshots()
        .map((snap) {
          final list = snap.docs.map(MatchModel.fromDoc).toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }
}