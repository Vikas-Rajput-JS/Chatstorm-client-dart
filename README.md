# ChatStorm Client for Flutter

A powerful real-time chat client built using Socket.IO for Flutter applications. ChatStorm Client provides an easy-to-use interface for integrating socket-based messaging into your Flutter apps with comprehensive event handling and callback systems.

## 🚀 Features

- **Real-time Communication**: Instant message delivery and updates
- **Socket.IO Integration**: Robust WebSocket connection management
- **Event-driven Architecture**: Comprehensive callback system for all events
- **Typing Indicators**: Real-time typing status notifications
- **Message History**: Retrieve and search past conversations
- **Chat Management**: Join chats, get chat lists, and manage conversations
- **Message Operations**: Send, delete, and update messages (supports text, links, and media)
- **Online Status**: Check if users are online in real-time
- **Error Handling**: Built-in error notification system
- **Auto-reconnection**: Automatic connection handling and cleanup

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  chatstorm_client: ^1.0.1
```

Then run:

```bash
flutter pub get
```

### Peer Dependencies

Make sure you have the following in your `pubspec.yaml`:

```yaml
dependencies:
  socket_io_client: ^2.0.3+1
  flutter:
    sdk: flutter
```

## 🏃‍♂️ Quick Start

### Basic Setup

```dart
import 'package:chatstorm_client/chatstorm_client.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatSocket chatSocket;
  final String serverUrl = 'http://localhost:3001';
  final String userId = 'your-user-id-here';
  
  List<dynamic> messages = [];

  @override
  void initState() {
    super.initState();
    
    // Initialize ChatSocket
    chatSocket = ChatSocket(
      serverUrl: serverUrl,
      userId: userId,
    );

    // Set up event callbacks
    chatSocket.setHandshakeSuccessCallback((data) {
      print('Connected successfully: $data');
    });

    chatSocket.setMessageReceivedCallback((message) {
      setState(() {
        messages.add(message);
      });
      print('New message received: $message');
    });

    chatSocket.setChatListCallback((chatList) {
      print('Chat list updated: $chatList');
    });

    chatSocket.setRetrieveMessagesCallback((messages) {
      print('Messages retrieved: $messages');
    });

    chatSocket.setOnCheckOnlineStatus((data) {
      print('Online status: $data');
    });

    chatSocket.setOnErrorNotify((error) {
      print('Error notification: $error');
    });

    chatSocket.setOnDisconnect((data) {
      print('Disconnected: $data');
    });
  }

  @override
  void dispose() {
    chatSocket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Application')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index].toString()),
                );
              },
            ),
          ),
          // Your chat UI components here
        ],
      ),
    );
  }
}
```

## 📚 API Reference

### ChatSocket Class

#### Constructor

```dart
ChatSocket({
  required String serverUrl,
  required String userId,
})
```

- `serverUrl`: WebSocket server URL (e.g., 'http://localhost:3001')
- `userId`: Unique identifier for the current user

#### Core Functions

| Function | Parameters | Description |
|----------|------------|-------------|
| `sendMessage` | `SendMessageParams` | Send a message to a specific user (supports text, link, and media) |
| `joinChat` | `JoinChatParams` | Join a chat with another user |
| `getChatList` | `ChatListParams` | Retrieve list of available chats |
| `retrieveMessages` | `RetrieveMessagesParams` | Get message history with a user |
| `updateTypingAlert` | `TypingAlertParams` | Send typing status |
| `deleteMessage` | `DeleteMessageParams` | Delete a specific message |
| `checkOnlineStatus` | `CheckOnlineStatusParams` | Check if a user is online |
| `disconnectUser` | `()` | Manually disconnect the user from the socket |
| `dispose` | `()` | Clean up and disconnect the socket |

#### Callback Setters

| Function | Description |
|----------|-------------|
| `setHandshakeSuccessCallback` | Called when connection is established |
| `setMessageReceivedCallback` | Called when a new message is received |
| `setMessageSentCallback` | Called when a message is sent successfully |
| `setChatListCallback` | Called when chat list is updated |
| `setRetrieveMessagesCallback` | Called when messages are retrieved |
| `setMessageUpdateCallback` | Called when a message is updated |
| `setReceiverMessageUpdateCallback` | Called when receiver updates a message |
| `setTypingAlertCallback` | Called when typing status is received |
| `setOnLeaveCallback` | Called when a user leaves the chat |
| `setOnCheckOnlineStatus` | Called when online status is received |
| `setOnErrorNotify` | Called when an error notification is received |
| `setOnDisconnect` | Called when the socket connection is disconnected |

#### Properties

- `messages`: List of current messages in the chat
- `isConnected`: Boolean indicating if socket is connected

### Models

#### SendMessageParams

```dart
SendMessageParams({
  required String receiverId,
  required ChatMessage message,
})
```

#### ChatMessage

```dart
ChatMessage({
  required String text,
  String link = '',
  String media = '',
})
```

#### JoinChatParams

```dart
JoinChatParams({
  required String receiverId,
})
```

#### TypingAlertParams

```dart
TypingAlertParams({
  required String receiverId,
  required bool isTyping,
})
```

#### DeleteMessageParams

```dart
DeleteMessageParams({
  required String messageId,
})
```

#### RetrieveMessagesParams

```dart
RetrieveMessagesParams({
  required String receiverId,
  String keyword = '',
})
```

#### ChatListParams

```dart
ChatListParams({
  String keyword = '',
})
```

#### CheckOnlineStatusParams

```dart
CheckOnlineStatusParams({
  required String receiverId,
})
```

## 💡 Use Cases

### 1. Private Messaging App

```dart
class PrivateChatScreen extends StatefulWidget {
  @override
  _PrivateChatScreenState createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  late ChatSocket chatSocket;
  List<dynamic> chatList = [];
  String? currentChatId;
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatSocket = ChatSocket(
      serverUrl: 'http://localhost:3001',
      userId: 'user123',
    );

