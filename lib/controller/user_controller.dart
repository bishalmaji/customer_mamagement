import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var isLoggedIn = false.obs;
  SharedPreferences? _prefs;

  @override
  void onInit() {
    _loadLoginStatus();
    super.onInit();
  }

  Future<void> _loadLoginStatus() async {
    _prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = _prefs?.getBool('login') ?? false;
  }

  Future<void> login(String email, String password) async {
    if (email == 'user@maxmobility.in' && password == 'Abc@#123') {
      isLoggedIn.value = true;
      _prefs?.setBool('login', true);
    }
  }

  Future<void> logout() async {
    isLoggedIn.value = false;
    _prefs?.setBool('login', false);
  }
}
