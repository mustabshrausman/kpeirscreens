import 'package:flutter/material.dart';

class DisplayDataScreen extends StatelessWidget {
  final List<Map<String, dynamic>> dataList;

  const DisplayDataScreen({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Data')),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final item = dataList[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(item.toString()), // customize this as needed
            ),
          );
        },
      ),
    );
  }
}
