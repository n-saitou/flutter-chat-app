import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/talk_room.dart';
import 'package:chat_app/utils/firebase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as Intl;

class TalkRoomPage extends StatefulWidget {
  const TalkRoomPage({Key? key, required this.room}) : super(key: key);

  final TalkRoom room;

  @override
  _TalkRoomPageState createState() => _TalkRoomPageState();
}

class _TalkRoomPageState extends State<TalkRoomPage> {
  List<Message> messageList = [];

  Future<void> getMessages() async {
    messageList = await Firestore.getMessages(widget.room.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(title: Text(widget.room.talkUser.name)),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: FutureBuilder(
              future: getMessages(),
              builder: (context, snapshot) {
                return (ListView.builder(
                    physics: const RangeMaintainingScrollPhysics(),
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                      DateTime sendTime = messageList[index].sendTime.toDate();
                      return Padding(
                        padding: EdgeInsets.only(
                            top: 10,
                            right: 10,
                            left: 10,
                            bottom: index == 0 ? 10 : 0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            textDirection: messageList[index].isMe
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            children: [
                              Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 6.0),
                                  decoration: BoxDecoration(
                                      color: messageList[index].isMe
                                          ? Colors.green
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(messageList[index].message)),
                              Text(
                                Intl.DateFormat('HH:mm')
                                    .format(sendTime),
                                style: const TextStyle(fontSize: 10),
                              )
                            ]),
                      );
                    }));
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              color: Colors.white,
              child: Row(
                children: [
                  const Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder())),
                  )),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      print('送信');
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
