import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/components/chat_bubble.dart';
import 'package:connect/components/my_textfield.dart';
import 'package:connect/services/auth/auth_service.dart';
import 'package:connect/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;
  ChatPage({super.key, required this.receiverEmail, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // chatbox controller
  final TextEditingController _messageController = TextEditingController();

  //chat & auth services
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();
  //for text fields
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    //add listner to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    //wait a bit  for listview to build
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll down

  final ScrollController scrollController = ScrollController();
  void scrollDown() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  //send message
  void sendMessage() async {
    //check if message is not empty
    if (_messageController.text.isNotEmpty) {
      //send message
      await _chatService.sendMessage(
          widget.receiverId, _messageController.text);
      //clear message controller
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverEmail)),
      body: Column(
        children: [
          //display messages
          Expanded(child: _buildMessageList()),
          //display message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessagesStream(widget.receiverId, senderId),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        //waiting
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Loading messages...'));
        }
        // return message list
        return ListView(
          controller: scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot message) {
    Map<String, dynamic> data = message.data() as Map<String, dynamic>;

    // is current user
    final bool isCurrentUser =
        data['senderId'] == _authService.getCurrentUser()!.uid;

    //align message to the left or right
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: alignment,
      child: ChatBubble(message: data['message'], isCurrentUser: isCurrentUser),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        children: [
          Expanded(
              child: MyTextfield(
                  hintText: "Type your message",
                  obscureText: false,
                  controller: _messageController,
                  focusNode: myFocusNode)),
          // send button
          Container(
            decoration:
                BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
            margin: const EdgeInsets.only(right: 25.0),
            child: IconButton(
                onPressed: sendMessage,
                icon: Icon(Icons.arrow_upward_rounded, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
