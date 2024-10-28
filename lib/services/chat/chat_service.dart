import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/model/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  //get instance of firestore & auth service
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get users stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  //send message
  Future<void> sendMessage(String receiverId, String message) async {
    //get current user
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
      senderEmail: currentUserEmail,
      message: message,
      receiverId: receiverId,
      senderId: currentUserId,
      timestamp: timestamp,
    );

    //construct chat room id  for the two users(sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); //sort to ensure uniqueness(this ensure thst the chatroom id is always the same for any pair of users)
    final String chatRoomId = ids.join('_');

    //add new message to firestore
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //retrieve messages
  Stream<QuerySnapshot> getMessagesStream(String otherUserId, String userId) {
    //construct chat room id
    List<String> ids = [userId, otherUserId];
    ids.sort();
    final String chatRoomId = ids.join('_');

    //retrieve messages from firestore
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
