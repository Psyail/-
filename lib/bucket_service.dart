import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BucketService extends ChangeNotifier {
  final bucketCollection = FirebaseFirestore.instance.collection('bucket');

/*  Future<List<Map<String, dynamic>>> readByDate(DateTime selectedDate) async {
    // 선택한 날짜에 해당하는 버킷리스트 정보 가져오기
    QuerySnapshot snapshot =
        await bucketCollection.where('date', isEqualTo: selectedDate).get();
    List<Map<String, dynamic>> bucketList = snapshot.docs
        .map((DocumentSnapshot document) =>
            document.data() as Map<String, dynamic>)
        .toList();
    return bucketList;
  }*/

  Future<List<Map<String, dynamic>>> getBucketListByDate(
      DateTime selectedDate) async {
    QuerySnapshot snapshot =
        await bucketCollection.where('date', isEqualTo: selectedDate).get();

    List<Map<String, dynamic>> bucketList = snapshot.docs
        .map((DocumentSnapshot document) =>
            document.data() as Map<String, dynamic>)
        .toList();
    return bucketList;
  }

  Future<QuerySnapshot> read(String uid) async {
    // 내 bucketList 가져오기
    return bucketCollection.where('uid', isEqualTo: uid).get();
  }

  // mypage와 연동
  Future<int> getTotalBucketCount(String uid) async {
    // 총 버킷리스트 개수 가져오기
    QuerySnapshot snapshot =
        await bucketCollection.where('uid', isEqualTo: uid).get();
    return snapshot.docs.length;
  }

  Future<int> getCompletedBucketCount(String uid) async {
    QuerySnapshot snapshot = await bucketCollection
        .where('uid', isEqualTo: uid)
        .where('isDone', isEqualTo: true)
        .get();
    return snapshot.docs.length;
  }

//여기부터 추가내용( 캘린더 탭과 홈 연계 ) -> 잘 안되서 일단 주석처리
  /* Future<int> getBucketListCountByDate(DateTime selectedDate) async {
    QuerySnapshot snapshot =
        await bucketCollection.where('date', isEqualTo: selectedDate).get();
    return snapshot.docs.length;
  }

  Future<int> getCompletedBucketListCountByDate(DateTime selectedDate) async {
    QuerySnapshot snapshot = await bucketCollection
        .where('date', isEqualTo: selectedDate)
        .where('isDone', isEqualTo: true)
        .get();
    return snapshot.docs.length;
  }*/

  void create(String job, String uid) async {
    await bucketCollection.add({
      'uid': uid, // 유저 식별자
      'job': job, // 하고싶은 일
      'isDone': false, // 완료 여부
    });
    notifyListeners(); // 화면 갱신
    // bucket 만들기
  }

  void update(String docId, String newJob) async {
    // bucket isDone 업데이트
    await bucketCollection.doc(docId).update({"job": newJob});
    notifyListeners();
  }

  void toggleCompletion(String docId, bool isDone) async {
    await bucketCollection.doc(docId).update({'isDone': isDone});
    notifyListeners();
  }

  void delete(String docId) async {
    // bucket 삭제
    bucketCollection.doc(docId).delete();
    notifyListeners();
  }
}
