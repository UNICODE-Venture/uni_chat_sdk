import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';
import 'package:uni_chat_sdk/src/core/providers/chat_state.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../global/uni_chat_wrapper.dart';
import '../../../theme/colors.dart';
import '../../../utils/utils.dart';
import '../../enums/enums.dart';

final _utils = UniUtils.instance;
final _colors = ColorsPalletes.instance;

class UniChatMessage {
  /// [messageId] is the unique identifier of the chat message
  late String messageId;

  /// [message] is the message content
  late String message;

  /// [sentBy] is the user who sent the message
  late String sentBy;

  /// [messageType] is the type of message
  late UniChatMessageType messageType;

  /// [seenBy] is the list of users who have seen the message
  late List<String> seenBy;

  /// [sentAt] is the time the message was sent
  late DateTime sentAt;

  /// [mediaText] is the text of the media message (image, video)
  late String mediaText;

  /// [repliedMessageId] is the id of the message that is replied to
  late String repliedMessageId;

  /// [customData] is the custom data of the chat message.
  late Map<String, dynamic> customData;

  /// [UniChatMessage] is the model to store chat message
  UniChatMessage({
    String? messageId,
    required this.message,
    required this.sentBy,
    this.messageType = UniChatMessageType.text,
    this.seenBy = const [],
    DateTime? sentAt,
    this.mediaText = "",
    this.customData = const {},
    this.repliedMessageId = "",

    ///! For local use
    this.isSentByMe = true,
    this.mediaFile,
  })  : messageId = messageId ?? _utils.getUID,
        sentAt = sentAt ?? DateTime.now();

  /// From Json to Model
  factory UniChatMessage.fromJson(Map<String, dynamic> data) {
    return UniChatMessage(
      messageId: data['messageId'],
      message: data['message'],
      sentBy: data['sentBy'],
      messageType: UniChatMessageType.values.firstWhere(
        (t) => t.name.isEqualTo(data['messageType']),
        orElse: () => UniChatMessageType.text,
      ),
      seenBy: List<String>.from(data['seenBy']),
      sentAt: data['sentAt'].toDate(),
      mediaText: data['mediaText'],
      customData: data['customData'] ?? {},
      repliedMessageId: data['repliedMessageId'] ?? "",
      //! Locale
      isSentByMe: data["sentBy"].toString().isEqualTo("1"),
    );
  }

  /// From Model to Json
  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'message': message,
      'sentBy': sentBy,
      'messageType': messageType.name,
      'seenBy': seenBy,
      'sentAt': sentAt,
      'mediaText': mediaText,
      'customData': customData,
      'repliedMessageId': repliedMessageId,
    };
  }

  /// [isSentByMe] is true if the message is sent by the user
  late bool isSentByMe;

  /// [mediaFile] is the file of the media message (image, video, voice)
  late File? mediaFile;

  Color get bubbleBgColor =>
      isSentByMe ? _colors.myBubbleBgColor : _colors.peerBubbleBgColor;

  /// [messageHighlightText] is the text to highlight in the message room card based on the type
  String get messageHighlightText {
    return switch (messageType) {
      UniChatMessageType.text => message,
      UniChatMessageType.image => LocaleKeys.imageShared.tr(),
      UniChatMessageType.voice => LocaleKeys.voiceShared.tr(),
      UniChatMessageType.video => LocaleKeys.videoShared.tr(),
      UniChatMessageType.docFile => LocaleKeys.fileShared.tr(),
    };
  }

  @override
  String toString() {
    return "UniChatMessage(messageId: $messageId, message: $message, sentBy: $sentBy, messageType: ${messageType.name}, seenBy: $seenBy, sentAt: $sentAt, mediaText: $mediaText, customData: $customData, isSentByMe: $isSentByMe, mediaFile: ${mediaFile?.path})";
  }

  /// [heroImgTag] is the tag of the image to be used in the hero animation
  String get heroImgTag => mediaFile?.fileName ?? message;

  /// [isSendMediaMessage] is true if the message is a media message to sent
  bool get isSendMediaMessage =>
      mediaFile != null && messageType.isMediaMessage;

  /// [repliedChatMessage] is the message that is replied to
  UniChatMessage? repliedChatMessage(WidgetRef ref) => ref
      .read(chatStateProvider)
      .currentChatRoom
      .chatMessages
      .findOrNull((m) => m.messageId.isEqualTo(repliedMessageId));
}
