import 'package:flutter/material.dart';
import 'package:uni_chat_sdk/src/core/extension/size_extension.dart';

import '../../../global/widgets/skeleton_loading.dart';

class UniChatMessagesLoadingView extends StatelessWidget {
  const UniChatMessagesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        PeerWidget(child: SkeletonLoading(width: 60.w, height: 50.rh)),
        PeerWidget(
          isSentByMe: false,
          child: SkeletonLoading(width: 60.w, height: 160.rh),
        ),
        PeerWidget(child: SkeletonLoading(width: 80.w, height: 60.rh)),
        PeerWidget(
          isSentByMe: false,
          child: SkeletonLoading(width: 60.w, height: 50.rh),
        ),
        PeerWidget(
          isSentByMe: false,
          child: SkeletonLoading(width: 80.w, height: 50.rh),
        ),
        PeerWidget(
          child: SkeletonLoading(width: 60.w, height: 160.rh),
        ),
        PeerWidget(child: SkeletonLoading(width: 80.w, height: 50.rh)),
      ],
    );
  }
}

class PeerWidget extends StatelessWidget {
  final bool isSentByMe;
  final Widget child;
  const PeerWidget({super.key, this.isSentByMe = true, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.rh),
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: child,
    );
  }
}
