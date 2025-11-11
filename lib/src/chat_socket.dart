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
      print('[ChatSocket] Error: userId cannot be empty');
      return;
    }

    if (serverUrl.isEmpty) {
      print('[ChatSocket] Error: serverUrl cannot be empty');
      return;
    }

    print('[ChatSocket] Initializing socket connection...');
    print('[ChatSocket] Server URL: $serverUrl');
    print('[ChatSocket] User ID: $userId');

    // Initialize socket with React Native compatible configuration
    _socket = IO.io(
      serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .setExtraHeaders({
            'token': userId,
            'Authorization': 'Bearer $userId',
          })
          .enableAutoConnect()
          .enableReconnection()
          .build(),
    );

    _setupEventListeners();
    _setupConnectionListeners();
  }

  /// Setup connection event listeners
  void _setupConnectionListeners() {
    if (_socket == null) return;

    // Connection successful
    _socket!.on('connect', (_) {
      print('[ChatSocket] ✅ Socket connected successfully');
      print('[ChatSocket] Socket ID: ${_socket!.id}');
      print('[ChatSocket] Connected: ${_socket!.connected}');
    });

    // Connection error
    _socket!.on('connect_error', (error) {
      print('[ChatSocket] ❌ Connection error: $error');
      print('[ChatSocket] Error details: ${error.toString()}');
      _onErrorNotify?.call({
        'type': 'connection_error',
        'message': error.toString(),
        'error': error,
      });
    });

    // Reconnecting
    _socket!.on('reconnecting', (attemptNumber) {
      print('[ChatSocket] 🔄 Reconnecting... Attempt: $attemptNumber');
    });

    // Reconnection attempt failed
    _socket!.on('reconnect_error', (error) {
      print('[ChatSocket] ❌ Reconnection error: $error');
    });

    // Reconnection failed
    _socket!.on('reconnect_failed', () {
      print('[ChatSocket] ❌ Reconnection failed');
      _onErrorNotify?.call({
        'type': 'reconnect_failed',
        'message': 'Failed to reconnect to server',
      });
    });

    // Reconnected successfully
    _socket!.on('reconnect', (attemptNumber) {
      print('[ChatSocket] ✅ Reconnected successfully after $attemptNumber attempts');
    });
  }

  /// Setup all event listeners
  void _setupEventListeners() {
    if (_socket == null) return;

    // Receive message event
    _socket!.on('receive_message', (data) {
      print('[ChatSocket] 📨 Message received: $data');
      messages.add(data);
      _onMessageReceived?.call(data);
    });

    // Handshake success event
    _socket!.on('handshake_success', (data) {
      print('[ChatSocket] 🤝 Handshake success: $data');
      _onHandshakeSuccess?.call(data);
    });

    // Retrieve message event
    _socket!.on('retrieve_message', (data) {
      print('[ChatSocket] 📋 Messages retrieved: $data');
      _onRetrieveMessages?.call(data);
    });

    // Message sent event
    _socket!.on('message_sent', (data) {
      print('[ChatSocket] ✅ Message sent: $data');
      _onMessageSent?.call(data);
    });

    // Chat list event
    _socket!.on('chatlist', (data) {
      print('[ChatSocket] 💬 Chat list received: $data');
      _onChatList?.call(data);
    });

    // Message update event
    _socket!.on('message_update', (data) {
      print('[ChatSocket] ✏️ Message updated: $data');
      _onMessageUpdate?.call(data);
    });

    // Message update receiver event
    _socket!.on('message_update_receiver', (data) {
      print('[ChatSocket] ✏️ Receiver message updated: $data');
      _onMessageUpdateReceiver?.call(data);
    });

    // Typing alert event
    _socket!.on('typing_alert', (data) {
      print('[ChatSocket] ⌨️ Typing alert: $data');
      _onTypingAlert?.call(data);
    });

    // Leave event
    _socket!.on('leave', (data) {
      print('[ChatSocket] 👋 User left: $data');
      _onLeave?.call(data);
      // Also trigger disconnect callback for leave event
      _onDisconnect?.call(data);
    });

    // Online status event
    _socket!.on('online_status', (data) {
      print('[ChatSocket] 🟢 Online status: $data');
      _onCheckOnlineStatus?.call(data);
    });

    // Error notify event
    _socket!.on('error_notify', (data) {
      print('[ChatSocket] ⚠️ Error notification: $data');
      _onErrorNotify?.call(data);
    });

    // Disconnect event
    _socket!.on('disconnect', (reason) {
      print('[ChatSocket] 🔌 Socket disconnected. Reason: $reason');
      _onDisconnect?.call(reason);
    });
  }

  /// Send a message
  void sendMessage(SendMessageParams params) {
    if (_socket == null) {
      print('[ChatSocket] ❌ Cannot send message: Socket is null');
      return;
    }
    if (!_socket!.connected) {
      print('[ChatSocket] ❌ Cannot send message: Socket is not connected');
      return;
    }
    print('[ChatSocket] 📤 Sending message: ${params.toJson()}');
    _socket!.emit('send_message', params.toJson());
  }

  /// Join a chat
  void joinChat(JoinChatParams params) {
    if (_socket == null) {
      print('[ChatSocket] ❌ Cannot join chat: Socket is null');
      return;
    }
    if (!_socket!.connected) {
      print('[ChatSocket] ❌ Cannot join chat: Socket is not connected');
      return;
    }
    print('[ChatSocket] 🚪 Joining chat: ${params.toJson()}');
    _socket!.emit('joinchat', params.toJson());
  }

  /// Update typing alert
  void updateTypingAlert(TypingAlertParams params) {
    if (_socket == null) {
      print('[ChatSocket] ❌ Cannot update typing alert: Socket is null');
      return;
    }
    if (!_socket!.connected) {
      print('[ChatSocket] ❌ Cannot update typing alert: Socket is not connected');
      return;
    }
    print('[ChatSocket] ⌨️ Updating typing alert: ${params.toJson()}');
    _socket!.emit('user_typing', params.toJson());
  }

  /// Delete a message
  void deleteMessage(DeleteMessageParams params) {
    if (_socket == null) {
      print('[ChatSocket] ❌ Cannot delete message: Socket is null');
      return;
    }
    if (!_socket!.connected) {
      print('[ChatSocket] ❌ Cannot delete message: Socket is not connected');
      return;
    }
    print('[ChatSocket] 🗑️ Deleting message: ${params.toJson()}');
    _socket!.emit('delete_message', params.toJson());
  }

  /// Get chat list
  void getChatList(ChatListParams params) {
    if (_socket == null) {
      print('[ChatSocket] ❌ Cannot get chat list: Socket is null');
      return;
    }
    if (!_socket!.connected) {
      print('[ChatSocket] ❌ Cannot get chat list: Socket is not connected');
      return;
    }
    print('[ChatSocket] 📋 Getting chat list: ${params.toJson()}');
    _socket!.emit('get_chatlist', params.toJson());
  }

  /// Check online status
  void checkOnlineStatus(CheckOnlineStatusParams params) {
    if (_socket == null) {
      print('[ChatSocket] ❌ Cannot check online status: Socket is null');
      return;
    }
    if (!_socket!.connected) {
      print('[ChatSocket] ❌ Cannot check online status: Socket is not connected');
      return;
    }
    print('[ChatSocket] 🟢 Checking online status: ${params.toJson()}');
    _socket!.emit('check_online_status', params.toJson());
  }

  /// Disconnect user
  void disconnectUser() {
    if (_socket == null) {
      print('[ChatSocket] ❌ Cannot disconnect: Socket is null');
      return;
    }
    print('[ChatSocket] 🔌 Disconnecting user...');
    _socket!.emit('disconnect_user');
  }

  /// Retrieve messages
  void retrieveMessages(RetrieveMessagesParams params) {
    if (_socket == null) {
      print('[ChatSocket] ❌ Cannot retrieve messages: Socket is null');
      return;
    }
    if (!_socket!.connected) {
      print('[ChatSocket] ❌ Cannot retrieve messages: Socket is not connected');
      return;
    }
    print('[ChatSocket] 📥 Retrieving messages: ${params.toJson()}');
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
      print('[ChatSocket] 🧹 Disposing socket...');
      _socket!.emit('disconnect_user');
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      print('[ChatSocket] ✅ Socket disposed');
    }
  }

  /// Check if socket is connected
  bool get isConnected => _socket?.connected ?? false;
}

