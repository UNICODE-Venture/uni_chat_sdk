import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../uni_chat_sdk.dart';
import 'collections.dart';
import 'service_res.dart';

final _fireStore = FirebaseFirestore.instance;
final _chatRoomCollection = _fireStore.collection(Collections.chatRooms);

abstract class IChatRepo {
  /// [listenToTheChatRooms] is a method to listen to the chat rooms
  Stream<List<UniChatRoom>> listenToTheChatRooms();

  /// [createChatRoom] is a method to create a chat room
  Future<ServiceResponse> createChatRoom(UniChatRoom room);

  /// [updateChatRoom] is a method to update a chat room
  Future<ServiceResponse> updateChatRoom(UniChatRoom room);

  /// [listenToTheChatsFromRoom] is a method to listen to the chat rooms messages
  Stream<List<UniChatMessage>> listenToTheChatsFromRoom(UniChatRoom room);

  /// [sendChatMessage] is a method to send a chat message
  Future<ServiceResponse> sendChatMessage(
      UniChatRoom room, UniChatMessage message);

  /// [updateChatMessage] is a method to update a chat message
  Future<ServiceResponse> updateChatMessage(
      UniChatRoom room, UniChatMessage message);
}

class ChatRepo implements IChatRepo {
  @override
  Stream<List<UniChatRoom>> listenToTheChatRooms() {
    return _chatRoomCollection.snapshots().map((qDocs) =>
        qDocs.docs.map((r) => UniChatRoom.fromJson(r.data())).toList());
  }

  @override
  Future<ServiceResponse> createChatRoom(UniChatRoom room) {
    return firebaseHandler(
        method: _chatRoomCollection.doc(room.roomId).set(room.toJson()));
  }

  @override
  Future<ServiceResponse> updateChatRoom(UniChatRoom room) {
    return firebaseHandler(
        method: _chatRoomCollection.doc(room.roomId).update(room.toJson()));
  }

  @override
  Future<ServiceResponse> sendChatMessage(
      UniChatRoom room, UniChatMessage message) async {
    final chatRes = await firebaseHandler(
        method: _chatRoomCollection
            .doc(room.roomId)
            .collection(Collections.chatMessages)
            .doc(message.messageId)
            .set(message.toJson()));
    room.recentChat = message;
    ServiceResponse roomRes = await updateChatRoom(room);
    roomRes.isSuccessFul = chatRes.isSuccessFul && roomRes.isSuccessFul;
    return roomRes;
  }

  @override
  Future<ServiceResponse> updateChatMessage(
      UniChatRoom room, UniChatMessage message) {
    return firebaseHandler(
        method: _chatRoomCollection
            .doc(room.roomId)
            .collection(Collections.chatMessages)
            .doc(message.messageId)
            .update(room.toJson()));
  }

  @override
  Stream<List<UniChatMessage>> listenToTheChatsFromRoom(UniChatRoom room) {
    return _chatRoomCollection
        .doc(room.roomId)
        .collection(Collections.chatMessages)
        .orderBy("sentAt", descending: true)
        .snapshots()
        .map((qDocs) =>
            qDocs.docs.map((m) => UniChatMessage.fromJson(m.data())).toList());
  }
}
