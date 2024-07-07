import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_chat_sdk/src/core/providers/chat_state.dart';
import 'package:uni_chat_sdk/src/core/providers/providers.dart';

import '../../../uni_chat_sdk.dart';

class UniChatSDKServices {
  UniChatSDKServices._();
  static UniChatSDKServices? _instance;

  /// [instance] is the singleton instance of [UniChatSDKServices]
  static UniChatSDKServices get instance =>
      _instance ??= UniChatSDKServices._();

  /// [updateUniChatRoomToState] is a method to update the chat room to the state
  void updateUniChatRoomToState({
    required UniChatRoom room,
    UniLoadingState loadingStatus = UniLoadingState.notSpecified,
  }) {
    final container = ProviderScope.containerOf(uniStateKey.currentContext!);
    container.read(chatStateProvider.notifier).updateChatRoomWithMessages(
          room: room,
          loadingStatus: loadingStatus,
        );
  }
}
