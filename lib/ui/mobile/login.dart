import 'dart:ui';

import 'package:biove/apis/handle_api.dart';
import 'package:biove/data/db.dart';
import 'package:biove/ui/mobile/home.dart';
import 'package:biove/widgets/circle_loading.dart';
import 'package:biove/widgets/opacity_button.dart';
import 'package:biove/widgets/text_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  GoogleAuthProvider googleProvider = GoogleAuthProvider();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  _handleLoginGoogle() async{
    if(kIsWeb){
      googleProvider.addScope("email");
      googleProvider.setCustomParameters({
        'login_hint': 'user@example.com'
      });
      UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      setState(() {
        isLoading = true;
      });
      String _idToken =  await FirebaseAuth.instance.currentUser!.getIdToken();
      dynamic _dataLoginApp = await handleApi.POST('$root_url/auth/login', {'idToken':_idToken});
      if(_dataLoginApp!=null){
        await db.setAccountId(userCredential.user!.providerData[0].uid as String);
        await db.setAccountName(userCredential.user!.providerData[0].displayName as String);
        await db.setAccountEmail(userCredential.user!.providerData[0].email as String);
        await db.setAccountPicture(userCredential.user!.providerData[0].photoURL as String);
        await db.setAccountRole(_dataLoginApp['role']);
        _handleLoginSuccess();
      }

    }else{
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      String _idToken =  await FirebaseAuth.instance.currentUser!.getIdToken();
      dynamic _dataLoginApp = await handleApi.POST('$root_url/auth/login', {'idToken':_idToken});
      if(_dataLoginApp!=null){
        await db.setAccountId(userCredential.user!.providerData[0].uid as String);
        await db.setAccountName(userCredential.user!.providerData[0].displayName as String);
        await db.setAccountEmail(userCredential.user!.providerData[0].email as String);
        await db.setAccountPicture(userCredential.user!.providerData[0].photoURL as String);
        await db.setAccountRole(_dataLoginApp['role']);
        _handleLoginSuccess();
      }
    }
  }
  _handleLoginSuccess(){
    setState(() {
      isLoading = false;
    });
    Get.off(()=>HomeMobile());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      body: Stack(
        children: [
          Positioned(
            bottom: -Get.height*0.25,
            child: Image.asset("assets/bg_0.png", width: Get.width,),
          ),
          Align(
            alignment: Alignment.center,
            child: isLoading?CircleLoading():Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/logo.jpg", width: 120),
                SizedBox(height: 120),
                OpacityButton(
                  onTap: (){
                    _handleLoginGoogle();
                  },
                  child: Container(
                    width: 290,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        Image.asset("assets/icon_google.png", height: 28),
                        SizedBox(width: 10),
                        TextUI('sign_in_google'.tr, fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xff21546f),)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                OpacityButton(
                  onTap: (){

                  },
                  child: Container(
                    width: 290,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xff3b5998)
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 25),
                        Image.asset("assets/icon_facebook.png", height: 28),
                        SizedBox(width: 18),
                        TextUI('sign_in_facebook'.tr, fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white,)
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
