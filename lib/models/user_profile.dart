import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String? displayName;
  final String? photoUrl;
  final DateTime? dob;
  final bool is18PlusVerified;
  final bool isGeoVerified;
  final String? activeBusRoute;
  final DateTime? timeStart;
  final DateTime? timeEnd;
  final String? dayKey;
  final List<String> activeSlotKeys;

  UserProfile({
    required this.uid,
    this.displayName,
    this.photoUrl,
    this.dob,
    this.is18PlusVerified = false,
    this.isGeoVerified = false,
    this.activeBusRoute,
    this.timeStart,
    this.timeEnd,
    this.dayKey,
    this.activeSlotKeys = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'dob': dob != null ? Timestamp.fromDate(dob!) : null,
      'is18PlusVerified': is18PlusVerified,
      'isGeoVerified': isGeoVerified,
      'activeBusRoute': activeBusRoute,
      'timeStart': timeStart != null ? Timestamp.fromDate(timeStart!) : null,
      'timeEnd': timeEnd != null ? Timestamp.fromDate(timeEnd!) : null,
      'dayKey': dayKey,
      'activeSlotKeys': activeSlotKeys,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory UserProfile.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserProfile(
      uid: data['uid'] ?? doc.id,
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      dob: (data['dob'] as Timestamp?)?.toDate(),
      is18PlusVerified: data['is18PlusVerified'] == true,
      isGeoVerified: data['isGeoVerified'] == true,
      activeBusRoute: data['activeBusRoute'],
      timeStart: (data['timeStart'] as Timestamp?)?.toDate(),
      timeEnd: (data['timeEnd'] as Timestamp?)?.toDate(),
      dayKey: data['dayKey'],
      activeSlotKeys: (data['activeSlotKeys'] as List?)?.cast<String>() ?? [],
    );
  }

  UserProfile copyWith({
    String? displayName,
    String? photoUrl,
    DateTime? dob,
    bool? is18PlusVerified,
    bool? isGeoVerified,
    String? activeBusRoute,
    DateTime? timeStart,
    DateTime? timeEnd,
    String? dayKey,
    List<String>? activeSlotKeys,
  }) {
    return UserProfile(
      uid: uid,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      dob: dob ?? this.dob,
      is18PlusVerified: is18PlusVerified ?? this.is18PlusVerified,
      isGeoVerified: isGeoVerified ?? this.isGeoVerified,
      activeBusRoute: activeBusRoute ?? this.activeBusRoute,
      timeStart: timeStart ?? this.timeStart,
      timeEnd: timeEnd ?? this.timeEnd,
      dayKey: dayKey ?? this.dayKey,
      activeSlotKeys: activeSlotKeys ?? this.activeSlotKeys,
    );
  }
}