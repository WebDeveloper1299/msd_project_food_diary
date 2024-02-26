import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferenceHelper {
  Future<void> setUsername(String username) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('username', username);
  }

  Future<String?> getUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('username');
  }
}

