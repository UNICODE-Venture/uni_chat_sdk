import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/providers/providers.dart';

import '../../../uni_chat_sdk.dart';
import '../../core/providers/chat_state.dart';
import '../../core/providers/send_chat_state.dart';
import '../../global/uni_design.dart';
import '../../global/uni_scaffold.dart';
import 'widgets/chat_loading.dart';
import 'widgets/no_chat.dart';

class UniChatMessagesView extends ConsumerStatefulWidget {
  /// [chatRoomWithMessages] is the chat-room and the list of messages that are displayed in the chat room from your custom screen
  final UniChatRoom? chatRoomWithMessages;

  /// [onSendChatMessage] is the callback that is called when the message is sent, so that the message can be saved into your database
  final VoidSendMsg? onSendChatMessage;

  /// [appBar] is the custom app bar that you can pass to the chat messages view
  final AppBar? appBar;

  /// [onRef] is the callback that is called when the chat messages view is rendered with WidgetRef from riverpod
  final VoidRef? onRef;

  /// [loadingStatus] is the loading status of the chat messages
  final UniLoadingState? loadingStatus;

  /// [moreOptions] is the list of widgets that you want to show in the send pop over
  final List<Widget>? moreOptions;

  /// [onViewImgTap] is the callback that is called when the image is tapped
  final VoidMessageCallBack? onViewImgTap;

  /// [UniChatMessagesView] is where all the chat messages are displayed of the room
  const UniChatMessagesView({
    super.key,
    this.chatRoomWithMessages,
    this.onSendChatMessage,
    this.appBar,
    this.onRef,
    this.loadingStatus,
    this.moreOptions,
    this.onViewImgTap,
  });

  @override
  ConsumerState<UniChatMessagesView> createState() => _UniChatViewState();
}

class _UniChatViewState extends ConsumerState<UniChatMessagesView> {
  final _designSystem = UniDesignSystem.instance;
  StreamSubscription? streamSubscription;

  @override
  void initState() {
    super.initState();
    if (widget.chatRoomWithMessages == null) {
      streamSubscription = ref.chatStateNotifier.chatMessagesStreamSubscription;
    }
    if (widget.onRef != null) {
      widget.onRef?.call(ref);
    }
  }

  @override
  void dispose() {
    if (widget.chatRoomWithMessages == null) {
      streamSubscription?.update(false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatStateProvider);
    final chatStateNotifier = ref.chatStateNotifier;
    final sendChatStateNotifier = ref.sendChatStateNotifier;

    UniChatRoom chatRoom =
        widget.chatRoomWithMessages ?? chatState.currentChatRoom;

    return UniScaffold(
      appBar: widget.appBar ??
          _designSystem.appBar(title: chatRoom.peerUser.fullName),
      body: (widget.loadingStatus ?? chatState.loadingStatus).isLoading &&
              chatRoom.messagesByGroups.isEmpty
          ? const UniChatMessagesLoadingView()
          : chatRoom.messagesByGroups.isEmpty
              ? const NoChatFoundView()
              : ListView.builder(
                  reverse: true,
                  itemCount: chatRoom.messagesByGroups.length,
                  itemBuilder: (_, index) {
                    MessagesGroupModel messageGroup =
                        chatRoom.messagesByGroups[index];
                    List<UniChatMessage> messages = messageGroup.messages;
                    return Column(
                      children: [
                        _designSystem.timeText(messageGroup.labelText),
                        ...messages.map((message) => UniChatBubble(
                            message: message,
                            onViewImgTap: () =>
                                widget.onViewImgTap?.call(message))),
                      ],
                    );
                  },
                ),
      bottomNavigationBar: UniSendChatInputBar(
        moreOptions: widget.moreOptions,
        onSendChatMessage: (message) async {
          if (widget.onSendChatMessage != null) {
            widget.onSendChatMessage?.call(message);
            sendChatStateNotifier.clearSendChatState();
          } else {
            await chatStateNotifier.sendChatMessage(message);
          }
        },
      ),
    );
  }
}
