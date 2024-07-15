import 'package:flutter/material.dart';
import '../../../src/core/providers/chat_state.dart';
import '../../../src/core/providers/providers.dart';

import '../../../uni_chat_sdk.dart';

class UniChatSDKServices {
  UniChatSDKServices._();
  static UniChatSDKServices? _instance;

  /// [context] is the context of the current widget
  BuildContext get context {
    final c = uniStateKey.currentContext;
    if (c == null) {
      throw Exception(
          "UniChatSDKWrapper is not found in the widget tree. Please make sure to wrap your main widget with UniChatSDKWrapper.");
    } else {
      return c;
    }
  }

  /// [instance] is the singleton instance of [UniChatSDKServices]
  static UniChatSDKServices get instance =>
      _instance ??= UniChatSDKServices._();

  /// [createNewChatRoom] is a method to create a new chat room
  ///
  /// It will return the chat room if the room is created successfully
  /// otherwise it will throw an exception with the error message.
  Future<UniChatRoom?> createNewChatRoom(UniChatRoom room) async {
    if (room.isRoomInValidToCreate) {
      throw Exception(room.roomCreateErrorMessage);
    } else {
      return context
          .readNotifier(chatStateProvider.notifier)
          .createChatRoom(room);
    }
  }

  /// [updateUniChatRoomToState] is a method to update the chat room to the state
  UniChatRoom updateUniChatRoomToState({
    required UniChatRoom room,
    UniLoadingState loadingStatus = UniLoadingState.notSpecified,
  }) {
    return context
        .readNotifier(chatStateProvider.notifier)
        .updateChatRoomWithMessages(room: room, loadingStatus: loadingStatus);
  }

  /// [sendChatMessage] is a method to update the chat room to the state
  Future<bool> sendChatMessage({
    required UniChatRoom room,
    required UniChatMessage message,
  }) {
    return context
        .readNotifier(chatStateProvider.notifier)
        .sendChatMessage(message: message, room: room);
  }

  /// [currentChatRoom] is a method to get the chat messages of the chat room
  UniChatRoom get currentChatRoom =>
      context.read(chatStateProvider).currentChatRoom;
}
