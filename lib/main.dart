// import 'dart:html';

import 'package:biove/l10n/L10N.dart';
import 'package:biove/ui/mobile/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';

import 'data/db.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await db.init();
  setPathUrlStrategy();
  // db.query = Uri.dataFromString(window.location.href).queryParameters;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  StatelessElement createElement() {
    return super.createElement();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: L10N(),
        locale: Locale('vi', 'VN'),
        title: 'BIOVE - Trồng cây cho thế hệ mai sau',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeMobile(),
        builder: EasyLoading.init(),
      ),
    );
  }
}