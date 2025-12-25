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
//     await fs.chatDoc(chatId).set({
//       'updatedAt': FieldValue.serverTimestamp(),
//       'lastMessage': msg.toMap(),
//     }, SetOptions(merge: true));
//   }

//   // Avoid composite index by removing orderBy and sorting client side.
//   Stream<List<Map<String, dynamic>>> myChats(String uid) {
//     DateTime _ts(dynamic v) {
//       if (v is Timestamp) return v.toDate();
//       if (v is DateTime) return v;
//       return DateTime.fromMillisecondsSinceEpoch(0);
//     }

//     return fs.chatsCol()
//         .where('members', arrayContains: uid)
//         .snapshots()
//         .map((snap) {
//           final items = snap.docs.map((d) {
//             final data = (d.data() as Map<String, dynamic>);
//             // Ensure we always have an id
//             data['id'] = data['id'] ?? d.id;
//             return data;
//           }).toList();

//           // Prefer updatedAt, fallback to createdAt
//           items.sort((a, b) {
//             final ad = _ts(a['updatedAt'] ?? a['createdAt']);
//             final bd = _ts(b['updatedAt'] ?? b['createdAt']);
//             return bd.compareTo(ad);
//           });
//           return items;
//         });
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
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final ref = fs.messagesCol(chatId).doc();
    final msg = Message(
      id: ref.id,
      chatId: chatId,
      senderId: senderId,
      text: trimmed,
      createdAt: DateTime.now(),
    );

    // Write message
    await ref.set(msg.toMap());

    // Update chat metadata
    await fs.chatDoc(chatId).set({
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': msg.toMap(),
    }, SetOptions(merge: true));

    // Unhide for all members on new activity so the conversation reappears
    try {
      final chatSnap = await fs.chatDoc(chatId).get();
      final members = ((chatSnap.data() as Map<String, dynamic>?)?['members'] as List?)?.cast<String>() ?? <String>[];
      if (members.isNotEmpty) {
        await fs.chatDoc(chatId).set({
          'hiddenFor': FieldValue.arrayRemove(members),
        }, SetOptions(merge: true));
      } else {
        // At least unhide for sender
        await fs.chatDoc(chatId).set({
          'hiddenFor': FieldValue.arrayRemove([senderId]),
        }, SetOptions(merge: true));
      }
    } catch (_) {
      // Ignore – hiddenFor is optional
    }
  }

  // Mark this chat hidden for a specific user (soft delete)
  Future<void> hideChatForUser({required String chatId, required String uid}) async {
    await fs.chatDoc(chatId).set({
      'hiddenFor': FieldValue.arrayUnion([uid]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Stream my chats, excluding those I've hidden; sort by updatedAt/createdAt desc (no composite index needed).
  
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
          data['id'] = data['id'] ?? d.id;
          return data;
        }).where((data) {
          final hidden = (data['hiddenFor'] as List?)?.cast<String>() ?? const <String>[];
          return !hidden.contains(uid);
        }).toList();

        items.sort((a, b) {
          final ad = _ts(a['updatedAt'] ?? a['createdAt']);
          final bd = _ts(b['updatedAt'] ?? b['createdAt']);
          return bd.compareTo(ad);
        });
        return items;
      });
}

  // Stream<List<Map<String, dynamic>>> myChats(String uid) {
  //   DateTime _ts(dynamic v) {
  //     if (v is Timestamp) return v.toDate();
  //     if (v is DateTime) return v;
  //     return DateTime.fromMillisecondsSinceEpoch(0);
  //   }

  //   return fs.chatsCol()
  //       .where('members', arrayContains: uid)
  //       .snapshots()
  //       .map((snap) {
  //         final items = snap.docs.map((d) {
  //           final data = (d.data() as Map<String, dynamic>);
  //           data['id'] = data['id'] ?? d.id;
  //           return data;
  //         }).where((data) {
  //           final hidden = (data['hiddenFor'] as List?)?.cast<String>() ?? const <String>[];
  //           return !hidden.contains(uid);
  //         }).toList();

  //         // Prefer updatedAt, fallback to createdAt
  //         items.sort((a, b) {
  //           final ad = _ts(a['updatedAt'] ?? a['createdAt']);
  //           final bd = _ts(b['updatedAt'] ?? b['createdAt']);
  //           return bd.compareTo(ad);
  //         });
  //         return items;
  //       });
  // }
}