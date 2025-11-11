## 1.1.2

* **Fixed critical connection issues**: Added proper connection event listeners
* **Added comprehensive logging**: All socket events and operations now log with `[ChatSocket]` prefix for easy debugging
* **Improved error handling**: Connection errors, reconnection failures, and operation errors are now properly logged and reported
* **Added connection validation**: All operations now check if socket is connected before executing
* **Enhanced socket configuration**: Added explicit transport configuration and auto-reconnection
* **Better debugging**: Users can now see connection status, errors, and all socket events in console/logs

## 1.0.0

* Initial release of ChatStorm Client for Flutter
* Real-time chat functionality using Socket.IO
* Support for sending messages (text, link, media)
* Typing indicators
* Online status checking
* Message history retrieval
* Chat list management
* Message update and delete operations
* Comprehensive callback system for all events
* Error handling and disconnection management

