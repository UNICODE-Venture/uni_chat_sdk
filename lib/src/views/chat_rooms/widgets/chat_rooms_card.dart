import 'package:flutter/material.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';

import '../../../../uni_chat_sdk.dart';
import '../../../global/uni_design.dart';
import '../../../global/widgets/cached_image.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_styles.dart';

final _colors = ColorsPalletes.instance;
final _textStyles = TextStyles.instance;
final _designSystem = UniDesignSystem.instance;

class UniChatRoomCard extends StatelessWidget {
  /// [room] is the chat room model
  final UniChatRoom room;

  /// [onRoomEnter] is the callback to be called when the room is entered
  final Function(UniChatRoom room)? onRoomEnter;

  /// [UniChatRoomCard] is the card to display the chat room
  const UniChatRoomCard({super.key, required this.room, this.onRoomEnter});

  @override
  Widget build(BuildContext context) {
    final peerUser = room.userProfiles.first;
    return InkWell(
      onTap: () => onRoomEnter?.call(room),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.rh),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: _colors.grey20)),
        ),
        child: Row(
          children: [
            Container(
              width: 45.rSp,
              height: 45.rSp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _colors.grey20,
              ),
              child: peerUser.imageUrl.isEmpty
                  ? Padding(
                      padding: 10.paddingAll,
                      child: _designSystem.iconImage(
                        icon: "user",
                        color: _colors.lightDark06,
                      ),
                    )
                  : CachedImageView(
                      url: peerUser.imageUrl,
                      width: 45.rSp,
                      height: 45.rSp,
                    ),
            ),
            15.hGap,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    peerUser.fullName,
                    style: _textStyles.text16Bold,
                  ),
                  3.vGap,
                  Text(
                    room.recentChat.messageHighlightText,
                    style: _textStyles.text14Medium.copyWith(
                      fontSize: 13.rSp,
                      color: room.recentChat.isSentByMe
                          ? _colors.lightDark06
                          : _colors.black,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 10.w,
              child: Text(
                room.recentChat.sentAt.timeAgo,
                textAlign: TextAlign.center,
                style: _textStyles.text14Medium.copyWith(fontSize: 11.rSp),
              ),
            )
          ],
        ),
      ),
    );
  }
}
