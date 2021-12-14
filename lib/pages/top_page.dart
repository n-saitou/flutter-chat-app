import 'package:chat_app/model/talk_room.dart';
import 'package:chat_app/pages/settings_profile.dart';
import 'package:chat_app/pages/talk_room.dart';
import 'package:chat_app/utils/firebase.dart';
import 'package:chat_app/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  List<TalkRoom> talkUserList = [];

  Future<void> createRooms() async {
    String uid = await SharedPrefs.getUid();
    talkUserList = await Firestore.getRooms(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('チャットアプリ'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsProfile()));
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.roomSnapshot,
          builder: (context, snapshot) {
            return FutureBuilder(
                future: createRooms(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        itemCount: talkUserList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TalkRoomPage(
                                          room:
                                              talkUserList[index])));
                            },
                            child: SizedBox(
                              height: 70,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            talkUserList[index].talkUser.imagePath),
                                        radius: 30),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(talkUserList[index].talkUser.name,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Text(talkUserList[index].lastMessage,
                                          style:
                                              const TextStyle(color: Colors.grey)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                });
          }
        ));
  }
}
