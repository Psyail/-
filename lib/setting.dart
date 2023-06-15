import 'package:bucket_list_with_firebase/auth_service.dart';
import 'package:bucket_list_with_firebase/help_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
        backgroundColor: Color.fromARGB(255, 35, 23, 205),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.info),
            title: Text(
              '공지사항',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Notice()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text(
              '도움말',
              style: TextStyle(
                fontSize: 18.0,
                // fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              '로그아웃',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('로그아웃'),
                    content: Text('정말 로그아웃 하시겠습니까?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('로그아웃'),
                        onPressed: () {
                          context.read<AuthService>().signOut();

                          //로그인 페이지로 이동
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                      ),
                      TextButton(
                        child: Text('취소'),
                        onPressed: () {
                          Navigator.of(context).pop(); //다이얼로그 담기
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
