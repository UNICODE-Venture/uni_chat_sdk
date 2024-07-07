import 'package:flutter/material.dart';

import '../../../../uni_chat_sdk.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';

final _colors = ColorsPalletes.instance;
final _textStyles = TextStyles.instance;

class TextBubble extends StatelessWidget {
  /// [uniChatMessage] is the message that is to be displayed
  final UniChatMessage uniChatMessage;

  final bool isSecondaryText;

  /// [TextBubble] is the widget that displays the text message
  const TextBubble(
      {super.key, required this.uniChatMessage, this.isSecondaryText = false});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      isSecondaryText ? uniChatMessage.mediaText : uniChatMessage.message,
      style: _textStyles.text14Medium.copyWith(
        color: uniChatMessage.isSentByMe ? _colors.grey600 : _colors.white,
      ),
    );
  }
}
