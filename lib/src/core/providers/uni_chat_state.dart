import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/config/uni_chat_config.dart';

/// [uniChatStateProvider] is a state provider that holds the state of the chat
final uniChatStateProvider =
    NotifierProvider<UniChatStateNotifier, UniChatState>(
        () => UniChatStateNotifier());

/// [UniChatStateNotifier] is a state notifier that holds the state of the chat
class UniChatStateNotifier extends Notifier<UniChatState> {
  @override
  UniChatState build() => UniChatState();

  /// Save the provided configuration to the state
  void saveUniChatConfig(UniChatConfig? config) {
    state = state.copyWith(config: config);
  }
}

class UniChatState {
  /// [config] is the configuration of the chat
  final UniChatConfig config;

  /// [UniChatState] is the state of the chat configuration
  UniChatState({
    UniChatConfig? config,
  }) : config = config ?? UniChatConfig();

  /// [copyWith] is a method to copy the current state and update the provided fields
  UniChatState copyWith({
    UniChatConfig? config,
  }) {
    return UniChatState(
      config: config ?? this.config,
    );
  }
}