    // Load chat list
    chatSocket.getChatList(ChatListParams(keyword: ''));

    chatSocket.setChatListCallback((data) {
      setState(() {
        chatList = data['chats'] ?? [];
      });
    });

    chatSocket.setMessageReceivedCallback((message) {
      print('New message: $message');
    });
  }

  void handleSendMessage() {
    if (messageController.text.trim().isNotEmpty && currentChatId != null) {
      chatSocket.sendMessage(
        SendMessageParams(
          receiverId: currentChatId!,
          message: ChatMessage(
            text: messageController.text,
            link: '',
            media: '',
          ),
        ),
      );
      messageController.clear();
    }
  }

  void handleSelectChat(String chatId) {
    setState(() {
      currentChatId = chatId;
    });
    chatSocket.joinChat(JoinChatParams(receiverId: chatId));
    chatSocket.retrieveMessages(
      RetrieveMessagesParams(receiverId: chatId, keyword: ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Chat List Sidebar
          Container(
            width: 300,
            child: ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                final chat = chatList[index];
                return ListTile(
                  title: Text(chat['name'] ?? ''),
                  onTap: () => handleSelectChat(chat['id']),
                );
              },
            ),
          ),
          // Chat Area
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: chatSocket.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatSocket.messages[index];
                      return ListTile(
                        title: Text(message.toString()),
                      );
                    },
                  ),
                ),
                TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                  ),
                  onSubmitted: (_) => handleSendMessage(),
                ),
                ElevatedButton(
                  onPressed: handleSendMessage,
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    chatSocket.dispose();
    messageController.dispose();
    super.dispose();
  }
}
```

### 2. Customer Support Chat

```dart
class CustomerSupportScreen extends StatefulWidget {
  @override
  _CustomerSupportScreenState createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
  late ChatSocket chatSocket;
  bool isTyping = false;
  String? supportAgent;

  @override
  void initState() {
    super.initState();
    chatSocket = ChatSocket(
      serverUrl: 'http://support.example.com',
      userId: 'customer123',
    );

    chatSocket.joinChat(JoinChatParams(receiverId: 'support-agent-001'));

    chatSocket.setHandshakeSuccessCallback((data) {
      setState(() {
        supportAgent = data['agent'];
      });
    });

    chatSocket.setTypingAlertCallback((data) {
      setState(() {
        isTyping = data['isTyping'] ?? false;
      });
    });
  }

