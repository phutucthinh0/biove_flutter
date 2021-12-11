import 'dart:convert';
import 'dart:io';

import 'package:biove/data/db.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HandleApi extends GetConnect{
  Future<dynamic> GET(String url) async{
    Response res= await get(url);
    if(res.statusCode!=200) return null;
    // print(res.bodyString);
    return jsonDecode(res.bodyString as String);
  }
  Future<dynamic> POST(String url, Map<String,dynamic> body) async{
    Response res = await post(url, body);
    if(res.statusCode!=200) return null;
    return jsonDecode(res.bodyString as String);
  }
  Future<dynamic> POSTASSETS(String url, XFile? file)async{
    final form = FormData({
      'user_id': db.getAccountId(),
      'name':DateTime.now().millisecondsSinceEpoch.toString(),
      'file': MultipartFile(file?.path, filename: 'upload'),
    });
    Response res = await post(url, form);
    if(res.statusCode!=200){
      print('ERROR');
      print(res.body);
      return null;
    }
    return jsonDecode(res.bodyString as String);
  }
  Future<dynamic> POSTASSETSTREE(String url, XFile? file)async{
    final form = FormData({
      'name':DateTime.now().millisecondsSinceEpoch.toString(),
      'file': MultipartFile(file!.path, filename: 'upload'),
    });
    Response res = await post(url, form);
    if(res.statusCode!=200){
      print('ERROR');
      print(res.body);
      return null;
    }
    return jsonDecode(res.bodyString as String);
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    httpClient.timeout = Duration(seconds: 10);
  }
}
HandleApi handleApi = HandleApi();
const String root_url = "https://api.biove.life";
// const String map_base_url = "https://2.base.maps.api.here.com/maptile/2.1/maptile/9ab8a6c072/normal.day/${z}/${x}/${y}/512/png8?app_id=VgTVFr1a0ft1qGcLCVJ6&app_code=LJXqQ8ErW71UsRUK3R33Ow&lg=vie&ppi=72&pview=VNM";
// const String root_url = "https://3.aerial.maps.api.here.com/maptile/2.1/maptile/9ab8a6c072/hybrid.day/${z}/${x}/${y}/512/png8?app_id=VgTVFr1a0ft1qGcLCVJ6&app_code=LJXqQ8ErW71UsRUK3R33Ow&lg=vie&ppi=72&pview=VNM";