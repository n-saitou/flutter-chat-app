import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/talk_room.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  static final FirebaseFirestore _firestoreInstance =
      FirebaseFirestore.instance;
  static final userRef = _firestoreInstance.collection('user');
  static final roomRef = _firestoreInstance.collection('room');
  static final roomSnapshot = roomRef.snapshots();

  static Future<void> addUser() async {
    try {
      final newDoc = await userRef.add({
        'name': '名無し',
        'image_path':
            'https://www.mgm-design.jp/wp-content/uploads/2018/01/00-1.jpg'
      });

      print('アカウント作成完了');
      await SharedPrefs.setUid(newDoc.id);

      final List<String> userIds = await getUser();
      for (var user in userIds) {
        if (user != newDoc.id) {
          await roomRef.add({
            'joined_user_ids': [user, newDoc.id],
            'updated_time': Timestamp.now()
          });

          print('ルーム作成完了');
        }
      }
    } on Exception catch (e) {
      print('アカウント作成に失敗しました　--- $e');
    }
  }

  static Future<List<String>> getUser() async {
    try {
      final snapshot = await userRef.get();
      List<String> userIds = [];
      for (var user in snapshot.docs) {
        userIds.add(user.id);
        print('ドキュメントID：${user.id} --- 名前：${user.data()['name']}');
      }

      return userIds;
    } on Exception catch (e) {
      print('取得失敗 --- $e');
      rethrow;
    }
  }

  static Future<List<TalkRoom>> getRooms(String myUid) async {
    final snapshot = await roomRef.get();
    List<TalkRoom> roomList = [];
    for (var doc in snapshot.docs) {
      if (!doc.data()['joined_user_ids'].contains(myUid)) {
        continue;
      }

      String yourUid = "";
      for (var id in doc.data()['joined_user_ids']) {
        if (id != myUid) {
          yourUid = id;
          break;
        }
      }

      if (yourUid.isNotEmpty) {
        User yourProfile = await SharedPrefs.getProfile(yourUid);
        TalkRoom room = TalkRoom(
            roomId: doc.id,
            talkUser: yourProfile,
            lastMessage: doc.data()['last_message'] ?? '');
        roomList.add(room);
      }
    }

    print(roomList.length);
    return roomList;
  }

  static Future<List<Message>> getMessages(String roomId) async {
    final messageRef = roomRef.doc(roomId).collection('message');
    List<Message> messageList = [];
    final snapshot = await messageRef.get();
    for (var doc in snapshot.docs) {
      bool isMe = false;
      String myUid = await SharedPrefs.getUid();
      if (doc.data()['sender_id'] == myUid) {
        isMe = true;
      }
      final message = Message(
          message: doc.data()['message'],
          isMe: isMe,
          sendTime: doc.data()['send_time']);
      messageList.add(message);
    }
    return messageList;
  }
}
