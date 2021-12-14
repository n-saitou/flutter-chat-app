import 'package:chat_app/model/user.dart';
import 'package:chat_app/utils/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<void> setUid(String newUid) async {
    final prefs = await _prefs;
    prefs.setString('uid', newUid);

    print('端末保存完了');
  }

  static Future<String> getUid() async {
    final prefs = await _prefs;
    String? uid = prefs.getString('uid');
    return uid ?? "";
  }

  static Future<User> getProfile(String uid) async {
    final profile = await Firestore.userRef.doc(uid).get();
    final myProfile = User(
        name: profile.data()!['name'],
        imagePath: profile.data()!['image_path'],
        uid: uid);

    return myProfile;
  }
}
