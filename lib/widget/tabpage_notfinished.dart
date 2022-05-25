import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:intl/intl.dart';
import 'package:lms_reminder/manager/lms_manager.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../manager/dio_manager.dart';
import '../manager/lms_manager.dart';
import '../model/assignment.dart';
import '../model/video.dart';

class TabPageNotFinished extends StatefulWidget {
  final Function() notifyParent;

  const TabPageNotFinished({Key? key, required this.notifyParent})
      : super(key: key);

  @override
  State createState() {
    return _TabPageNotFinished();
  }
}

class _TabPageNotFinished extends State<TabPageNotFinished> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: LmsManager().getNotFinishedList(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Shimmer.fromColors(
                                              // 과목명[주차]
                                              baseColor: Colors.grey.shade400,
                                              highlightColor:
                                                  Colors.grey.shade300,
                                              child: Container(
                                                height: 24,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Shimmer.fromColors(
                                            // 과제, 동영상 아이콘
                                            baseColor: Colors.grey.shade400,
                                            highlightColor:
                                                Colors.grey.shade300,
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0, right: 8.0),
                                              child: Shimmer.fromColors(
                                                // 과제, 동영상 제목
                                                baseColor: Colors.grey.shade400,
                                                highlightColor:
                                                    Colors.grey.shade300,
                                                child: Container(
                                                  height: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Shimmer.fromColors(
                                // 남은시간 영역
                                baseColor: Colors.grey.shade400,
                                highlightColor: Colors.grey.shade300,
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(64),
                                    ),
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              List<dynamic> todoList = (snapshot.data as List<dynamic>);
              if (todoList.isEmpty) {
                return const Text('할일이 없습니다!');
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshAllData,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: todoList.length,
                          itemBuilder: (context, index) {
                            String? courseTitle;
                            String? week;
                            String? activityTitle;
                            Image? activityImage;
                            DateTime? deadLine;
                            String? strDeadLine;
                            String? leftTime;
                            Color? leftTimeCircleColor;
                            bool? state;
                            String? content;

                            if (todoList.elementAt(index).runtimeType ==
                                Assignment) {
                              Assignment assignment =
                                  todoList.elementAt(index) as Assignment;
                              courseTitle = assignment.lecture.course.title;
                              week = assignment.lecture.week;
                              activityTitle = assignment.title;
                              activityImage = const Image(
                                image: AssetImage(
                                    'resource/image/icon_assignment.png'),
                                width: 24,
                                height: 24,
                                fit: BoxFit.fill,
                              );
                              deadLine = assignment.deadLine;
                              strDeadLine = DateFormat('yyyy년 MM월 dd일 HH시 mm분')
                                  .format(assignment.deadLine);
                              leftTime = assignment.getLeftTime();
                              content = assignment.content;
                              state = assignment.submit;
                            } else {
                              Video video = todoList.elementAt(index) as Video;
                              courseTitle = video.lecture.course.title;
                              week = video.lecture.week;
                              activityTitle = video.title;
                              activityImage = const Image(
                                image:
                                    AssetImage('resource/image/icon_video.png'),
                                width: 24,
                                height: 24,
                                fit: BoxFit.fill,
                              );
                              deadLine = video.deadLine;
                              strDeadLine = DateFormat('yyyy년 MM월 dd일 HH시 mm분')
                                  .format(video.deadLine);
                              leftTime = video.getLeftTime();
                              state = video.watch;
                            }

                            if (leftTime == '마감') {
                              leftTimeCircleColor = Colors.grey;
                            } else if (leftTime == 'D-1' ||
                                !leftTime.contains('D')) {
                              leftTimeCircleColor = Colors.redAccent;
                            } else {
                              leftTimeCircleColor = Colors.lightBlueAccent;
                            }

                            return Card(
                              child: InkWell(
                                onTap: () {
                                  AwesomeDialog(
                                      context: context,
                                      headerAnimationLoop: false,
                                      body: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              courseTitle!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                              ),
                                            ),
                                            Text(
                                              activityTitle!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  top: 14),
                                              child: Visibility(
                                                child: Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                      EdgeInsets.only(
                                                          right: 8.0),
                                                      child: Icon(
                                                        Icons.timer,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    SlideCountdownSeparated(
                                                      duration: deadLine!
                                                          .difference(
                                                          DateTime
                                                              .now()),
                                                    ),
                                                  ],
                                                ),
                                                visible: deadLine!.isAfter(
                                                    DateTime.now()),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                top: 14,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                  Text(
                                                    '주차: ' + week!,
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    '마감일: ' + strDeadLine!,
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (content != null)
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    top: 8.0,
                                                    left: 8.0,
                                                    right: 8.0),
                                                child: Html(
                                                  data: content,
                                                  onLinkTap: (String? url,
                                                      RenderContext
                                                      renderContext,
                                                      Map<String, String>
                                                      attributes,
                                                      html_dom.Element?
                                                      element) async {
                                                    await Permission.storage
                                                        .request();

                                                    if (await Permission
                                                        .storage.isDenied) {
                                                      ScaffoldMessenger.of(
                                                          context)
                                                          .showSnackBar(
                                                          SnackBar(
                                                            content: const Text(
                                                                '저장소 접근 권한이 필요합니다'),
                                                            duration:
                                                            const Duration(
                                                                seconds: 3),
                                                            action:
                                                            SnackBarAction(
                                                                label: '설정',
                                                                onPressed:
                                                                    () {
                                                                  openAppSettings();
                                                                }),
                                                          ));
                                                      return;
                                                    }

                                                    if ((await DeviceInfoPlugin()
                                                        .androidInfo)
                                                        .version
                                                        .sdkInt! >=
                                                        30) {
                                                      await Permission
                                                          .manageExternalStorage
                                                          .request();

                                                      if (await Permission
                                                          .manageExternalStorage
                                                          .isDenied) {
                                                        showSnackBar(
                                                            '저장소 관리 권한이 필요합니다',
                                                            3,
                                                            actionText:
                                                            '설정',
                                                            onPressed: () {
                                                              openAppSettings();
                                                            });
                                                        return;
                                                      }
                                                    }

                                                    String decodeUrl =
                                                    Uri.decodeComponent(
                                                        url!);
                                                    String fileName =
                                                    decodeUrl.substring(
                                                        decodeUrl.indexOf(
                                                            '/0/') +
                                                            3,
                                                        decodeUrl.indexOf(
                                                            '?forcedownload'));
                                                    String fileExtension =
                                                    fileName.substring(
                                                        fileName
                                                            .lastIndexOf(
                                                            '.'));
                                                    fileName =
                                                        fileName.substring(
                                                            0,
                                                            fileName
                                                                .lastIndexOf(
                                                                '.'));

                                                    File file = File(
                                                        '/storage/emulated/0/Download/' +
                                                            fileName +
                                                            fileExtension);

                                                    int loop = 1;
                                                    String filePath =
                                                        '/storage/emulated/0/Download/' +
                                                            fileName +
                                                            fileExtension;

                                                    String finalFileName =
                                                        fileName +
                                                            fileExtension;
                                                    while (
                                                    file.existsSync()) {
                                                      finalFileName =
                                                          fileName +
                                                              '(' +
                                                              loop.toString() +
                                                              ')' +
                                                              fileExtension;
                                                      filePath =
                                                          '/storage/emulated/0/Download/' +
                                                              finalFileName;
                                                      file = File(filePath);
                                                      loop++;
                                                    }

                                                    showSnackBar(
                                                        "'" +
                                                            finalFileName +
                                                            "' 다운로드 시작",
                                                        1);

                                                    DioManager()
                                                        .httpGetFile(
                                                        url!, file, () {
                                                      if (!file
                                                          .existsSync()) {
                                                        showSnackBar(
                                                            "'" +
                                                                finalFileName +
                                                                "' 다운로드 실패",
                                                            2);
                                                        return;
                                                      }

                                                      showSnackBar(
                                                          "'" +
                                                              finalFileName +
                                                              "' 다운로드 완료",
                                                          3,
                                                          actionText: '열기',
                                                          onPressed:
                                                              () async {
                                                            if ((await OpenFile
                                                                .open(file
                                                                .path))
                                                                .type ==
                                                                ResultType
                                                                    .noAppToOpen) {
                                                              // 해당 파일을 실행할 수 있는 앱이 없을 경우
                                                              showSnackBar(
                                                                  '파일을 열 수 있는 앱이 없습니다',
                                                                  2,
                                                                  actionText:
                                                                  '검색',
                                                                  onPressed:
                                                                      () async {
                                                                    String
                                                                    playStoreUrl =
                                                                        'https://play.google.com/store/search?q=open ' +
                                                                            fileExtension.replaceAll(
                                                                                '.',
                                                                                '') +
                                                                            '&c=apps';
                                                                    await launchUrl(
                                                                        Uri.parse(
                                                                            playStoreUrl));
                                                                  });
                                                            }
                                                          });
                                                    });
                                                  },
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                      dialogType: state!
                                          ? DialogType.SUCCES
                                          : DialogType.ERROR,
                                      animType: AnimType.SCALE,
                                      btnOkText: '확인',
                                      btnOkOnPress: () {})
                                      .show();
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        courseTitle,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      Text(
                                                        " [" + week + "]",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 8.0),
                                                    child: Row(
                                                      children: [
                                                        activityImage,
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 4),
                                                          child: Text(
                                                            activityTitle,
                                                            style:
                                                            const TextStyle(
                                                                fontSize:
                                                                12),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: leftTimeCircleColor,
                                                borderRadius:
                                                const BorderRadius.all(
                                                  Radius.circular(64),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 1,
                                                    blurRadius: 4,
                                                    offset: const Offset(4, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  leftTime,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                              ),
                                              width: 64,
                                              height: 64,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }

  Future<void> _refreshAllData() async {
    await LmsManager().refreshAllData();
    widget.notifyParent();
  }

  void showSnackBar(String text, int second,
      {String? actionText, Function()? onPressed}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(text),
          duration: Duration(seconds: second),
          action: (actionText != null && onPressed != null)
              ? SnackBarAction(
            label: actionText,
            onPressed: onPressed,
          )
              : null),
    );
  }
}
