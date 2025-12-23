// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:collection/collection.dart';
// import 'package:uuid/uuid.dart';

// import '../models/user_profile.dart';
// import '../models/match_model.dart';
// import '../utils/constants.dart';
// import 'firestore_service.dart';

// class MatchingService {
//   final fs = FirestoreService();

//   // Build deterministic match/chat IDs so duplicates aren’t created.
//   String _pairId(String a, String b, String dayKey, String bus) {
//     final sorted = [a, b]..sort();
//     return '${sorted[0]}_${sorted[1]}_$dayKey\_$bus';
//   }

//   Future<void> generateMatchesForUser(UserProfile me) async {
//     if (me.activeBusRoute == null || me.activeSlotKeys.isEmpty || me.dayKey == null) return;

//     // Firestore limitation: array-contains-any max 10 items.
//     final slots = me.activeSlotKeys.take(10).toList();

//     final q = await fs.usersCol()
//         .where('is18PlusVerified', isEqualTo: true)
//         .where('isGeoVerified', isEqualTo: true)
//         .where('activeBusRoute', isEqualTo: me.activeBusRoute)
//         .where('dayKey', isEqualTo: me.dayKey)
//         .where('activeSlotKeys', arrayContainsAny: slots)
//         .limit(50)
//         .get();

//     final others = q.docs
//         .map((d) => UserProfile.fromDoc(d))
//         .where((u) => u.uid != me.uid)
//         .toList();

//     for (final you in others) {
//       final overlap = me.activeSlotKeys.toSet().intersection(you.activeSlotKeys.toSet());
//       if (overlap.isEmpty) continue;

//       final id = _pairId(me.uid, you.uid, me.dayKey!, me.activeBusRoute!);
//       final matchDoc = fs.matchDoc(id);
//       final existing = await matchDoc.get();
//       if (existing.exists) continue;

//       final chatId = id; // Reuse id for chat
//       await fs.chatDoc(chatId).set({
//         'id': chatId,
//         'members': [me.uid, you.uid],
//         'busRoute': me.activeBusRoute,
//         'dayKey': me.dayKey,
//         'createdAt': FieldValue.serverTimestamp(),
//         'lastMessage': null,
//       });

//       final match = MatchModel(
//         id: id,
//         userIds: [me.uid, you.uid]..sort(),
//         busRoute: me.activeBusRoute!,
//         dayKey: me.dayKey!,
//         chatId: chatId,
//         createdAt: DateTime.now(),
//       );
//       await matchDoc.set(match.toMap());
//     }
//   }

//   Future<List<UserProfile>> potentialMatches(UserProfile me) async {
//     if (me.activeBusRoute == null || me.activeSlotKeys.isEmpty || me.dayKey == null) return [];
//     final slots = me.activeSlotKeys.take(10).toList();

//     final q = await fs.usersCol()
//         .where('is18PlusVerified', isEqualTo: true)
//         .where('isGeoVerified', isEqualTo: true)
//         .where('activeBusRoute', isEqualTo: me.activeBusRoute)
//         .where('dayKey', isEqualTo: me.dayKey)
//         .where('activeSlotKeys', arrayContainsAny: slots)
//         .limit(30)
//         .get();

//     final results = q.docs
//         .map((d) => UserProfile.fromDoc(d))
//         .where((u) => u.uid != me.uid)
//         .toList();

//     // Remove those already matched
//     final matchesSnap = await fs.matchesCol()
//         .where('userIds', arrayContains: me.uid)
//         .where('dayKey', isEqualTo: me.dayKey)
//         .where('busRoute', isEqualTo: me.activeBusRoute)
//         .get();

//     final matchedIds = matchesSnap.docs
//         .map((d) => (d['userIds'] as List?)?.cast<String>() ?? const [])
//         .flattened
//         .where((id) => id != me.uid)
//         .toSet();

//     return results.where((u) => !matchedIds.contains(u.uid)).toList();
//   }
// }









import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/user_profile.dart';
import '../models/match_model.dart';
import '../utils/constants.dart';
import 'firestore_service.dart';
import 'blocking_service.dart';

class MatchingService {
  final fs = FirestoreService();
  final _blockSvc = BlockingService();

  String _pairId(String a, String b, String dayKey, String bus) {
    final sorted = [a, b]..sort();
    return '${sorted[0]}_${sorted[1]}_$dayKey\_$bus';
  }

  Future<List<UserProfile>> _candidatesBySlots(UserProfile me) async {
    // Handle Firestore array-contains-any limit (10) by chunking slot keys.
    final slots = me.activeSlotKeys;
    if (slots.isEmpty || me.activeBusRoute == null || me.dayKey == null) return [];

    final seen = <String>{};
    final users = <UserProfile>[];

    for (int i = 0; i < slots.length; i += 10) {
      final slice = slots.sublist(i, min(i + 10, slots.length));
      final q = await fs.usersCol()
          .where('is18PlusVerified', isEqualTo: true)
          .where('isGeoVerified', isEqualTo: true)
          .where('activeBusRoute', isEqualTo: me.activeBusRoute)
          .where('dayKey', isEqualTo: me.dayKey)
          .where('activeSlotKeys', arrayContainsAny: slice)
          .limit(50)
          .get();

      for (final d in q.docs) {
        if (d.id == me.uid) continue;
        if (seen.add(d.id)) {
          users.add(UserProfile.fromDoc(d));
        }
      }
    }
    return users;
  }

  Future<void> generateMatchesForUser(UserProfile me) async {
    if (me.activeBusRoute == null || me.activeSlotKeys.isEmpty || me.dayKey == null) return;

    final blocked = await _blockSvc.getBlocked(me.uid);
    final others = await _candidatesBySlots(me);

    for (final you in others) {
      if (blocked.contains(you.uid)) continue;

      final overlap = me.activeSlotKeys.toSet().intersection(you.activeSlotKeys.toSet());
      if (overlap.isEmpty) continue;

      final id = _pairId(me.uid, you.uid, me.dayKey!, me.activeBusRoute!);
      final matchRef = fs.matchDoc(id);
      final existing = await matchRef.get();
      if (existing.exists) continue;

      final chatId = id;
      final chatRef = fs.chatDoc(chatId);
      final chat = await chatRef.get();
      if (!chat.exists) {
        await chatRef.set({
          'id': chatId,
          'members': [me.uid, you.uid],
          'busRoute': me.activeBusRoute,
          'dayKey': me.dayKey,
          'createdAt': FieldValue.serverTimestamp(),
          'lastMessage': null,
        });
      }

      final match = MatchModel(
        id: id,
        userIds: [me.uid, you.uid]..sort(),
        busRoute: me.activeBusRoute!,
        dayKey: me.dayKey!,
        chatId: chatId,
        createdAt: DateTime.now(),
      );
      await matchRef.set(match.toMap());
    }
  }

  Future<List<UserProfile>> potentialMatches(UserProfile me) async {
    if (me.activeBusRoute == null || me.activeSlotKeys.isEmpty || me.dayKey == null) return [];
    final candidates = await _candidatesBySlots(me);

    // Exclude already matched
    final matchesSnap = await fs.matchesCol()
        .where('userIds', arrayContains: me.uid)
        .where('dayKey', isEqualTo: me.dayKey)
        .where('busRoute', isEqualTo: me.activeBusRoute)
        .get();
    final matchedIds = matchesSnap.docs
        .map((d) => ((d.data() as Map<String, dynamic>)['userIds'] as List).cast<String>())
        .expand((e) => e)
        .where((id) => id != me.uid)
        .toSet();

    return candidates
        .where((u) => !matchedIds.contains(u.uid))
        .toList();
  }
}