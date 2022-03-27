import 'package:shared_preferences/shared_preferences.dart';

class DB {
  DB();
  Map<String, String> query = {};
  Map<String, dynamic> last_data_admin = {};
  late SharedPreferences prefs;
  Future<void> init() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    prefs = _prefs;
  }
  Future<void> setAccountToken(String data)async{
    await prefs.setString('account_token', data);
  }
  Future<void> setAccountName(String data)async{
    await prefs.setString('account_name', data);
  }
  Future<void> setAccountPicture(String data)async{
    await prefs.setString('account_picture', data);
  }
  Future<void> setAccountEmail(String data)async{
    await prefs.setString('account_email', data);
  }
  Future<void> setAccountId(String data)async{
    await prefs.setString('account_id', data);
  }
  Future<void> setAccountRole(int data)async{
    await prefs.setInt('account_role', data);
  }
  String getAccountToken(){
    return prefs.getString('account_token') ?? "";
  }
  String getAccountName(){
    return prefs.getString('account_name') ?? "";
  }
  String getAccountPicture(){
    return prefs.getString('account_picture') ?? "";
  }
  String getAccountEmail(){
    return prefs.getString('account_email') ?? "";
  }
  String getAccountId(){
    return prefs.getString('account_id') ?? "";
  }
  bool nullAccount(){
    return (prefs.getString('account_id') ?? "")=="";
  }
  int getAccountRole(){
    return prefs.getInt('account_role') ?? -1;
  }
  Future<void> setMapId(String data)async{
    await prefs.setString('mapId', data);
  }
  String getMapId(){
    return prefs.getString('mapId') ?? "4e5f275107";
  }
  Future<void> logout()async{
    await prefs.remove('account_name');
    await prefs.remove('account_picture');
    await prefs.remove('account_email');
    await prefs.remove('account_id');
    await prefs.remove('account_role');
  }
}
DB db = DB();