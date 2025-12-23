import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';

class ProfileProvider extends ChangeNotifier {
  final fs = FirestoreService();
  UserProfile? _me;

  UserProfile? get me => _me;

  Future<void> load(String uid) async {
    final doc = await fs.userDoc(uid).get();
    if (doc.exists) {
      _me = UserProfile.fromDoc(doc);
    }
    notifyListeners();
  }

  Future<void> createOrUpdate(UserProfile profile) async {
    await fs.userDoc(profile.uid).set(profile.toMap(), SetOptions(merge: true));
    _me = profile;
    notifyListeners();
  }

  Future<void> updateAvailability({
    required String uid,
    required String busRoute,
    required DateTime start,
    required DateTime end,
    required String dayKey,
    required List<String> slotKeys,
  }) async {
    await fs.userDoc(uid).set({
      'activeBusRoute': busRoute,
      'timeStart': Timestamp.fromDate(start),
      'timeEnd': Timestamp.fromDate(end),
      'dayKey': dayKey,
      'activeSlotKeys': slotKeys,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    logd('Updated availability for $uid');
    await load(uid);
  }
}