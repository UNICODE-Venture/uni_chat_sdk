import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_chat_sdk/src/core/providers/providers.dart';

import '../../../generated/locale_keys.g.dart';

import '../../core/providers/chat_state.dart';

import '../../global/uni_design.dart';
import '../../global/uni_scaffold.dart';
import 'widgets/chat_room_loading_card.dart';
import 'widgets/chat_rooms_card.dart';

class UniChatRoomsView extends ConsumerStatefulWidget {
  /// [UniChatRoomsView] is where all the chat rooms are displayed
  const UniChatRoomsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UniChatRoomsViewState();
}

final _designSystem = UniDesignSystem.instance;

class _UniChatRoomsViewState extends ConsumerState<UniChatRoomsView> {
  @override
  void initState() {
    super.initState();
    ref.chatStateNotifier.listenToChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatStateProvider);
    final chatStateNotifier = ref.chatStateNotifier;
    return UniScaffold(
      appBar: _designSystem.appBar(title: LocaleKeys.chatRooms.tr()),
      body: chatState.loadingStatus.isFetching
          ? const UniChatRoomsLoadingView()
          : ListView.builder(
              itemCount: chatState.chatRooms.length,
              itemBuilder: (_, index) => UniChatRoomCard(
                room: chatState.chatRooms[index],
                onRoomEnter: (r) =>
                    chatStateNotifier.goToViewChatMessages(context, r),
              ),
            ),
    );
  }
}
