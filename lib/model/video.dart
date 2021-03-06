import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;
import 'package:lms_reminder/model/activity.dart';

import 'week.dart';

/// 동영상 클래스.
class Video extends Activity {
  /// 출석인정 요구시간.
  String? _requiredWatchTime;

  /// 동영상 길이.
  String? _videoLength;

  /// 총 시청시간.
  String? _totalWatchTime;

  /// 활성화 시간.
  DateTime? _enableTime;

  /// 전달된 html에서 동영상 목록을 추출하여 반환하는 함수.
  static List<List<Video>> parseVideoListFromHtml(String html) {
    List<List<Video>> courseVideoList = List.empty(growable: true);

    html_dom.Document document = html_parser.parse(html);

    int maxRowCount = 0;
    int currentRowCount = 0;

    List<Video>? weekVideoList;
    document
        .getElementById('ubcompletion-progress-wrapper')!
        .getElementsByTagName('div')[1]
        .getElementsByClassName('table  table-bordered user_progress_table')[0]
        .getElementsByTagName('tbody')[0]
        .getElementsByTagName('tr')
        .forEach((element) {
      List<html_dom.Element> tdList = element.getElementsByTagName('td');

      if (tdList.length == 5) {
        if (element.innerHtml.contains('rowspan')) {
          weekVideoList = List.empty(growable: true);
          currentRowCount = 1;
          maxRowCount = int.parse(element.innerHtml.substring(
              element.innerHtml.indexOf('rowspan="') + 9,
              element.innerHtml.indexOf('">')));

          Video video = Video();
          video.title = tdList[1].text.trim();
          video.requiredWatchTime = tdList[2].text.trim();
          video.done = tdList[4].text.contains('O');
          if (tdList[3].text.contains('-')) {
            video.totalWatchTime = '미시청';
          } else {
            video.totalWatchTime = tdList[3]
                .innerHtml
                .substring(0, tdList[3].innerHtml.indexOf('<'))
                .trim();
          }

          weekVideoList!.add(video);

          if (currentRowCount == maxRowCount) {
            courseVideoList.add(weekVideoList!);
          }
        } else {
          courseVideoList.add(List.empty());
        }
      } else {
        Video video = Video();
        video.title = tdList[0].text.trim();
        video.requiredWatchTime = tdList[1].text.trim();
        video.done = tdList[3].text.contains('O');
        if (tdList[2].text.contains('-')) {
          video.totalWatchTime = '미시청';
        } else {
          video.totalWatchTime = tdList[2]
              .innerHtml
              .substring(0, tdList[2].innerHtml.indexOf('<'))
              .trim();
        }

        weekVideoList!.add(video);

        currentRowCount++;

        if (currentRowCount == maxRowCount) {
          courseVideoList.add(weekVideoList!);
        }
      }
    });

    return courseVideoList;
  }

  /// Video 생성자.
  Video({Week? week}) : super('video') {
    if (week != null) {
      this.week = week;
    }
  }

  String get requiredWatchTime => _requiredWatchTime!;

  String get totalWatchTime => _totalWatchTime!;

  set totalWatchTime(String value) {
    _totalWatchTime = value;
  }

  set requiredWatchTime(String value) {
    _requiredWatchTime = value;
  }

  DateTime get enableTime => _enableTime!;

  set enableTime(DateTime value) {
    _enableTime = value;
  }

  String get videoLength => _videoLength!;

  set videoLength(String value) {
    _videoLength = value;
  }
}
