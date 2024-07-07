import 'package:easy_localization/easy_localization.dart';
import 'package:uni_chat_sdk/src/core/extension/extenstion.dart';

import '../../../../generated/locale_keys.g.dart';
import '../chat/uni_chat_message.dart';
import '../user/uni_user.dart';

class UniChatRoom {
  /// [roomId] is the unique id of the chat room
  late String roomId;

  /// [users] is the list of users-id's in the chat room
  late List<String> users;

  /// [recentChat] is the recent chat message of the chat room
  late UniChatMessage recentChat;

  /// [userProfiles] is the list of users in the chat room
  late List<UniUserModel> userProfiles;

  /// [customData] is the custom data of the chat room.
  late Map<String, dynamic> customData;

  /// [UniChatRoom] is the model class for the chat room
  UniChatRoom({
    required this.roomId,
    required this.users,
    required this.recentChat,
    required this.userProfiles,
    this.chatMessages = const [],
    this.customData = const {},
  });

  /// [UniChatRoom.fromJson] is the fromJson constructor for the UniChatRoom
  factory UniChatRoom.fromJson(Map<String, dynamic> data) {
    return UniChatRoom(
      roomId: data['roomId'],
      users: List<String>.from(data['users']),
      recentChat: UniChatMessage.fromJson(data['recentChat']),
      userProfiles: List<UniUserModel>.from(
        data['userProfiles'].map((u) => UniUserModel.fromJson(u)),
      ),
      customData: data['customData'] ?? {},
    );
  }

  /// [UniChatRoom.toJson] is the toJson method for the UniChatRoom
  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'users': users,
      'recentChat': recentChat.toJson(),
      'userProfiles': userProfiles.map((u) => u.toJson()).toList(),
      'customData': customData,
    };
  }

  /// [chatMessages] is the list of chat messages in the chat room, but for local use case
  late List<UniChatMessage> chatMessages;

  /// [copyWith] is a method to copy the current instance of the UniChatRoom
  UniChatRoom copyWith({
    String? roomId,
    List<String>? users,
    UniChatMessage? recentChat,
    List<UniUserModel>? userProfiles,
    List<UniChatMessage>? chatMessages,
    Map<String, dynamic>? customData,
  }) {
    return UniChatRoom(
      roomId: roomId ?? this.roomId,
      users: users ?? this.users,
      recentChat: recentChat ?? this.recentChat,
      userProfiles: userProfiles ?? this.userProfiles,
      chatMessages: chatMessages ?? this.chatMessages,
      customData: customData ?? this.customData,
    );
  }

  /// [peerUser] is the peer user of the chat room
  UniUserModel get peerUser => userProfiles.first;

  /// [messagesByGroups] is the list of messages grouped by date
  List<MessagesGroupModel> get messagesByGroups {
    List<UniChatMessage> messages = [...chatMessages];
    List<MessagesGroupModel> messagesGroups = [];

    messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));

    for (final m in messages) {
      final indexOfGroup = messagesGroups.indexWhere(
        (g) => g.dateLabelText.isEqualTo(m.sentAt.dateDayMonthYearFormat),
      );
      if (indexOfGroup.isValidIndex) {
        messagesGroups[indexOfGroup].messages.add(m);
      } else {
        messagesGroups.add(
          MessagesGroupModel(
            dateLabelText: m.sentAt.dateDayMonthYearFormat,
            messages: [m],
            date: m.sentAt,
          ),
        );
      }
    }
    messagesGroups.sort((a, b) => b.date.compareTo(a.date));
    return messagesGroups;
  }
}

class MessagesGroupModel {
  /// [dateLabelText] is the date label text
  late String dateLabelText;

  /// [date] is the date of the messages group
  late DateTime date;

  /// [messages] is the list of messages in the group
  late List<UniChatMessage> messages;

  /// [MessagesGroupModel] is the model class for the messages group
  MessagesGroupModel({
    required this.dateLabelText,
    required this.messages,
    required this.date,
  });

  /// [labelText] is the label text of the messages group
  String get labelText => date.isToday
      ? LocaleKeys.today.tr()
      : date.isYesterday
          ? LocaleKeys.yesterday.tr()
          : dateLabelText;
}
