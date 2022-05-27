import 'package:flutter/material.dart';
import 'package:lms_reminder/widget/tabpage_finished.dart';
import 'package:lms_reminder/widget/tabpage_notfinished.dart';
import 'package:lms_reminder/widget/tabpage_notice.dart';

import '../manager/lms_manager.dart';

/// 메인 화면 위젯.
class ScreenMain extends StatefulWidget {
  final String? appBarTitle;

  const ScreenMain({Key? key, required this.appBarTitle}) : super(key: key);

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain>
    with SingleTickerProviderStateMixin {
  /// 미완료, 완료, 공지사항 탭을 위한 컨트롤러.
  TabController? tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 3, vsync: this);
    initializeData();
    tabController!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        title: Text(
          widget.appBarTitle!,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          // 설정 버튼
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/main/setting');
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: TabBarView(
        children: <Widget>[
          // 미완료 목록 탭 페이지.
          TabPageNotFinished(
            notifyParent: refresh,
          ),
          // 완료 목록 탭 페이지.
          TabPageFinished(
            notifyParent: refresh,
          ),
          // 공지사항 목록 탭 페이지.
          TabPageNotice(
            notifyParent: refresh,
          ),
        ],
        controller: tabController,
      ),
      bottomNavigationBar: Material(
        color: Colors.blue[700],
        child: ColoredBox(
          color: const Color.fromARGB(255, 183, 33, 45),
          child: SizedBox(
            height: 64.0,
            child: TabBar(
              onTap: (index) {
                setState(() {});
              },
              tabs: <Tab>[
                // 미완료 목록 탭.
                Tab(
                  icon: tabController!.index == 0
                      ? const Icon(Icons.assignment_late)
                      : const Icon(Icons.assignment_late_outlined),
                  text: tabController!.index == 0 ? null : '미완료',
                  iconMargin: const EdgeInsets.only(bottom: 4),
                ),
                // 완료 목록 탭.
                Tab(
                  icon: tabController!.index == 1
                      ? const Icon(Icons.assignment_turned_in)
                      : const Icon(Icons.assignment_turned_in_outlined),
                  text: tabController!.index == 1 ? null : '완료',
                  iconMargin: const EdgeInsets.only(bottom: 4),
                ),
                // 공지사항 목록 탭.
                Tab(
                  icon: tabController!.index == 2
                      ? const Icon(Icons.circle_notifications)
                      : const Icon(Icons.circle_notifications_outlined),
                  text: tabController!.index == 2 ? null : '공지사항',
                  iconMargin: const EdgeInsets.only(bottom: 4),
                ),
              ],
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[400],
              controller: tabController,
            ),
          ),
        ),
      ),
    );
  }

  /// 데이터 초기화.
  Future initializeData() async {
    await LmsManager().reloadAllDataFromLms();
    refresh();
  }

  /// 위젯 갱신.
  refresh() {
    setState(() {});
  }
}
