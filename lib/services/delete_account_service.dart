import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/constants.dart';
import 'firestore_service.dart';
import 'storage_service.dart';
import 'auth_service.dart';

class DeleteAccountService {
  final fs = FirestoreService();
  final storage = StorageService();
  final auth = AuthService();

  Future<void> deleteEverything(String uid) async {
    // Delete avatar
    await storage.deleteAvatar(uid);

    // Remove user from chats and delete their messages
    final chats = await fs.chatsCol().where('members', arrayContains: uid).get();

    for (final c in chats.docs) {
      final chatId = c.id;
      // delete user's messages
      final msgs = await fs.messagesCol(chatId).where('senderId', isEqualTo: uid).get();
      final batch = FirebaseFirestore.instance.batch();
      for (final m in msgs.docs) {
        batch.delete(m.reference);
      }
      await batch.commit();

      // remove from members
      final members = (c['members'] as List).cast<String>().where((m) => m != uid).toList();
      if (members.isEmpty) {
        await c.reference.delete();
      } else {
        await c.reference.update({'members': members});
      }
    }

    // Delete matches where user participated
    final matches = await fs.matchesCol().where('userIds', arrayContains: uid).get();
    for (final m in matches.docs) {
      await m.reference.delete();
    }

    // Delete blocks subcollection
    final blocks = await fs.blocksCol(uid).get();
    for (final b in blocks.docs) {
      await b.reference.delete();
    }

    // Delete user profile
    await fs.userDoc(uid).delete();

    // Finally delete auth user
    await auth.deleteAuthUser();
  }
}