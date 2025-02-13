import 'package:flutter/scheduler.dart';
import 'dart:async';
class GameService {
  // 게임 시간 관련 변수
  int gameHours = 0; // 게임 시간의 시
  int gameMinutes = 0; // 게임 시간의 분
  Ticker? _ticker;
  int frame = 0; // 경과 시간
  // gameMinutes를 감지하기 위한 StreamController
  final StreamController<void> _gameMinutesController = StreamController.broadcast();
  Stream<void> get gameMinutesStream => _gameMinutesController.stream;
  GameService() {
    // 게임 시간을 업데이트하는 타이머 시작
    _startGlobalTime();
  }

  void _startGlobalTime() {
    _ticker = Ticker((Duration elapsed) {
      frame += 1; // 경과 시간 업데이트
      if (frame >= 120) { // 1초가 경과했는지 체크
        frame = 0; // 경과 시간 초기화
        //
        _updateGameTime();
      }
    });
    _ticker!.start();
  }

  void _updateGameTime() {
    gameMinutes++;
    _gameMinutesController.add(null);
    if (gameMinutes >= 60) {
      gameMinutes = 0;
      gameHours++;
      if (gameHours >= 24) {
        gameHours = 0; // 24시간이 지나면 다시 0으로 초기화
      }
    }
  }

  String getFormattedGameTime() {
    // 게임 시간을 "HH:MM" 형식으로 반환
    return '${gameHours.toString().padLeft(2, '0')}:${gameMinutes.toString().padLeft(2, '0')}';
  }

  void dispose() {
    // Ticker 종료
    _ticker?.dispose();
  }
}
