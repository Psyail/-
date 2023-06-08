//캘린더 페이지I
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'bucket_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _bucketCount = 0;
  int _completedBucketCount = 0;
/*  BucketService _bucketService = BucketService();

  @override
  void initState() {
    super.initState();
    _updateBucketListCounts(_focusedDay);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('캘린더'),
      ),
      body: Column(
        children: [
          _buildCalendar(),
          _buildBucketListInfo(),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      calendarFormat: _calendarFormat,
      focusedDay: _focusedDay,
      firstDay: DateTime(2000),
      lastDay: DateTime(2050),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          _loadBucketListByDate(selectedDay);
        });
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
    );
  }

  void _loadBucketListByDate(DateTime selectedDate) async {
    final bucketService = BucketService();

    List<Map<String, dynamic>> bucketList =
        await bucketService.getBucketListByDate(selectedDate);

    setState(() {
      _bucketCount = bucketList.length;
      _completedBucketCount =
          bucketList.where((bucket) => bucket['isDone'] == true).length;
    });
  }

  Widget _buildBucketListInfo() {
    return Expanded(
      child: Column(
        children: [
          Text('버킷리스트 수: $_bucketCount'),
          Text('완료된 버킷리스트 수: $_completedBucketCount'),
        ],
      ),
    );
  }
}
