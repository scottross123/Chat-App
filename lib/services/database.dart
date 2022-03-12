import 'dart:async';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/models/convo.dart';

class Database {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addUser(User user) async {
    await _db.collection('users').doc(user.uid).set(
        {'id': user.uid, 'name': user.displayName, 'email': user.email});
  }

  static Stream<List<ChatUser>> streamUsers() {
    return _db
        .collection('users')
        .snapshots()
        .map<List<ChatUser>>((QuerySnapshot<Map<String, dynamic>> list) => list.docs
            .map<ChatUser>((DocumentSnapshot<Map<String, dynamic>> snap) => ChatUser.fromMap(snap.data()))
            .toList())
        .handleError((dynamic e) {
      print(e);
    });
  }

  static Stream<List<ChatUser>> getUsersByList(List<String> userIds) {
    final List<Stream<ChatUser>> streams = [];
    for (String id in userIds) {
      streams.add(_db
          .collection('users')
          .doc(id)
          .snapshots()
          .map<ChatUser>((DocumentSnapshot<Map<String, dynamic>> snap) => ChatUser.fromMap(snap.data())));
    }
    return StreamZip<ChatUser>(streams).asBroadcastStream();
  }

  static Stream<List<Convo>> streamConversations(String uid) {
    return _db
        .collection('messages')
        .orderBy('lastMessage.timestamp', descending: true)
        .where('users', arrayContains: uid)
        .snapshots()
        .map<List<Convo>>((QuerySnapshot<Map<String, dynamic>> list) => list.docs
            .map<Convo>((DocumentSnapshot<Map<String, dynamic>> doc) => Convo.fromFireStore(doc))
            .toList());
  }

  static void sendMessage(
    String convoID,
    String id,
    String pid,
    String content,
    String timestamp,
  ) {
    final DocumentReference convoDoc =
        FirebaseFirestore.instance.collection('messages').doc(convoID);

    convoDoc.set(<String, dynamic>{
      'lastMessage': <String, dynamic>{
        'idFrom': id,
        'idTo': pid,
        'timestamp': timestamp,
        'content': content,
        'read': false
      },
      'users': <String>[id, pid]
    }).then((dynamic success) {
      final DocumentReference messageDoc = FirebaseFirestore.instance
          .collection('messages')
          .doc(convoID)
          .collection(convoID)
          .doc(timestamp);

      FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
        await transaction.set(
          messageDoc,
          <String, dynamic>{
            'idFrom': id,
            'idTo': pid,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'read': false
          },
        );
      });
    });
  }

  static void updateMessageRead(DocumentSnapshot doc, String convoID) {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(convoID)
        .collection(convoID)
        .doc(doc.id);

    documentReference.set(<String, dynamic>{'read': true}, SetOptions(merge: true));
  }

  static void updateLastMessage(
      DocumentSnapshot doc, String uid, String pid, String convoID) {
    final DocumentReference documentReference =
        _db.collection('messages').doc(convoID);

    documentReference
        .set(<String, dynamic>{
          'lastMessage': <String, dynamic>{
            'idFrom': doc['idFrom'],
            'idTo': doc['idTo'],
            'timestamp': doc['timestamp'],
            'content': doc['content'],
            'read': doc['read']
          },
          'users': <String>[uid, pid]
        })
        .then((dynamic success) {})
        .catchError((dynamic error) {
          print(error);
        });
  }

  static void updateRating(String id, double rating) {
    final DocumentReference documentReference = _db.collection('users').doc(id);
    documentReference.update({'rating': rating});
  }

}
