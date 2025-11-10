import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'models.dart';

/// Callback function type
typedef ChatCallback = void Function(dynamic data);

/// Main ChatSocket class for Flutter applications
class ChatSocket {
  IO.Socket? _socket;
  final String serverUrl;
  final String userId;
  
  // Callbacks
  ChatCallback? _onHandshakeSuccess;
  ChatCallback? _onMessageReceived;
  ChatCallback? _onMessageSent;
  ChatCallback? _onRetrieveMessages;
  ChatCallback? _onChatList;
  ChatCallback? _onMessageUpdate;
  ChatCallback? _onMessageUpdateReceiver;
  ChatCallback? _onTypingAlert;
  ChatCallback? _onLeave;
  ChatCallback? _onCheckOnlineStatus;
  ChatCallback? _onErrorNotify;
  ChatCallback? _onDisconnect;

  // Messages list
  final List<dynamic> messages = [];

  /// Constructor
  ChatSocket({
    required this.serverUrl,
    required this.userId,
  }) {
    _initializeSocket();
  }

  /// Initialize socket connection
  void _initializeSocket() {
    if (userId.isEmpty) {
      print('Error: userId cannot be empty');
      return;
    }

    print('$userId userId in chat socket');

    // Initialize socket with React Native compatible configuration
    _socket = IO.io(
      serverUrl,
      IO.OptionBuilder()
          .setExtraHeaders({
            'token': userId,
            'Authorization': 'Bearer $userId',
          })
          .build(),
    );

    _setupEventListeners();
  }

  /// Setup all event listeners
  void _setupEventListeners() {
    if (_socket == null) return;

    // Receive message event
    _socket!.on('receive_message', (data) {
      messages.add(data);
      _onMessageReceived?.call(data);
    });

    // Handshake success event
    _socket!.on('handshake_success', (data) {
      _onHandshakeSuccess?.call(data);
    });

    // Retrieve message event
    _socket!.on('retrieve_message', (data) {
      _onRetrieveMessages?.call(data);
    });

    // Message sent event
    _socket!.on('message_sent', (data) {
      _onMessageSent?.call(data);
    });

    // Chat list event
    _socket!.on('chatlist', (data) {
      _onChatList?.call(data);
    });

    // Message update event
    _socket!.on('message_update', (data) {
      _onMessageUpdate?.call(data);
    });

    // Message update receiver event
    _socket!.on('message_update_receiver', (data) {
      _onMessageUpdateReceiver?.call(data);
    });

    // Typing alert event
    _socket!.on('typing_alert', (data) {
      _onTypingAlert?.call(data);
    });

    // Leave event
    _socket!.on('leave', (data) {
      _onLeave?.call(data);
      // Also trigger disconnect callback for leave event
      _onDisconnect?.call(data);
    });

    // Online status event
    _socket!.on('online_status', (data) {
      _onCheckOnlineStatus?.call(data);
    });

    // Error notify event
    _socket!.on('error_notify', (data) {
      _onErrorNotify?.call(data);
    });

    // Disconnect event
    _socket!.on('disconnect', (data) {
      _onDisconnect?.call(data);
    });
  }

  /// Send a message
  void sendMessage(SendMessageParams params) {
    if (_socket == null) return;
    _socket!.emit('send_message', params.toJson());
  }

  /// Join a chat
  void joinChat(JoinChatParams params) {
    if (_socket == null) return;
    _socket!.emit('joinchat', params.toJson());
  }

  /// Update typing alert
  void updateTypingAlert(TypingAlertParams params) {
    if (_socket == null) return;
    _socket!.emit('user_typing', params.toJson());
  }

  /// Delete a message
  void deleteMessage(DeleteMessageParams params) {
    if (_socket == null) return;
    _socket!.emit('delete_message', params.toJson());
  }

  /// Get chat list
  void getChatList(ChatListParams params) {
    if (_socket == null) return;
    _socket!.emit('get_chatlist', params.toJson());
  }

  /// Check online status
  void checkOnlineStatus(CheckOnlineStatusParams params) {
    if (_socket == null) return;
    _socket!.emit('check_online_status', params.toJson());
  }

  /// Disconnect user
  void disconnectUser() {
    if (_socket == null) return;
    _socket!.emit('disconnect_user');
  }

  /// Retrieve messages
  void retrieveMessages(RetrieveMessagesParams params) {
    if (_socket == null) return;
    _socket!.emit('chat_message', params.toJson());
  }

  // Callback setters
  void setHandshakeSuccessCallback(ChatCallback callback) {
    _onHandshakeSuccess = callback;
  }

  void setMessageReceivedCallback(ChatCallback callback) {
    _onMessageReceived = callback;
  }

  void setMessageSentCallback(ChatCallback callback) {
    _onMessageSent = callback;
  }

  void setRetrieveMessagesCallback(ChatCallback callback) {
    _onRetrieveMessages = callback;
  }

  void setChatListCallback(ChatCallback callback) {
    _onChatList = callback;
  }

  void setMessageUpdateCallback(ChatCallback callback) {
    _onMessageUpdate = callback;
  }

  void setReceiverMessageUpdateCallback(ChatCallback callback) {
    _onMessageUpdateReceiver = callback;
  }

  void setTypingAlertCallback(ChatCallback callback) {
    _onTypingAlert = callback;
  }

  void setOnLeaveCallback(ChatCallback callback) {
    _onLeave = callback;
  }

  void setOnCheckOnlineStatus(ChatCallback callback) {
    _onCheckOnlineStatus = callback;
  }

  void setOnErrorNotify(ChatCallback callback) {
    _onErrorNotify = callback;
  }

  void setOnDisconnect(ChatCallback callback) {
    _onDisconnect = callback;
  }

  /// Dispose and cleanup
  void dispose() {
    if (_socket != null) {
      _socket!.emit('disconnect_user');
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
  }

  /// Check if socket is connected
  bool get isConnected => _socket?.connected ?? false;
}

