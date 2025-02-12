import 'package:flutter/material.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clicker Hero'),
        backgroundColor: Colors.brown[900], // 어두운 갈색으로 앱바 색상 변경
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // 모서리 둥글게
              side: BorderSide(color: Colors.black54, width: 2), // 테두리 추가
            ),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // 패딩 조정
            elevation: 8, // 그림자 효과
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GameScreen()),
            );
          },
          child: Text(
            '게임 시작',
            style: TextStyle(
              fontSize: 20, // 텍스트 크기
              fontWeight: FontWeight.bold, // 텍스트 두께
            ),
          ),
        ),
      ),
    );
  }
}
