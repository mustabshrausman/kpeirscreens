import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'sqauare_progress_indicator.dart';
import 'controller/SQLHelper.dart';

class DownloadScreen extends StatefulWidget {
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen>
    with TickerProviderStateMixin {
  double progress = 0.0;
  bool isDownloading = true;
  String errorMessage = '';
  List<dynamic> resultList = [];

  late AnimationController _controller;

  final int totalPages = 50;
  final int pageSize = 50;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: false);

    _startDownload();
  }

  Future<void> _startDownload() async {
    final dio = Dio();
    List<dynamic> allResults = [];

    try {
      for (int pageNumber = 1; pageNumber <= totalPages; pageNumber++) {
        final String url =
            'http://4.231.253.183:90/api/ChildRegistration/get-registration-by-user-uid-paginated?uid=144e8cec-09e7-11ee-aee0-0242ac1d0002&pageNumber=$pageNumber&pageSize=$pageSize';

        final response = await dio.get(url);
        print("🌐 Fetching page: $pageNumber");

        if (response.statusCode == 200 &&
            response.data != null &&
            response.data['result'] != null) {
          var result = response.data['result'];
          List<dynamic> pageList = [];

          if (result is List) {
            pageList = result;
          } else if (result is Map<String, dynamic> &&
              result.containsKey('items')) {
            pageList = result['items'] as List;
          } else {
            print(" Unexpected format on page $pageNumber: $result");
            continue;
          }

          for (var item in pageList) {
            final fullname = item['fullName']?.toString() ?? 'Unknown';
            final age = item['age']?.toString() ?? 'Unknown';
            final gender = item['gender']?.toString() ?? 'Unknown';

            await SQLHelper.save(fullname, age, gender);

            allResults.add({
              'fullName': fullname,
              'age': age,
              'gender': gender,
            });
          }

          //  Progress update based on page count
          setState(() {
            progress = pageNumber / totalPages;
          });
        } else {
          print(" Error in response at page $pageNumber");
        }
      }

      print("All pages done. Total items: ${allResults.length}");

      setState(() {
        resultList = allResults;
        isDownloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Download Complete! ${allResults.length} records saved'),
        ),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Download failed: ${e.toString()}";
        isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Download Progress")),
      body: Center(
        child: isDownloading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 220 + (_controller.value * 60),
                            height: 320 + (_controller.value * 60),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(
                                  30 + (_controller.value * 20)),
                              color: Colors.grey
                                  .withOpacity(0.2 * (1 - _controller.value)),
                            ),
                          ),
                          Container(
                            width: 220,
                            height: 320,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(progress.clamp(0.3, 0.9)),
                                  blurRadius: 40 * progress,
                                  spreadRadius: 20 * progress,
                                ),
                              ],
                            ),
                            child: SquareProgressIndicator(
                              value: progress,
                              width: 200,
                              height: 300,
                              borderRadius: 20,
                              startPosition: StartPosition.topLeft,
                              strokeCap: StrokeCap.square,
                              clockwise: true,
                              color: Colors.grey,
                              emptyStrokeColor: Colors.grey.withOpacity(.5),
                              strokeWidth: 10,
                              emptyStrokeWidth: 10,
                              strokeAlign: SquareStrokeAlign.center,
                              child: Text(
                                "${(progress * 100).toStringAsFixed(0)}%",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
              )
            : errorMessage.isNotEmpty
                ? Text(errorMessage, style: TextStyle(color: Colors.red))
                : resultList.isEmpty
                    ? Text("No data available",
                        style: TextStyle(color: Colors.grey))
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: resultList.length,
                        itemBuilder: (context, index) {
                          final item = resultList[index];
                          final name = item['fullName'];
                          final age = item['age'];
                          final gender = item['gender'];

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(name),
                              subtitle: Text("Age: $age | Gender: $gender"),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
