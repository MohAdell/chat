import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Contacts/model/roomModel.dart';
import '../../Profile/model/users_info.dart';
import '../../chat/model/chat_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../notifcations.dart';
class FireBaseDataAll {
  final FirebaseFirestore _firestor = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  String get myUid => _firebaseAuth.currentUser!.uid;

  Future creatUser(UserProfile userprofil) async {
    try {
      await _firestor
          .collection('users')
          .doc(userprofil.id)
          .set(userprofil.toJson());
      print("User secces created ");
    } catch (e) {
      print("error when you created user $e");
    }
  }

  Stream<List<UserProfile>> getAllUsers() {
    return _firestor.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserProfile.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<UserProfile>> getAllUsersWithoutme() {
    return _firestor.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserProfile.fromJson(doc.data()))
          .where((user) => user.id != myUid)
          .toList();
    });
  }

  Future createRoom(String userId) async {
    try {
      CollectionReference chatroom = _firestor.collection('rooms');
      final sortedmemers = [myUid, userId]..sort((a, b) => a.compareTo(b));
      QuerySnapshot existChatrooom =
          await chatroom.where('members', isEqualTo: sortedmemers).get();
      if (existChatrooom.docs.isNotEmpty) {
        return existChatrooom.docs.first.id;
      } else {
        final chatroomid = _firestor.collection('rooms').doc().id;
        Room c = Room(
          id: chatroomid,
          createdAt: DateTime.now().toIso8601String(),
          lastMessage: "",
          members: sortedmemers,
          lastMessageTime: DateTime.now().toIso8601String(),
        );
        await _firestor.collection('rooms').doc(chatroomid).set(c.toJson());
      }
    } catch (e) {
      return e.toString();
    }
  }

  Stream<List<Room>> getAllRooms() {
    return _firestor
        .collection('rooms')
        .where('members', arrayContains: myUid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Room.fromJson(doc.data())).toList());
  }

  Future createMessage(
      String toid, String msgs, String roomid, String type) async {
    final msgid = _firestor.collection('messages').doc().id;

    Message message = Message(
        id: msgid,
        toId: toid,
        fromId: myUid,
        msg: msgs,
        read: false,
        createdAt: DateTime.now().toIso8601String(),
        type: type);

    DocumentReference myroom = _firestor.collection('rooms').doc(roomid);

    await myroom.collection('messages').doc(msgid).set(message.toJson());

    await myroom.update(
        {'last_message': message.msg, 'last_message_time': message.createdAt});

    DocumentSnapshot user =
    await _firestor.collection('users').doc(message.toId).get();
    String pushtokent = user.get('push_token');
    String username = user.get('name');

    // if (pushtokent != null && pushtokent.isNotEmpty) {
    //   await Nofifcation().senNotifaction(message.msg, username, pushtokent);
    // }
  }

  Stream<List<Message>> getMessages(String roomid) {
    return _firestor
        .collection('rooms')
        .doc(roomid)
        .collection('messages')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }

  Future imageSorge(File file, String roomid) async {
    String ext = file.path.split('.').last;
    // this is path
    final ref = firebaseStorage.ref().child('images/$roomid/'
        '${DateTime.now().microsecondsSinceEpoch}.$ext');

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }
  Future<void> updateUserToken(String userId) async {
    String? token = await Nofifcation().getDevicesToken();
    if (token != null) {
      await _firestor.collection('users').doc(userId).update({
        'push_token': token,
      });
    }
  }

}
