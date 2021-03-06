import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lms_reminder/sharedpreferences_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 설정 화면 위젯.
class ScreenSetting extends StatefulWidget {
  const ScreenSetting({Key? key}) : super(key: key);

  @override
  State<ScreenSetting> createState() => _ScreenSettingState();
}

class _ScreenSettingState extends State<ScreenSetting> {
  String? version = "1.0.0";
  String? lastUpdateTime = "";
  bool notifyFinishedActivities = false;
  bool notifyAssignmentSwitch = false;
  bool notifyAssignment6HourSwitch = false;
  bool notifyAssignment1daySwitch = false;
  bool notifyAssignment3daysSwitch = false;
  bool notifyAssignment5daysSwitch = false;
  bool notifyVideo = false;
  bool notifyVideo6Hours = false;
  bool notifyVideo1day = false;
  bool notifyVideo3days = false;
  bool notifyVideo5days = false;

  /// 설정 카테고리 텍스트 스타일.
  TextStyle categoryTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  /// 설정 텍스트 스타일.
  TextStyle optionTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 14,
  );

  /// 설정 하위 텍스트 스타일.
  TextStyle optionSummaryTextStyle = const TextStyle(
    color: Colors.grey,
    fontSize: 14,
  );

  @override
  void initState() {
    super.initState();
    _loadSetting();
  }

  /// SharedPreferences로부터 설정 데이터를 불러오는 함수.
  _loadSetting() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lastUpdateTime = (prefs.getString(keyLastUpdateTime));
      notifyFinishedActivities =
          (prefs.getBool(keyNotifyFinishedActivities) ?? false);
      notifyAssignmentSwitch = (prefs.getBool(keyNotifyAssignment) ?? false);
      notifyAssignment6HourSwitch =
          (prefs.getBool(keyNotifyAssignmentBefore6Hours) ?? false);
      notifyAssignment1daySwitch =
          (prefs.getBool(keyNotifyAssignmentBefore1Day) ?? false);
      notifyAssignment3daysSwitch =
          (prefs.getBool(keyNotifyAssignmentBefore3Days) ?? false);
      notifyAssignment5daysSwitch =
          (prefs.getBool(keyNotifyAssignmentBefore5Days) ?? false);
      notifyVideo = (prefs.getBool(keyNotifyVideo) ?? false);
      notifyVideo6Hours = (prefs.getBool(keyNotifyVideoBefore6Hours) ?? false);
      notifyVideo1day = (prefs.getBool(keyNotifyVideoBefore1Day) ?? false);
      notifyVideo3days = (prefs.getBool(keyNotifyVideoBefore3Days) ?? false);
      notifyVideo5days = (prefs.getBool(keyNotifyVideoBefore5Days) ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('설정'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          // 카테고리 - 일반.
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: Text("일반", style: categoryTextStyle),
          ),
          // 카테고리 - 일반 - 버전 표시.
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Icon(Icons.info),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16, left: 8),
                  child: Text(
                    "버전 " + version!,
                    style: optionTextStyle,
                  ),
                ),
              ],
            ),
          ),

          // 카테고리 - 알림.
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 24.0, bottom: 8.0),
            child: Text("알림", style: categoryTextStyle),
          ),
          // 알림 - 세부 설정.
          Column(
            children: <Widget>[
              // 알림 - 완료한 활동 알림.
              SwitchListTile(
                  title: Text(
                    "완료한 활동 알림",
                    style: optionTextStyle,
                  ),
                  subtitle: Text(
                    "완료한 활동의 알림을 받습니다",
                    style: optionSummaryTextStyle,
                  ),
                  value: notifyFinishedActivities,
                  onChanged: (value) async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(() {
                      prefs.setBool(keyNotifyFinishedActivities, value);
                      notifyFinishedActivities =
                          prefs.getBool(keyNotifyFinishedActivities)!;
                    });
                  }),
              // 구분선
              Divider(thickness: 1, height: 0.5, color: Colors.grey.shade300),

              // 알림 - 과제 알림.
              SwitchListTile(
                  title: Text(
                    "과제 알림",
                    style: optionTextStyle,
                  ),
                  subtitle: Text(
                    "과제 알람을 받습니다",
                    style: optionSummaryTextStyle,
                  ),
                  value: notifyAssignmentSwitch,
                  onChanged: (value) async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(() {
                      prefs.setBool(keyNotifyAssignment, value);
                      notifyAssignmentSwitch =
                          prefs.getBool(keyNotifyAssignment)!;
                      if (value == false) {
                        prefs.setBool(keyNotifyAssignmentBefore6Hours, false);
                        notifyAssignment6HourSwitch =
                            prefs.getBool(keyNotifyAssignmentBefore6Hours)!;
                        prefs.setBool(keyNotifyAssignmentBefore1Day, false);
                        notifyAssignment1daySwitch =
                            prefs.getBool(keyNotifyAssignmentBefore1Day)!;
                        prefs.setBool(keyNotifyAssignmentBefore3Days, false);
                        notifyAssignment3daysSwitch =
                            prefs.getBool(keyNotifyAssignmentBefore3Days)!;
                        prefs.setBool(keyNotifyAssignmentBefore5Days, false);
                        notifyAssignment5daysSwitch =
                            prefs.getBool(keyNotifyAssignmentBefore5Days)!;
                      }
                    });
                  }),
              // 구분선.
              Divider(thickness: 1, height: 0.5, color: Colors.grey.shade300),

              // 알림 - 과제 알림주기.
              ExpansionTile(
                title: Text(
                  "과제 알림주기",
                  style: optionTextStyle,
                ),
                children: [
                  // 알림 - 과제 알림주기 - 6시간 전.
                  SwitchListTile(
                      title: Text(
                        "6시간 전",
                        style: optionTextStyle,
                      ),
                      value: notifyAssignment6HourSwitch,
                      onChanged: (value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (prefs.getBool(keyNotifyAssignment)!) {
                            prefs.setBool(
                                keyNotifyAssignmentBefore6Hours, value);
                            notifyAssignment6HourSwitch =
                                prefs.getBool(keyNotifyAssignmentBefore6Hours)!;
                          }
                        });
                      }),

                  // 알림 - 과제 알림주기 - 1일 전.
                  SwitchListTile(
                      title: Text(
                        "1일 전",
                        style: optionTextStyle,
                      ),
                      value: notifyAssignment1daySwitch,
                      onChanged: (value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (prefs.getBool(keyNotifyAssignment)!) {
                            prefs.setBool(keyNotifyAssignmentBefore1Day, value);
                            notifyAssignment1daySwitch =
                                prefs.getBool(keyNotifyAssignmentBefore1Day)!;
                          }
                        });
                      }),

                  // 알림 - 과제 알림주기 - 3일 전.
                  SwitchListTile(
                      title: Text(
                        "3일 전",
                        style: optionTextStyle,
                      ),
                      value: notifyAssignment3daysSwitch,
                      onChanged: (value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (prefs.getBool(keyNotifyAssignment)!) {
                            prefs.setBool(
                                keyNotifyAssignmentBefore3Days, value);
                            notifyAssignment3daysSwitch =
                                prefs.getBool(keyNotifyAssignmentBefore3Days)!;
                          }
                        });
                      }),

                  // 알림 - 과제 알림주기 - 5일 전.
                  SwitchListTile(
                      title: Text(
                        "5일 전",
                        style: optionTextStyle,
                      ),
                      value: notifyAssignment5daysSwitch,
                      onChanged: (value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (prefs.getBool(keyNotifyAssignment)!) {
                            prefs.setBool(
                                keyNotifyAssignmentBefore5Days, value);
                            notifyAssignment5daysSwitch =
                                prefs.getBool(keyNotifyAssignmentBefore5Days)!;
                          }
                        });
                      }),
                ],
              ),
              // 구분선.
              Divider(thickness: 1, height: 0.5, color: Colors.grey.shade300),

              // 알림 - 동영상 알림.
              SwitchListTile(
                  title: Text(
                    "동영상 알림",
                    style: optionTextStyle,
                  ),
                  subtitle: Text(
                    "동영상 알림을 받습니다",
                    style: optionSummaryTextStyle,
                  ),
                  value: notifyVideo,
                  onChanged: (value) async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(() {
                      prefs.setBool(keyNotifyVideo, value);
                      notifyVideo = prefs.getBool(keyNotifyVideo)!;
                      if (value == false) {
                        prefs.setBool(keyNotifyVideoBefore6Hours, false);
                        notifyVideo6Hours =
                            prefs.getBool(keyNotifyVideoBefore6Hours)!;
                        prefs.setBool(keyNotifyVideoBefore1Day, false);
                        notifyVideo1day =
                            prefs.getBool(keyNotifyVideoBefore1Day)!;
                        prefs.setBool(keyNotifyVideoBefore3Days, false);
                        notifyVideo3days =
                            prefs.getBool(keyNotifyVideoBefore3Days)!;
                        prefs.setBool(keyNotifyVideoBefore5Days, false);
                        notifyVideo5days =
                            prefs.getBool(keyNotifyVideoBefore5Days)!;
                      }
                    });
                  }),
              // 구분선.
              Divider(thickness: 1, height: 0.5, color: Colors.grey.shade300),

              // 알림 - 동영상 알림주기.
              ExpansionTile(
                title: Text(
                  "동영상 알림주기",
                  style: optionTextStyle,
                ),
                children: [
                  // 알림 - 동영상 알림주기 - 6시간 전.
                  SwitchListTile(
                      title: Text(
                        "6시간 전",
                        style: optionTextStyle,
                      ),
                      value: notifyVideo6Hours,
                      onChanged: (value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (prefs.getBool(keyNotifyVideo)!) {
                            prefs.setBool(keyNotifyVideoBefore6Hours, value);
                            notifyVideo6Hours =
                                prefs.getBool(keyNotifyVideoBefore6Hours)!;
                          }
                        });
                      }),

                  // 알림 - 동영상 알림주기 - 1일 전.
                  SwitchListTile(
                      title: Text(
                        "1일 전",
                        style: optionTextStyle,
                      ),
                      value: notifyVideo1day,
                      onChanged: (value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (prefs.getBool(keyNotifyVideo)!) {
                            prefs.setBool(keyNotifyVideoBefore1Day, value);
                            notifyVideo1day =
                                prefs.getBool(keyNotifyVideoBefore1Day)!;
                          }
                        });
                      }),

                  // 알림 - 동영상 알림주기 - 3일 전.
                  SwitchListTile(
                      title: Text(
                        "3일 전",
                        style: optionTextStyle,
                      ),
                      value: notifyVideo3days,
                      onChanged: (value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (prefs.getBool(keyNotifyVideo)!) {
                            prefs.setBool(keyNotifyVideoBefore3Days, value);
                            notifyVideo3days =
                                prefs.getBool(keyNotifyVideoBefore3Days)!;
                          }
                        });
                      }),

                  // 알림 - 동영상 알림주기 - 5일 전.
                  SwitchListTile(
                      title: Text(
                        "5일 전",
                        style: optionTextStyle,
                      ),
                      value: notifyVideo5days,
                      onChanged: (value) async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          if (prefs.getBool(keyNotifyVideo)!) {
                            prefs.setBool(keyNotifyVideoBefore5Days, value);
                            notifyVideo5days =
                                prefs.getBool(keyNotifyVideoBefore5Days)!;
                          }
                        });
                      }),
                ],
              ),
              // 구분선.
              Divider(thickness: 1, height: 0.5, color: Colors.grey.shade300),

              // 카테고리 - 알림 - 마지막 업데이트.
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, bottom: 16, left: 16),
                      child: Text(
                        "마지막 업데이트: " + lastUpdateTime!,
                        style: optionTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 카테고리 - 사용자.
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              top: 24.0,
              bottom: 8.0,
            ),
            child: Text("사용자", style: categoryTextStyle),
          ),
          // 사용자 - 로그아웃.
          InkWell(
            onTap: () async {
              // 로그아웃 확인용 다이얼로그 표시.
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('로그아웃'),
                      content: const Text('정말로 로그아웃 하시겠습니까?'),
                      actions: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('취소'),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            // 로그아웃 시 저장된 사용자 아이디와 비밀번호 제거.
                            final prefs = await SharedPreferences.getInstance();
                            prefs.remove(keyUserId);
                            prefs.remove(keyUserPw);

                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('로그아웃'),
                          ),
                        ),
                      ],
                    );
                  });
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
                  child: Text(
                    "로그아웃",
                    style: optionTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
