import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';
import 'package:uni_chat_sdk/src/theme/text_styles.dart';

import '../../../../uni_chat_sdk.dart';
import '../../../theme/colors.dart';
import 'doc_bubble.dart';
import 'image_bubble.dart';
import 'text_bubble.dart';
import 'video_bubble.dart';
import 'voice_note_bubble.dart';

final _colors = ColorsPalletes.instance;
final _textStyles = TextStyles.instance;

class UniChatBubble extends StatefulWidget {
  /// [message] is the message that is to be displayed. [UniChatMessage]
  final UniChatMessage message;

  /// [bubbleBgColor] is the background color of the bubble. If not provided, it will be the default color based on the message type
  final Color? bubbleBgColor;

  /// [contentColor] is the color of the content inside the bubble. If not provided, it will be the default color based on the message type
  final Color? contentColor;

  /// [onViewImgTap] is the callback that is called when the image is tapped
  final VoidCallback? onViewImgTap;

  /// [UniChatBubble] is the container wrapper for the chat message that shows the text, image, video, voice note, and file bubbles based on their provided type
  const UniChatBubble({
    super.key,
    required this.message,
    this.bubbleBgColor,
    this.contentColor,
    this.onViewImgTap,
  });

  @override
  State<UniChatBubble> createState() => _UniChatBubbleState();
}

class _UniChatBubbleState extends State<UniChatBubble> {
  @override
  Widget build(BuildContext context) {
    final message = widget.message;
    double paddingSize = message.messageType.isTextMessage ? 15.rSp : 5.rSp;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.rSp),
      child: Column(
        crossAxisAlignment: message.isSentByMe
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          ChatBubble(
            backGroundColor: widget.bubbleBgColor ?? message.bubbleBgColor,
            elevation: 0,
            alignment: message.isSentByMe
                ? Alignment.centerRight
                : Alignment.centerLeft,
            padding: message.isSentByMe
                ? EdgeInsets.only(
                    top: paddingSize,
                    bottom: paddingSize,
                    left: paddingSize,
                    right: message.messageType.isTextMessage ? 20.rSp : 12.rSp)
                : EdgeInsets.only(
                    top: paddingSize,
                    bottom: paddingSize,
                    left: message.messageType.isTextMessage ? 20.rSp : 12.rSp,
                    right: paddingSize),
            clipper: ChatBubbleClipper3(
              radius: 10.rSp,
              type: message.isSentByMe
                  ? BubbleType.sendBubble
                  : BubbleType.receiverBubble,
            ),
            child: message.mediaText.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.vGap,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.rSp),
                        child: TextBubble(
                            uniChatMessage: message, isSecondaryText: true),
                      ),
                      5.vGap,
                      Container(
                        padding: EdgeInsets.only(top: 10.rh),
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: _colors.lightDark06.withOpacity(.15),
                                  width: 0.5)),
                        ),
                        child: _bubbleWidgetByType(message),
                      ),
                    ],
                  )
                : _bubbleWidgetByType(message),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.rSp, vertical: 5.rSp),
            child: Text(
              message.sentAt.fullDateTimeFormat,
              textAlign: TextAlign.center,
              style: _textStyles.dateTextStyle,
            ),
          )
        ],
      ),
    );
  }

  /// Get the bubble widget by the type of the message
  Widget _bubbleWidgetByType(UniChatMessage message) {
    return switch (message.messageType) {
      UniChatMessageType.text => TextBubble(uniChatMessage: message),
      UniChatMessageType.image => ImageBubble(
          uniChatMessage: message,
          onViewImgTap: widget.onViewImgTap,
        ),
      UniChatMessageType.voice => VoiceNoteBubble(uniChatMessage: message),
      UniChatMessageType.video => VideoBubble(uniChatMessage: message),
      UniChatMessageType.docFile => DocBubble(uniChatMessage: message),
    };
  }
}