  void handleTyping(bool typing) {
    chatSocket.updateTypingAlert(
      TypingAlertParams(
        receiverId: 'support-agent-001',
        isTyping: typing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer Support')),
      body: Column(
        children: [
          if (supportAgent != null)
            Text('Connected to: $supportAgent'),
          Expanded(
            child: ListView.builder(
              itemCount: chatSocket.messages.length,
              itemBuilder: (context, index) {
                final message = chatSocket.messages[index];
                return ListTile(
                  title: Text(message.toString()),
                );
              },
            ),
          ),
          if (isTyping) Text('Support agent is typing...'),
          TextField(
            onTap: () => handleTyping(true),
            onSubmitted: (value) {
              chatSocket.sendMessage(
                SendMessageParams(
                  receiverId: 'support-agent-001',
                  message: ChatMessage(text: value),
                ),
              );
            },
            decoration: InputDecoration(
              hintText: 'Type your message...',
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    chatSocket.dispose();
    super.dispose();
  }
}
```

### 3. Online Status Example

```dart
class ChatWithOnlineStatus extends StatefulWidget {
  @override
  _ChatWithOnlineStatusState createState() => _ChatWithOnlineStatusState();
}

class _ChatWithOnlineStatusState extends State<ChatWithOnlineStatus> {
  late ChatSocket chatSocket;
  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    chatSocket = ChatSocket(
      serverUrl: 'http://localhost:3001',
      userId: 'user123',
    );

    chatSocket.setOnCheckOnlineStatus((data) {
      setState(() {
        isOnline = data['isOnline'] ?? false;
      });
    });
  }

  void handleCheckStatus(String receiverId) {
    chatSocket.checkOnlineStatus(
      CheckOnlineStatusParams(receiverId: receiverId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => handleCheckStatus('target-user-id'),
            child: Text('Check Online Status'),
          ),
          Text(isOnline ? '🟢 Online' : '🔴 Offline'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    chatSocket.dispose();
    super.dispose();
  }
}
```

## 🔧 Advanced Configuration

### Custom Event Handling

```dart
class AdvancedChatScreen extends StatefulWidget {
  @override
  _AdvancedChatScreenState createState() => _AdvancedChatScreenState();
}

class _AdvancedChatScreenState extends State<AdvancedChatScreen> {
  late ChatSocket chatSocket;

  @override
  void initState() {
    super.initState();
    chatSocket = ChatSocket(
      serverUrl: 'http://localhost:3001',
      userId: 'user123',
    );

    // Handle message updates
    chatSocket.setMessageUpdateCallback((data) {
      print('Message updated: $data');
      // Update UI to show edited message
    });

    chatSocket.setReceiverMessageUpdateCallback((data) {
      print('Receiver updated message: $data');
      // Handle when other user edits their message
    });

    chatSocket.setOnLeaveCallback((data) {
      print('User left: $data');
      // Handle user leaving the chat
    });

    chatSocket.setOnCheckOnlineStatus((data) {
      print('User online status: $data');
      // Handle online status updates
    });

    chatSocket.setOnErrorNotify((error) {
      print('Error occurred: $error');
      // Handle error notifications
    });

    chatSocket.setOnDisconnect((data) {
      print('Socket disconnected: $data');
      // Handle disconnection (e.g., show reconnection UI)
    });
  }

  void handleDeleteMessage(String messageId) {
    chatSocket.deleteMessage(DeleteMessageParams(messageId: messageId));
  }

  void handleDisconnect() {
    chatSocket.disconnectUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Advanced Chat')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: handleDisconnect,
            child: Text('Disconnect'),
          ),
          // Your chat UI with delete functionality
        ],
      ),
    );
  }

  @override
  void dispose() {
    chatSocket.dispose();
    super.dispose();
  }
}
```

## 🐛 Troubleshooting

### Common Issues

1. **Connection Failed**
   ```dart
   // Ensure your server URL is correct and accessible
   final serverUrl = 'http://localhost:3001'; // or 'https://' for secure connections
   ```

2. **Messages Not Received**
   ```dart
   // Make sure to set up callbacks before sending messages
   @override
   void initState() {
     super.initState();
     chatSocket.setMessageReceivedCallback((message) {
       print('Message received: $message');
     });
   }
   ```

3. **Typing Indicators Not Working**
   ```dart
   // Ensure you're calling updateTypingAlert with correct parameters
   chatSocket.updateTypingAlert(
     TypingAlertParams(
       receiverId: 'target-user-id',
       isTyping: true, // or false
     ),
   );
   ```

4. **Socket Not Connecting**
   - Check if the server URL is correct
   - Ensure the server is running and accessible
   - Check network permissions in your Flutter app

### Debug Mode

Enable debug logging:

```dart
chatSocket.setHandshakeSuccessCallback((data) {
  print('🔗 Connection established: $data');
});

chatSocket.setMessageReceivedCallback((message) {
  print('📨 Message received: $message');
});

chatSocket.setChatListCallback((chatList) {
  print('💬 Chat list updated: $chatList');
});

chatSocket.setOnCheckOnlineStatus((data) {
  print('🟢 Online status: $data');
});

chatSocket.setOnErrorNotify((error) {
  print('❌ Error notification: $error');
});

chatSocket.setOnDisconnect((data) {
  print('🔌 Disconnected: $data');
});
```

## 📄 License

ISC License - see LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

For support and questions, please open an issue on the GitHub repository.

---

**Made with ❤️ by Vikas Rajput**

