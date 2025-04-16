import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'sqauare_progress_indicator.dart';

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
  int totalItems = 0;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _startDownload();

    // Initialize Animation Controller for the entire process
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 10), // Adjust the duration as needed
    // )..addListener(() {
    //     setState(() {
    //       progress = _controller.value;
    //     });
    //   });
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: false);
  }

  Future<void> _startDownload() async {
    final dio = Dio();
    int pageNumber = 1;
    int pageSize = 50; // Adjust this to API's page size
    bool hasMoreData = true;
    List<dynamic> allResults = [];

    try {
      while (hasMoreData) {
        final String url =
            'http://4.231.253.183:90/api/ChildRegistration/get-registration-by-user-uid-paginated?uid=144e8cec-09e7-11ee-aee0-0242ac1d0002&pageNumber=$pageNumber&pageSize=$pageSize';

        print("🌐 Fetching page: $pageNumber");

        final response = await dio.get(url);

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
            print("⚠️ Unexpected format on page $pageNumber: $result");
            hasMoreData = false;
            break;
          }

          if (pageList.isEmpty) {
            print("🛑 No more data at page: $pageNumber");
            hasMoreData = false;
          } else {
            allResults.addAll(pageList);
            print("📦 Page $pageNumber downloaded, items: ${pageList.length}");

            // Safely access totalPages and fallback to 0 if null

            print(
                "..........................................................................${pageList.length}");
            0; // Handle null by defaulting to 0

            if (pageNumber >= pageList.length) {
              hasMoreData = false;
              print("🛑 No more pages left to fetch.");
            } else {
              pageNumber++; // Move to next page
            }
          }

          // Update progress bar
          setState(() {
            print(".........................................................");
            progress =
                (pageNumber / pageList.length); // adjust if total unknown
            if (progress > 1.0) progress = 1.0;
          });
        } else {
          print("❌ Invalid response at page $pageNumber");
          hasMoreData = false;
        }
      }

      print("✅ Total downloaded items: ${allResults.length}");

      setState(() {
        resultList = allResults;
        totalItems = resultList.length;
        isDownloading = false;
        _controller.forward();
      });
    } catch (e) {
      setState(() {
        errorMessage = "Download failed: ${e.toString()}";
        isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentText = '${(progress * 100).toStringAsFixed(0)}%';

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
                          // Outer pulsing wave
                          Container(
                            width: 220 + (_controller.value * 60),
                            height: 320 + (_controller.value * 60),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(
                                  30 + (_controller.value * 20)),
                              color: Colors.purple
                                  .withOpacity(0.2 * (1 - _controller.value)),
                            ),
                          ),
                          // Inner glowing container with actual progress
                          Container(
                            width: 220,
                            height: 320,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple
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
                              color: Colors.purple,
                              emptyStrokeColor: Colors.purple.withOpacity(.5),
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
                  // Text(
                  //   percentText,
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black,
                  //   ),
                  // )
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
                          final uid = item['uid']?.toString() ?? 'No name';
                          final fullname =
                              item['fullName']?.toString() ?? 'Unknown';
                          final epinumber =
                              item['epiNumber']?.toString() ?? 'Unknown';

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(uid),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Father: $fullname"),
                                  Text("Mother: $epinumber"),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
