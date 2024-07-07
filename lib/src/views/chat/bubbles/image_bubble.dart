import 'package:flutter/material.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';
import 'package:uni_chat_sdk/src/utils/navigation.dart';

import '../../../../uni_chat_sdk.dart';
import '../../../global/widgets/cached_image.dart';
import '../../../global/widgets/image_view.dart';

class ImageBubble extends StatelessWidget {
  /// [uniChatMessage] is the message that is to be displayed
  final UniChatMessage uniChatMessage;

  /// [onViewImgTap] is the callback that is called when the image is tapped
  final VoidCallback? onViewImgTap;

  /// [ImageBubble] is the widget that displays the text message
  const ImageBubble(
      {super.key, required this.uniChatMessage, this.onViewImgTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onViewImgTap != null) {
          onViewImgTap?.call();
        } else {
          context.pushTo(UniFullImageView(
              imageUrl: uniChatMessage.message,
              imageFile: uniChatMessage.mediaFile));
        }
      },
      child: Hero(
        tag: uniChatMessage.heroImgTag,
        child: ClipRRect(
          borderRadius: 10.br,
          child: uniChatMessage.mediaFile != null
              ? Image.file(
                  uniChatMessage.mediaFile!,
                  width: 55.w,
                  height: 160.rh,
                  fit: BoxFit.cover,
                )
              : CachedImageView(
                  url: uniChatMessage.message,
                  width: 55.w,
                  height: 160.rh,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
