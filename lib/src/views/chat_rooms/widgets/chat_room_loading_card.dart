import 'package:flutter/material.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';

import '../../../global/widgets/skeleton_loading.dart';
import '../../../theme/colors.dart';

final _colors = ColorsPalletes.instance;

class ChatRoomLoadingCard extends StatelessWidget {
  /// [ChatRoomLoadingCard] is the loading card for the chat room
  const ChatRoomLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.rh),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _colors.grey20)),
      ),
      child: Row(
        children: [
          SkeletonLoading(width: 45.rSp, height: 45.rh, isCircleShape: true),
          8.hGap,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoading(width: 40.w, height: 16.rh),
                10.vGap,
                SkeletonLoading(width: 55.w, height: 13.rh),
              ],
            ),
          ),
          15.hGap,
          SkeletonLoading(width: 15.w, height: 16.rh),
        ],
      ),
    );
  }
}

class UniChatRoomsLoadingView extends StatelessWidget {
  /// [UniChatRoomsLoadingView] is the loading view for the chat rooms
  const UniChatRoomsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 7,
      itemBuilder: (_, index) => const ChatRoomLoadingCard(),
    );
  }
}
