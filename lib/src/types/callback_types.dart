import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../uni_chat_sdk.dart';
import '../core/providers/send_chat_state.dart';

/// [VoidRef] is a callback that returns a widget ref
typedef VoidRef = void Function(WidgetRef ref);

/// [VoidMessageCallBack] is a callback that returns the message
typedef VoidMessageCallBack = void Function(UniChatMessage message);

/// [VoidRoomBuilder] is a callback that returns the room
typedef VoidRoomBuilder = Widget Function(
    BuildContext context, UniChatRoom room);

/// [VoidChatAppBarCallBack] is a callback that returns the room
typedef VoidChatAppBarCallBack = PreferredSizeWidget Function(
  BuildContext context,
  UniChatRoom room,
);

/// [VoidChatMsgCallBack] is a callback that returns the room
typedef VoidChatMsgCallBack = Widget Function(
  UniChatRoom room,
  UniChatMessage message,
);

class UniChatBuilder {
  /// [chatRoomWithMessages] is the chat-room and the list of messages that are displayed in the chat room from your custom screen
  final UniChatRoom? chatRoomWithMessages;

  /// [appBar] is the custom app bar that you can pass to the chat messages view
  final VoidChatAppBarCallBack? appBar;

  /// [builder] is the custom component that you can pass to the chat bubble to render the chat message
  final VoidChatMsgCallBack? builder;

  /// [onViewImgTap] is the callback that is called when the image is tapped
  final VoidMessageCallBack? onViewImgTap;

  /// [onSendChatMessage] is the callback that is called when the message is sent, so that the message can be saved into your database
  final VoidSendMsg? onSendChatMessage;

  /// [loadingStatus] is the loading status of the chat messages
  final UniLoadingState? loadingStatus;

  /// [onRef] is the callback that is called when the chat messages view is rendered with WidgetRef from riverpod
  final VoidRef? onRef;

  /// [moreOptions] is the list of widgets that you want to show in the send pop over
  final List<Widget>? moreOptions;

  /// [UniChatBuilder] is where all the chat builder are passed to the chat messages view
  const UniChatBuilder({
    this.chatRoomWithMessages,
    this.appBar,
    this.builder,
    this.onViewImgTap,
    this.onSendChatMessage,
    this.loadingStatus,
    this.onRef,
    this.moreOptions,
  });
}

class UniChatRoomBuilder {
  /// [appBar] is the custom app bar that you can pass to the chat messages view
  final PreferredSizeWidget? appBar;

  /// [builder] is the custom app bar that you can pass to the chat messages view
  final VoidRoomBuilder? builder;

  /// [UniChatRoomBuilder] is where all the room builder data is passed
  const UniChatRoomBuilder({
    this.appBar,
    this.builder,
  });
}
