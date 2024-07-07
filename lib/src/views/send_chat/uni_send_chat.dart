import 'package:flutter/material.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';

import '../../core/providers/send_chat_state.dart';
import '../../theme/colors.dart';
import 'send_chat_input.dart';

final _colors = ColorsPalletes.instance;

class UniSendChatInputBar extends StatelessWidget {
  /// [onSendChatMessage] is the callback that is called when the message is sent, so that the message can be saved into your database
  final VoidSendMsg onSendChatMessage;

  /// [moreOptions] is the list of widgets that you want to show in the pop over
  final List<Widget>? moreOptions;

  /// [UniSendChatInputBar] is the chat bar that is used to send messages with type of text, image, video, voice note, and file
  const UniSendChatInputBar(
      {super.key, required this.onSendChatMessage, this.moreOptions});

  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      color: _colors.white,
      constraints: BoxConstraints(
        minHeight: 100.rSp,
        maxHeight: 130.rSp,
      ),
      margin: EdgeInsets.only(bottom: bottomInsets),
      padding: EdgeInsets.only(left: 20.rw, right: 20.rw, bottom: 20.rSp),
      child: UniSendChatInputView(
        onSendChatMessage: onSendChatMessage,
        moreOptions: moreOptions,
      ),
    );
  }
}
