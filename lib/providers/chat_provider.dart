// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import '../models/message.dart';
// import '../services/firestore_service.dart';

// class ChatProvider extends ChangeNotifier {
//   final fs = FirestoreService();

//   Stream<List<Message>> messages(String chatId) {
//     return fs.messagesCol(chatId)
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snap) => snap.docs.map(Message.fromDoc).toList());
//   }

//   Future<void> sendMessage({
//     required String chatId,
//     required String senderId,
//     required String text,
//   }) async {
//     final ref = fs.messagesCol(chatId).doc();
//     final msg = Message(
//       id: ref.id,
//       chatId: chatId,
//       senderId: senderId,
//       text: text.trim(),
//       createdAt: DateTime.now(),
//     );
//     if (msg.text.isEmpty) return;
//     await ref.set(msg.toMap());
//     await fs.chatDoc(chatId).update({
//       'lastMessage': msg.toMap(),
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   Stream<List<Map<String, dynamic>>> myChats(String uid) {
//     return fs.chatsCol()
//         .where('members', arrayContains: uid)
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((snap) => snap.docs.map((d) => d.data() as Map<String, dynamic>).toList());
//   }
// }











import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/message.dart';
import '../services/firestore_service.dart';

class ChatProvider extends ChangeNotifier {
  final fs = FirestoreService();

  Stream<List<Message>> messages(String chatId) {
    return fs.messagesCol(chatId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Message.fromDoc).toList());
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    final ref = fs.messagesCol(chatId).doc();
    final msg = Message(
      id: ref.id,
      chatId: chatId,
      senderId: senderId,
      text: text.trim(),
      createdAt: DateTime.now(),
    );
    if (msg.text.isEmpty) return;
    await ref.set(msg.toMap());
    await fs.chatDoc(chatId).set({
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': msg.toMap(),
    }, SetOptions(merge: true));
  }

  // Avoid composite index by removing orderBy and sorting client side.
  Stream<List<Map<String, dynamic>>> myChats(String uid) {
    DateTime _ts(dynamic v) {
      if (v is Timestamp) return v.toDate();
      if (v is DateTime) return v;
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    return fs.chatsCol()
        .where('members', arrayContains: uid)
        .snapshots()
        .map((snap) {
          final items = snap.docs.map((d) {
            final data = (d.data() as Map<String, dynamic>);
            // Ensure we always have an id
            data['id'] = data['id'] ?? d.id;
            return data;
          }).toList();

          // Prefer updatedAt, fallback to createdAt
          items.sort((a, b) {
            final ad = _ts(a['updatedAt'] ?? a['createdAt']);
            final bd = _ts(b['updatedAt'] ?? b['createdAt']);
            return bd.compareTo(ad);
          });
          return items;
        });
  }
}