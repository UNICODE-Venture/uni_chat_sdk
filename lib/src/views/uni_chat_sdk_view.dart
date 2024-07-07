import 'package:flutter/material.dart';
import '../core/models/config/uni_chat_config.dart';
import '../global/uni_chat_provider.dart';
import '../global/uni_chat_wrapper.dart';
import 'chat_rooms/uni_chat_rooms_view.dart';

class UniChatSdkView extends StatelessWidget {
  /// [config] is the configuration of the chat to show the chat in the way you want
  final UniChatConfig? config;

  /// [UniChatSdkView] is the main widget to show chat by covering the whole flow
  ///
  /// Kindly make sure you wrap your main app with our provider [UniChatProvider], otherwise the package will lead to crash
  const UniChatSdkView({super.key, this.config});

  @override
  Widget build(BuildContext context) {
    return UniChatSDKWrapper(
      config: config,
      home: const UniChatRoomsView(),
    );
  }
}
