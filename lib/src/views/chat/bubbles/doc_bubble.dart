import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';

import '../../../../uni_chat_sdk.dart';
import '../../../core/services/storage/cache_services.dart';
import '../../../global/uni_design.dart';
import '../../../global/widgets/animated_cross_fade.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';

final _colors = ColorsPalletes.instance;
final _textStyles = TextStyles.instance;
final _designSystem = UniDesignSystem.instance;

class DocBubble extends StatefulWidget {
  /// [uniChatMessage] is the message that is to be displayed
  final UniChatMessage uniChatMessage;

  /// [DocBubble] is the widget that displays the text message
  const DocBubble({super.key, required this.uniChatMessage});

  @override
  State<DocBubble> createState() => _DocBubbleState();
}

class _DocBubbleState extends State<DocBubble> {
  /// [isDownloading] is a boolean to check if the file is downloading
  bool isDownloading = false;

  final _cacheServices = CacheServices.instance;

  Future _downloadAndOpenFile() async {
    setState(() => isDownloading = true);
    File file = widget.uniChatMessage.mediaFile ??
        await _cacheServices.getFile(widget.uniChatMessage.message);
    if (mounted) setState(() => isDownloading = false);
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.uniChatMessage;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.rSp, vertical: 5.rSp),
      constraints: BoxConstraints(
        maxWidth: 60.w,
        maxHeight: 100.rSp,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message.mediaFile?.fileName ?? message.message.fileNameFromUrl,
              style: message.isSentByMe
                  ? _textStyles.text14Medium
                  : _textStyles.text14MediumWhite,
              maxLines: 3,
            ),
          ),
          10.hGap,
          CircleAvatar(
            backgroundColor: _colors.white.withOpacity(.2),
            child: AnimatedCrossFadeView(
              animationStatus: isDownloading,
              shownIfTrue: _designSystem.loadingIndicator(),
              shownIfFalse: _designSystem.iconImage(
                icon: "download",
                size: 20.rSp,
                color: message.isSentByMe ? _colors.grey600 : _colors.white,
                onTap: () => _downloadAndOpenFile(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
