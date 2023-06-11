//homepage.dart
import 'package:bucket_list_with_firebase/calendar_page.dart';
//import 'package:bucket_list_with_firebase/mypage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'setting.dart';
import 'auth_service.dart';
import 'bucket_service.dart';

//import 'calendar_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController jobController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String userName = "사용자";

  @override
  void initState() {
    super.initState();
    // 프로필 이름 초기화
    nameController.text = userName;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BucketService>(
      builder: (context, bucketService, child) {
        final authService = context.read<AuthService>();
        User user = authService.currentUser()!;
        return Scaffold(
          appBar: AppBar(
            title: Text("$userName 님의 버킷리스트"),
            backgroundColor: Color.fromARGB(255, 35, 23, 205),
            centerTitle: true,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  accountName: Text(
                    '$userName 님',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  accountEmail: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          String newName = userName;
                          return AlertDialog(
                            title: Text('프로필 변경'),
                            content: TextField(
                              onChanged: (value) {
                                newName = value;
                              },
                              controller: TextEditingController(
                                text: userName,
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text('수정'),
                                onPressed: () {
                                  setState(() {
                                    userName = newName;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: Text('취소'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      '프로필 변경',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 30, color: Colors.blue),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text('캘린더'),
                  onTap: () {
                    Navigator.pop(context); // 메뉴 닫기
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CalendarPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('설정'),
                  onTap: () {
                    Navigator.pop(context); // 메뉴 닫기
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: jobController,
                        decoration: InputDecoration(
                          hintText: "버킷 리스트를 입력해주세요.",
                          hintStyle: TextStyle(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        if (jobController.text.isNotEmpty) {
                          bucketService.create(jobController.text, user.uid);
                          jobController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 18, 11, 138),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              Expanded(
                child: FutureBuilder<QuerySnapshot>(
                  future: bucketService.read(user.uid),
                  builder: (context, snapshot) {
                    final documents = snapshot.data?.docs ?? [];
                    if (documents.isEmpty) {
                      return Center(child: Text("버킷 리스트를 작성해 주세요."));
                    }
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final doc = documents[index];
                        String docId = doc.id;
                        String job = doc.get("job");
                        bool isDone = doc.get("isDone");
                        return ListTile(
                          title: Text(
                            job,
                            style: TextStyle(
                              fontSize: 24,
                              color: isDone ? Colors.grey : Colors.black,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String newJob = job;
                                      return AlertDialog(
                                        title: Text('버킷 리스트 수정'),
                                        content: TextField(
                                          onChanged: (value) {
                                            newJob = value;
                                          },
                                          controller: TextEditingController(
                                            text: job,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text('수정'),
                                            onPressed: () {
                                              bucketService.update(
                                                  docId, newJob);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text('취소'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('버킷 리스트 삭제'),
                                        content: Text('정말로 삭제하시겠습니까?'),
                                        actions: [
                                          TextButton(
                                            child: Text('삭제'),
                                            onPressed: () {
                                              bucketService.delete(docId);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text('취소'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                          onTap: () {
                            bucketService.toggleCompletion(docId, !isDone);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
