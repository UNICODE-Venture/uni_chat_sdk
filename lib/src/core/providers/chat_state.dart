// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';

import '../../../uni_chat_sdk.dart';

import '../../global/widgets/toasts.dart';
import '../../utils/navigation.dart';

import '../repo/chat_repo.dart';
import '../services/storage/storage_service.dart';
import 'send_chat_state.dart';

/// Voice state-provider
final chatStateProvider =
    NotifierProvider<ChatStateNotifier, ChatState>(() => ChatStateNotifier());

/// [StorageServices] is the storage service instance
final _storageService = StorageServices.instance;

class ChatStateNotifier extends Notifier<ChatState> {
  @override
  ChatState build() => ChatState();
  final _chatRepo = ChatRepo();

  /// [roomsStreamSubscription] is a stream subscription to listen to chat rooms
  StreamSubscription<List<UniChatRoom>>? roomsStreamSubscription;

  /// [listenToChatRooms] is a method to listen to chat messages
  void listenToChatRooms() {
    // Check if the stream subscription is null to avoid multiple subscriptions
    if (roomsStreamSubscription == null) {
      roomsStreamSubscription =
          _chatRepo.listenToTheChatRooms().listen((rooms) {
        final updatedCurrentRoom = rooms.findOrNull(
            (r) => r.roomId.isEqualTo(state.currentChatRoom.roomId));
        state = state.copyWith(
          chatRooms: rooms,
          // Update the current chat room with the chat messages previously fetched for that room
          currentChatRoom: updatedCurrentRoom?.copyWith(
            chatMessages: state.currentChatRoom.chatMessages,
          ),
          loadingStatus: UniLoadingState.notSpecified,
        );

        // printMeLog("Total rooms found: ${rooms.length}");
      });
    } else {
      // printMe("Rooms stream already subscribed ;)");
    }
  }

  /// [chatMessagesStreamSubscription] is a stream subscription to listen to chat messages
  StreamSubscription<List<UniChatMessage>>? chatMessagesStreamSubscription;

  /// [listenToChatMessagesFromRoom] is a method to listen to chat messages from a room
  Future listenToChatMessagesFromRoom(UniChatRoom room) async {
    if (state.currentChatRoom.roomId.isNotEqualTo(room.roomId)) {
      state = state.copyWith(
        currentChatRoom: room,
        loadingStatus: UniLoadingState.loading,
      );

      // Clean-up the previous subscription
      await chatMessagesStreamSubscription?.cancel();

      // Listen to the chat messages
      chatMessagesStreamSubscription =
          _chatRepo.listenToTheChatsFromRoom(room).listen((messages) {
        state = state.copyWith(
          currentChatRoom:
              state.currentChatRoom.copyWith(chatMessages: messages),
          loadingStatus: UniLoadingState.notSpecified,
          // Update the chat messages in the chat rooms list
          // chatRooms: state.chatRooms
          //     .map((r) => r.roomId.isEqualTo(room.roomId)
          //         ? r.copyWith(chatMessages: messages)
          //         : r)
          //     .toList(),
        );
      });
    } else {
      printMe("Already listening to the same room ;)");
      chatMessagesStreamSubscription?.update(true);
    }
  }

  /// [updateChatRoomWithMessages] is a method to update the chat room with messages
  void updateChatRoomWithMessages({
    required UniChatRoom room,
    UniLoadingState loadingStatus = UniLoadingState.notSpecified,
  }) {
    state = state.copyWith(
      currentChatRoom: room,
      loadingStatus: loadingStatus,
    );
  }

  /// [createChatRoom] is a method to create a chat room
  Future createChatRoom() async {
    UniChatRoom room = UniChatRoom(
      roomId: "room12345",
      users: ["1", "2"],
      recentChat: UniChatMessage(
        message: "اذا حد عنده اخر نسخة للطلبية يرسلها الي.",
        sentBy: "1",
      ),
      userProfiles: [
        UniUserModel(userId: "1", fullName: "User 1"),
        UniUserModel(userId: "2", fullName: "User 2"),
      ],
    );

    final result = await _chatRepo.createChatRoom(room);
    printMeLog(result);
  }

  /// [goToViewChatMessages] Go To the chat view
  Future goToViewChatMessages(BuildContext context, UniChatRoom room) async {
    // Start listening to the chat messages
    listenToChatMessagesFromRoom(room);

    // Push to the chat view
    context.pushTo(const UniChatMessagesView());
  }

  /// [sendChatMessage] is a method to send a chat message
  Future sendChatMessage(UniChatMessage message) async {
    // Add the message to the list for better UX
    UniChatRoom chatRoom = state.currentChatRoom;
    chatRoom.chatMessages.insert(0, message);
    state = state.copyWith(
      currentChatRoom: chatRoom,
      loadingStatus: UniLoadingState.sending,
    );
    // Release the resources from send state
    final sendChatNotifier = ref.read(sendChatStateProvider.notifier);
    sendChatNotifier.clearSendChatState();

    if (message.messageType.isMediaMessage) {
      final result = await _storageService.uploadChatContent(
          roomId: chatRoom.roomId, file: message.mediaFile!);
      if (result.isSuccess) {
        message.message = result.downloadUrl;
      } else {
        UniToastAlert.showToastMessage(isSuccess: false);
        _rollBackChatMessage(message, sendChatNotifier);
        return;
      }
    }

    if (message.message.isNotEmpty) {
      final result = await _chatRepo.sendChatMessage(chatRoom, message);
      if (!result.isSuccessFul) {
        _rollBackChatMessage(message, sendChatNotifier);
      }
    }

    state = state.copyWith(loadingStatus: UniLoadingState.notSpecified);
  }

  /// [_rollBackChatMessage] is a method to roll back a chat message if the message fails to send
  void _rollBackChatMessage(
    UniChatMessage message,
    SendChatStateNotifier sendChatStateNotifier,
  ) {
    UniChatRoom chatRoom = state.currentChatRoom;
    chatRoom.chatMessages
        .removeWhere((m) => m.messageId.isEqualTo(message.messageId));
    state = state.copyWith(currentChatRoom: chatRoom);
    sendChatStateNotifier.rollBackSendState(
      context: uniStateKey.currentContext!,
      message: message,
      onSendChatMessage: (m) => sendChatMessage(m),
    );
  }
}

class ChatState {
  /// [chatRooms] is the list of chat rooms
  final List<UniChatRoom> chatRooms;

  /// [currentChatRoom] is the current chat room
  final UniChatRoom currentChatRoom;

  /// [loadingStatus] is the loading status of the chat
  final UniLoadingState loadingStatus;

  /// [ChatState] is the state of the chat
  ChatState({
    this.chatRooms = const [],
    UniChatRoom? currentChatRoom,
    this.loadingStatus = UniLoadingState.fetching,
  }) : currentChatRoom = currentChatRoom ??
            UniChatRoom(
              roomId: "",
              users: [],
              userProfiles: [],
              recentChat: UniChatMessage(message: "", sentBy: ""),
            );

  /// [copyWith] is a method that returns a new instance of [ChatState] with the updated values
  ChatState copyWith({
    List<UniChatRoom>? chatRooms,
    UniChatRoom? currentChatRoom,
    UniLoadingState? loadingStatus,
  }) {
    return ChatState(
      chatRooms: chatRooms ?? this.chatRooms,
      currentChatRoom: currentChatRoom ?? this.currentChatRoom,
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }
}

/// [VoidRef] is a callback that returns a widget ref
typedef VoidRef = void Function(WidgetRef ref);
