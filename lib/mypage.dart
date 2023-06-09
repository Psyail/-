import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  final BuildContext context;
  final int totalBucketCount;
  final int completedBucketCount;
  final String profileImage;
  final String username;

  MyPage({
    required this.context,
    required this.totalBucketCount,
    required this.completedBucketCount,
    required this.profileImage,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보'),
        backgroundColor: Color.fromARGB(255, 35, 23, 205),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(profileImage),
            ),
            SizedBox(height: 20),
            Text(
              '사용자 이름: $username',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '총 버킷리스트 수: $totalBucketCount',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '완료한 버킷리스트 수: $completedBucketCount',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
