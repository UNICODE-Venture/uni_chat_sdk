import 'package:flutter/material.dart';

import '../../enums/enums.dart';

class UniChatConfig {
  /// [stateKey] is the key of the navigator state
  final GlobalKey<NavigatorState>? stateKey;

  /// [supportedMessageType] is contain the list of supported message types
  final List<UniChatMessageType> supportedMessageType;

  /// [locale] is the current locale of the app
  final UniChatLocale locale;

  /// [moreOptions] is the list of widgets that you want to show in the pop over of sending media
  final List<Widget> moreOptions;

  /// [theme] is the theme of the chat
  final ThemeData? theme;

  /// [myBubbleColors] is the color of the bubble for the user
  final BubbleColors? myBubbleColors;

  /// [peerBubbleColors] is the color of the bubble for the other user
  final BubbleColors? peerBubbleColors;

  /// [UniChatConfig] is the state of the chat
  UniChatConfig({
    this.stateKey,
    this.supportedMessageType = const [
      UniChatMessageType.text,
      // UniChatMessageType.image,
      // UniChatMessageType.voice,
      // UniChatMessageType.video,
      // UniChatMessageType.docFile,
    ],
    this.locale = UniChatLocale.ar,
    this.moreOptions = const [],
    this.theme,
    this.myBubbleColors,
    this.peerBubbleColors,
  });

  /// [isHasText] is the function to check if the chat has text message type
  bool get isHasText => supportedMessageType.contains(UniChatMessageType.text);

  /// [isHasImage] is the function to check if the chat has image message type
  bool get isHasImage =>
      supportedMessageType.contains(UniChatMessageType.image);

  /// [isHasVoiceNote] is the function to check if the chat has voice note message type
  bool get isHasVoiceNote =>
      supportedMessageType.contains(UniChatMessageType.voice);

  /// [isHasVideo] is the function to check if the chat has video message type
  bool get isHasVideo =>
      supportedMessageType.contains(UniChatMessageType.video);

  /// [isHasDocFile] is the function to check if the chat has document file message type
  bool get isHasDocFile =>
      supportedMessageType.contains(UniChatMessageType.docFile);

  /// [isHasMediaChat] is the function to check if the chat has media message type
  bool get isHasMediaChat => isHasImage || isHasVideo || isHasDocFile;

  @override
  String toString() {
    return 'UniChatConfig(supportedMessageType: $supportedMessageType, locale: $locale, moreOptions: $moreOptions, theme: $theme, myBubbleColors: $myBubbleColors, peerBubbleColors: $peerBubbleColors)';
  }
}

class BubbleColors {
  /// [bubbleBgColor] is the background color of the bubble. If not provided, it will be the default color based on the message type
  final Color? bubbleBgColor;

  /// [contentColor] is the color of the content inside the bubble. If not provided, it will be the default color based on the message type
  final Color? contentColor;

  /// [BubbleColors] is the state of the chat
  BubbleColors({
    this.bubbleBgColor,
    this.contentColor,
  });

  @override
  String toString() {
    return 'BubbleColors(bubbleBgColor: $bubbleBgColor, contentColor: $contentColor)';
  }
}
