import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/providers/providers.dart';
import 'package:uni_chat_sdk/src/core/providers/uni_chat_state.dart';
import 'package:uni_chat_sdk/src/utils/navigation.dart';

import '../../../uni_chat_sdk.dart';
import '../../core/providers/chat_state.dart';
import '../../global/uni_design.dart';
import '../../global/uni_scaffold.dart';
import 'widgets/chat_loading.dart';
import 'widgets/no_chat.dart';

class UniChatMessagesView extends ConsumerStatefulWidget {
  /// [UniChatBuilder] is the custom app bar that you can pass to the chat messages view
  final UniChatBuilder? chatBuilder;

  /// [UniChatMessagesView] is where all the chat messages are displayed of the room
  const UniChatMessagesView({
    super.key,
    this.chatBuilder,
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
    if (widget.chatBuilder?.chatRoomWithMessages == null) {
      streamSubscription = ref.chatStateNotifier.chatMessagesStreamSubscription;
    }
    if (widget.chatBuilder?.onRef != null) {
      widget.chatBuilder?.onRef?.call(ref);
    }
  }

  @override
  void dispose() {
    if (widget.chatBuilder?.chatRoomWithMessages == null) {
      streamSubscription?.update(false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatStateProvider);
    final chatStateNotifier = ref.chatStateNotifier;
    final sendChatStateNotifier = ref.sendChatStateNotifier;
    final config = ref.read(uniChatStateProvider).config;
    printMeLog(config.toString());

    UniChatRoom chatRoom =
        widget.chatBuilder?.chatRoomWithMessages ?? chatState.currentChatRoom;

    return UniScaffold(
      appBar: widget.chatBuilder?.appBar?.call(context, chatRoom) ??
          _designSystem.appBar(title: chatRoom.peerUser.fullName),
      body: (widget.chatBuilder?.loadingStatus ?? chatState.loadingStatus)
                  .isLoading &&
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
                        ...messages.map(
                          (message) =>
                              widget.chatBuilder?.builder
                                  ?.call(chatRoom, message) ??
                              UniChatBubble(
                                message: message,
                                onViewImgTap:
                                    widget.chatBuilder?.onViewImgTap != null
                                        ? () => widget.chatBuilder?.onViewImgTap
                                            ?.call(message)
                                        : null,
                                bubbleBgColor: message.isSentByMe
                                    ? config.myBubbleColors?.bubbleBgColor
                                    : config.peerBubbleColors?.bubbleBgColor,
                                contentColor: message.isSentByMe
                                    ? config.myBubbleColors?.contentColor
                                    : config.peerBubbleColors?.contentColor,
                              ),
                        ),
                      ],
                    );
                  },
                ),
      bottomNavigationBar: UniSendChatInputBar(
        moreOptions: widget.chatBuilder?.moreOptions,
        onSendChatMessage: (message) async {
          if (widget.chatBuilder?.onSendChatMessage != null) {
            widget.chatBuilder?.onSendChatMessage?.call(message);
            sendChatStateNotifier.clearSendChatState();
          } else {
            await chatStateNotifier.sendChatMessage(message: message);
          }
        },
      ),
    );
  }
}
