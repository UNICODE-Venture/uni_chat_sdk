import 'package:flutter/material.dart';

import '../../../../uni_chat_sdk.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';

final _colors = ColorsPalletes.instance;
final _textStyles = TextStyles.instance;

class TextBubble extends StatelessWidget {
  /// [uniChatMessage] is the message that is to be displayed
  final UniChatMessage uniChatMessage;

  /// [isSecondaryText] is a flag that tells if the text is a secondary text
  final bool isSecondaryText;

  /// [textColor] is the color of the text
  final Color? textColor;

  /// [TextBubble] is the widget that displays the text message
  const TextBubble({
    super.key,
    required this.uniChatMessage,
    this.isSecondaryText = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      isSecondaryText ? uniChatMessage.mediaText : uniChatMessage.message,
      style: _textStyles.text14Medium.copyWith(
        color: textColor ??
            (uniChatMessage.isSentByMe ? _colors.grey600 : _colors.white),
      ),
    );
  }
}
