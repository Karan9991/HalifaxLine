import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String id;
  final List<String> userIds;
  final String busRoute;
  final String dayKey;
  final String chatId;
  final DateTime createdAt;

  MatchModel({
    required this.id,
    required this.userIds,
    required this.busRoute,
    required this.dayKey,
    required this.chatId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userIds': userIds,
      'busRoute': busRoute,
      'dayKey': dayKey,
      'chatId': chatId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory MatchModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return MatchModel(
      id: data['id'] ?? doc.id,
      userIds: (data['userIds'] as List?)?.cast<String>() ?? const [],
      busRoute: data['busRoute'] ?? '',
      dayKey: data['dayKey'] ?? '',
      chatId: data['chatId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}