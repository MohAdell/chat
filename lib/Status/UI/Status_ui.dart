import 'package:flutter/material.dart';

class StatusUi extends StatefulWidget {
  const StatusUi({super.key});

  @override
  State<StatusUi> createState() => _StatusUiState();
}

class _StatusUiState extends State<StatusUi> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(right: 280, top: 50),
      alignment: Alignment.topRight,
      child: ListView(
        // padding: EdgeInsets.all(20),
        scrollDirection: Axis.vertical,
        children: [
          buildStatusItem('My Status', '05:00 AM'),
          buildStatusItem('Mohamed', '05:17 AM'),
          buildStatusItem('Marina', '08:22 AM'),
          buildStatusItem('Ibrahim', '01:55 AM'),
          buildStatusItem('Ahmed', '02:40 AM'),
          buildStatusItem('Ahmed', '02:40 AM'),
          buildStatusItem('Ahmed', '02:40 AM'),
          buildStatusItem('Ahmed', '02:40 AM'),
          buildStatusItem('Ahmed', '02:40 AM'),
          buildStatusItem('Mohamed', '05:17 AM'),
          buildStatusItem('Mohamed', '05:17 AM'),
          buildStatusItem('Mohamed', '05:17 AM'),
          buildStatusItem('Mohamed', '05:17 AM'),
        ],
      ),
    );
  }

  Widget buildStatusItem(String name, String Time) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.yellowAccent,
            child: Image.asset('assets/user-avatar.png'),
          ),
          const SizedBox(width: 20),
          Column(
            children: [
              Text(name),
              Text(Time),
            ],
          )
          // ListTile(
          //   title: Text(name),
          //   subtitle: Text(Time),
          // ),
        ],
      ),
    );
  }
}
