import 'package:flutter/material.dart';
import 'package:chatstorm_client/chatstorm_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatStorm Client Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatExampleScreen(),
    );
  }
}

class ChatExampleScreen extends StatefulWidget {
  @override
  _ChatExampleScreenState createState() => _ChatExampleScreenState();
}

class _ChatExampleScreenState extends State<ChatExampleScreen> {
  late ChatSocket chatSocket;
  final TextEditingController messageController = TextEditingController();
  final TextEditingController receiverIdController = TextEditingController(
    text: 'target-user-id',
  );
  final TextEditingController serverUrlController = TextEditingController(
    text: 'http://localhost:3001',
  );
  final TextEditingController userIdController = TextEditingController(
    text: 'your-user-id',
  );

  bool isConnected = false;
  String connectionStatus = 'Not Connected';

  @override
  void initState() {
    super.initState();
    _initializeSocket();
  }

  void _initializeSocket() {
    if (userIdController.text.isEmpty || serverUrlController.text.isEmpty) {
      setState(() {
        connectionStatus = 'Please enter Server URL and User ID';
      });
      return;
    }

    chatSocket = ChatSocket(
      serverUrl: serverUrlController.text,
      userId: userIdController.text,
    );

    // Set up callbacks
    chatSocket.setHandshakeSuccessCallback((data) {
      setState(() {
        isConnected = true;
        connectionStatus = 'Connected';
      });
      print('Connected successfully: $data');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connected successfully!')),
      );
    });

    chatSocket.setMessageReceivedCallback((message) {
      print('New message received: $message');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New message received!')),
      );
    });

    chatSocket.setMessageSentCallback((data) {
      print('Message sent: $data');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message sent!')),
      );
    });

    chatSocket.setChatListCallback((chatList) {
      print('Chat list updated: $chatList');
    });

    chatSocket.setRetrieveMessagesCallback((messages) {
      print('Messages retrieved: $messages');
    });

    chatSocket.setOnCheckOnlineStatus((data) {
      print('Online status: $data');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Online status: ${data.toString()}')),
      );
    });

    chatSocket.setOnErrorNotify((error) {
      print('Error notification: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    });

    chatSocket.setOnDisconnect((data) {
      setState(() {
        isConnected = false;
        connectionStatus = 'Disconnected';
      });
      print('Disconnected: $data');
    });
  }

  void _sendMessage() {
    if (messageController.text.trim().isNotEmpty &&
        receiverIdController.text.isNotEmpty) {
      chatSocket.sendMessage(
        SendMessageParams(
          receiverId: receiverIdController.text,
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

  void _joinChat() {
    if (receiverIdController.text.isNotEmpty) {
      chatSocket.joinChat(
        JoinChatParams(receiverId: receiverIdController.text),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Joined chat with ${receiverIdController.text}')),
      );
    }
  }

  void _checkOnlineStatus() {
    if (receiverIdController.text.isNotEmpty) {
      chatSocket.checkOnlineStatus(
        CheckOnlineStatusParams(receiverId: receiverIdController.text),
      );
    }
  }

  void _getChatList() {
    chatSocket.getChatList(ChatListParams(keyword: ''));
  }

  void _retrieveMessages() {
    if (receiverIdController.text.isNotEmpty) {
      chatSocket.retrieveMessages(
        RetrieveMessagesParams(
          receiverId: receiverIdController.text,
          keyword: '',
        ),
      );
    }
  }

  void _disconnect() {
    chatSocket.disconnectUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatStorm Client Example'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connection Status
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Connection Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      connectionStatus,
                      style: TextStyle(
                        color: isConnected ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Server Configuration
            TextField(
              controller: serverUrlController,
              decoration: InputDecoration(
                labelText: 'Server URL',
                border: OutlineInputBorder(),
                hintText: 'http://localhost:3001',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: userIdController,
              decoration: InputDecoration(
                labelText: 'User ID',
                border: OutlineInputBorder(),
                hintText: 'your-user-id',
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                chatSocket.dispose();
                _initializeSocket();
              },
              child: Text('Connect/Reconnect'),
            ),
            SizedBox(height: 16),

            // Receiver ID
            TextField(
              controller: receiverIdController,
              decoration: InputDecoration(
                labelText: 'Receiver ID',
                border: OutlineInputBorder(),
                hintText: 'target-user-id',
              ),
            ),
            SizedBox(height: 16),

            // Action Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _joinChat,
                  child: Text('Join Chat'),
                ),
                ElevatedButton(
                  onPressed: _getChatList,
                  child: Text('Get Chat List'),
                ),
                ElevatedButton(
                  onPressed: _retrieveMessages,
                  child: Text('Retrieve Messages'),
                ),
                ElevatedButton(
                  onPressed: _checkOnlineStatus,
                  child: Text('Check Online Status'),
                ),
                ElevatedButton(
                  onPressed: _disconnect,
                  child: Text('Disconnect'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Message Input
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
                hintText: 'Type a message...',
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send Message'),
            ),
            SizedBox(height: 16),

            // Messages List
            Text(
              'Messages (${chatSocket.messages.length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ListView.builder(
                itemCount: chatSocket.messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      chatSocket.messages[index].toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    chatSocket.dispose();
    messageController.dispose();
    receiverIdController.dispose();
    serverUrlController.dispose();
    userIdController.dispose();
    super.dispose();
  }
}

