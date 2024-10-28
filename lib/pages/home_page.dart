import 'package:connect/components/my_drawer.dart';
import 'package:connect/components/user_tile.dart';
import 'package:connect/pages/chat_page.dart';
import 'package:connect/services/auth/auth_service.dart';
import 'package:connect/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  //chat & auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Connect"),
        ),
        drawer: MyDrawer(),
        body: _buildUsersList());
  }

// build a list of users except for the current logged in user
  Widget _buildUsersList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        //loading..
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        //return listview
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUsersListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // build individual tile for the user
  Widget _buildUsersListItem(
      Map<String, dynamic> userData, BuildContext context) {
    //display all user except current user
    if (userData['email'] != _authService.getCurrentUser()?.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          //tapped on a user -> create chat room and navigate to chat page
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                      receiverEmail: userData["email"],
                      receiverId: userData["uid"])));
        },
      );
    } else {
      return Container();
    }
  }
}
