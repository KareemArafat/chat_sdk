import 'package:shared_preferences/shared_preferences.dart';

class ShardpModel {
  Future<void> setLoginValue({bool flag=true}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('Login', flag);
  }

  Future<bool> getLoginValue() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool('Login') ?? false;
  }

  Future<void> setFirstName(String x) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('first', x);
  }

  Future<String> getFirstName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('first') ?? '';
  }

  Future<void> setLastName(String x) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('last', x);
  }

  Future<String> getLastName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('last') ?? '';
  }

  Future<void> setSenderId(String x) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('id', x);
  }

  Future<String> getSenderId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('id') ?? '';
  }

  Future<void> setToken(String x) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('tok', x);
  }

  Future<String> getToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('tok') ?? '';
  }

  Future<String> getFullName() async {
    String firstName = await ShardpModel().getFirstName();
    String lastName = await ShardpModel().getLastName();
    return '$firstName $lastName';
  }

  
  Future<void> setUserName(String x) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('username', x);
  }
   Future<String> getUserName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('username') ?? '';
  }
}
