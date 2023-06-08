import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('도움말'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            '앱 도움말',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            '앱 도움말 표기함',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(
            height: 16.0,
          ),
          Text('추가내용'),
          Text('추가내용2'),
        ],
      ),
      /*  floatingActionButton: FloatingActionButton(
        onPressed: () {
          //도움말 페이지 닫기
          Navigator.pop(context);
        },
        // child: Icon(Icons.close),
      ),*/
    );
  }
}
