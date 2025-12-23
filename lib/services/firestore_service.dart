import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/constants.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  CollectionReference usersCol() => _db.collection(AppConstants.usersCollection);
  CollectionReference matchesCol() => _db.collection(AppConstants.matchesCollection);
  CollectionReference chatsCol() => _db.collection(AppConstants.chatsCollection);

  DocumentReference userDoc(String uid) => usersCol().doc(uid);
  DocumentReference chatDoc(String chatId) => chatsCol().doc(chatId);
  DocumentReference matchDoc(String id) => matchesCol().doc(id);

  CollectionReference messagesCol(String chatId) =>
      chatsCol().doc(chatId).collection(AppConstants.messagesSubcollection);

  CollectionReference blocksCol(String uid) =>
      userDoc(uid).collection(AppConstants.blocksSubcollection);
}