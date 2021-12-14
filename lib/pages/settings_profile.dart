import 'package:flutter/material.dart';

class SettingsProfile extends StatefulWidget {
  const SettingsProfile({Key? key}) : super(key: key);

  @override
  _SettingsProfileState createState() => _SettingsProfileState();
}

class _SettingsProfileState extends State<SettingsProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('プロフィール編集'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Row(
              children: [
                Container(width: 100, child: Text('名前')),
                Expanded(child: TextField()),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Container(width: 100, child: Text('サムネイル')),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 150,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('画像を選択'),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ]),
        ));
  }
}
