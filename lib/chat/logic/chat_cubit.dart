import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatt/core/firebase/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../../core/firebase/firebase_data.dart';
import '../model/chat_model.dart';
import 'chat_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final FireBaseDataAll _firebaseData;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MessageCubit(this._firebaseData) : super(MessageInitial());
  final TextEditingController messageContrller = TextEditingController();
  StreamSubscription<List<Message>>? messgessub;
  String roommyId = "";

  Future<void> fetchMessages(String roomId) async {
    emit(MessagesLoading());
    try {
      roommyId = roomId;
      messgessub = _firebaseData.getMessages(roomId).listen((messages) {
        emit(MessagesLoaded(messages));
      });
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }

  Future sendMessage(String toid, String type, {String? imgURl}) async {
    try {
      if (roommyId.isNotEmpty) {
        String msssg = (type == "text") ? messageContrller.text : imgURl!;
        await _firebaseData.createMessage(toid, msssg, roommyId, type);
      }

      await fetchMessages(roommyId);
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }

  Future sendImage(File file, String toid) async {
    try {
      if (roommyId.isNotEmpty) {
        String urlimage = await _firebaseData.imageSorge(file, roommyId);
        await sendMessage(toid, 'image', imgURl: urlimage);
      }
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }

  Future<void> sendMessages(String receiverID, message,
      {String? imgURl}) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    Message newMessage = Message(id: currentUserId,
        toId: currentUserEmail,
        fromId: receiverID,
        msg: message,
        read: true,
        createdAt: "${timestamp}",
        type: "text");

    List<String> ids = [currentUserId, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore.collection('users').doc(chatRoomID).collection(
        message.toId).get();
  }

}