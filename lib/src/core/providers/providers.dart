import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat_state.dart';
import 'send_chat_state.dart';
import 'uni_chat_state.dart';

extension WidgetRefExt on WidgetRef {
  /// Chat state notifier
  ChatStateNotifier get chatStateNotifier => read(chatStateProvider.notifier);

  /// Send Chat state notifier
  SendChatStateNotifier get sendChatStateNotifier =>
      read(sendChatStateProvider.notifier);

  /// Uni Chat state notifier
  UniChatStateNotifier get uniChatStateNotifier =>
      read(uniChatStateProvider.notifier);
}

extension BuildContextExt on BuildContext {
  /// [provider] is to read the provider using the context
  T read<T>(ProviderBase<T> provider) {
    return ProviderScope.containerOf(this, listen: false).read(provider);
  }
}
