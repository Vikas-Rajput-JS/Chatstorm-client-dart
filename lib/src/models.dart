/// Models for ChatSocket parameters and data structures

/// Parameters for sending a message
class SendMessageParams {
  final String receiverId;
  final ChatMessage message;

  SendMessageParams({
    required this.receiverId,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'receiverId': receiverId,
      'message': message.toJson(),
    };
  }
}

/// Chat message structure
class ChatMessage {
  final String text;
  final String link;
  final String media;

  ChatMessage({
    required this.text,
    this.link = '',
    this.media = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'link': link,
      'media': media,
    };
  }
}

/// Parameters for joining a chat
class JoinChatParams {
  final String receiverId;

  JoinChatParams({required this.receiverId});

  Map<String, dynamic> toJson() {
    return {
      'receiverId': receiverId,
    };
  }
}

/// Parameters for typing alert
class TypingAlertParams {
  final String receiverId;
  final bool isTyping;

  TypingAlertParams({
    required this.receiverId,
    required this.isTyping,
  });

  Map<String, dynamic> toJson() {
    return {
      'receiverId': receiverId,
      'type': isTyping ? 'user_typing' : 'typing_stopped',
    };
  }
}

/// Parameters for deleting a message
class DeleteMessageParams {
  final String messageId;

  DeleteMessageParams({required this.messageId});

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
    };
  }
}

/// Parameters for retrieving messages
class RetrieveMessagesParams {
  final String receiverId;
  final String keyword;

  RetrieveMessagesParams({
    required this.receiverId,
    this.keyword = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'receiverId': receiverId,
      'keyword': keyword,
    };
  }
}

/// Parameters for getting chat list
class ChatListParams {
  final String keyword;

  ChatListParams({this.keyword = ''});

  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword,
    };
  }
}

/// Parameters for checking online status
class CheckOnlineStatusParams {
  final String receiverId;

  CheckOnlineStatusParams({required this.receiverId});

  Map<String, dynamic> toJson() {
    return {
      'receiverId': receiverId,
    };
  }
}

