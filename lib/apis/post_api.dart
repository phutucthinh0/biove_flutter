import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class POSTAPI{
  static Future<dynamic> request(XFile? image) async {
    var request =  http.MultipartRequest('POST',
        Uri.https('api.biove.life', '/new-tree/upload-media'));
    request.headers["Content-Type"]='multipart/form-data';
    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        image!.path,
        filename: "upload",
      ),
    );
    request.fields.addAll({
      'name':DateTime.now().millisecondsSinceEpoch.toString(),
    });
    var response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      return Map<String,dynamic>.from(json.decode(response.body));
    }
    return null;
  }
}