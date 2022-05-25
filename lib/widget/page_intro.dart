import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../manager/lms_manager.dart';
import '../sharedpreference_key.dart';

class PageIntro extends StatefulWidget {
  const PageIntro({Key? key}) : super(key: key);

  @override
  State<PageIntro> createState() => _PageIntroState();
}

class _PageIntroState extends State<PageIntro> {
  String? userID;
  String? password;
  double? _deviceWidth,
      _deviceheight; //사용자의 화면크기 비율을 정하기 위해, 사용자 화면 크기를 가져오면 변수.

  Future<void> initIntro() async {
    final prefs = await SharedPreferences.getInstance();
    userID = prefs.getString(keyUserId);
    password = prefs.getString(keyUserPw);
    bool? tutorialShowed = prefs.getBool(keyTutorialShowed);

    if (!tutorialShowed!) {
      //튜토리얼을 본적이 없을 경우
      Navigator.popAndPushNamed(context, '/tutorial'); //튜토리얼 페이지로 이동
    } else {
      //튜토리얼을 완료 경우
      if (!((userID == null || userID == "") &&
          (password == null || password == ""))) {
        // 저장된 아이디나 비밀번호가 있을 경우
        if ((await LmsManager().login(userID!, password!))) {
          // 저장된 값으로 로그인 진행
          Navigator.popAndPushNamed(context, '/main'); //자동로그인후 메인으로 이동
        } else {
          //저장된 ID/PW로 로그인이 실패할 경우
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("로그인 실패"))); //로그인 실패 팝업
          Navigator.popAndPushNamed(context, '/login'); // 로그인 페이지로 이동
        }
      } else {
        //저장된 ID/PW가 없을 경우
        Navigator.popAndPushNamed(context, '/login');
      }
    }
  }

  @override
  void initState() {
    Timer(Duration(seconds: 3),(){ //로고 보여주는시간 3초
    initIntro();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceheight = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: _deviceWidth,
          height: _deviceheight,
          decoration: const BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken),
                fit: BoxFit.fitHeight,
                image: AssetImage('resource/image/login_bg.png')), // 배경 이미지
          ),
          child: Column(
            //절대값 Expanded안에 작은 위젯(Container>ClipRRect>image)을 넣기 위함.
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logotag',
                child: Container(
                  // 이미지를 감싸는 컨테이너
                  child: ClipRRect(
                    //이미지 모서리를 둥글게하기 위한 위젯
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      //로고_이미지
                      "resource/image/icon_lmsreminder.png",
                      fit: BoxFit.contain,
                      width: 150,
                      height: 150,
                    ),
                  ),
                  decoration: BoxDecoration(
                    //그림자를 넣는 속성
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        color: Colors.white24,
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
