// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'sqauare_progress_indicator.dart';
// import 'controller/SQLHelper.dart';
//
// class DownloadScreen extends StatefulWidget {
//   @override
//   _DownloadScreenState createState() => _DownloadScreenState();
// }
//
// class _DownloadScreenState extends State<DownloadScreen>
//     with TickerProviderStateMixin {
//   double progress = 0.0;
//   bool isDownloading = true;
//   String errorMessage = '';
//   List<dynamic> resultList = [];
//
//   late AnimationController _controller;
//
//   final int totalPages = 50;
//   final int pageSize = 50;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     )..repeat(reverse: false);
//
//     _startDownload();
//   }
//
//   Future<void> _startDownload() async {
//     final dio = Dio();
//     List<dynamic> allResults = [];
//
//     try {
//       for (int pageNumber = 1; pageNumber <= totalPages; pageNumber++) {
//         final String url =
//             'http://4.231.253.183:90/api/ChildRegistration/get-registration-by-user-uid-paginated?uid=144e8cec-09e7-11ee-aee0-0242ac1d0002&pageNumber=$pageNumber&pageSize=$pageSize';
//
//         final response = await dio.get(url);
//         print("🌐 Fetching page: $pageNumber");
//
//         if (response.statusCode == 200 &&
//             response.data != null &&
//             response.data['result'] != null) {
//           var result = response.data['result'];
//           List<dynamic> pageList = [];
//
//           if (result is List) {
//             pageList = result;
//           } else if (result is Map<String, dynamic> &&
//               result.containsKey('items')) {
//             pageList = result['items'] as List;
//           } else {
//             print(" Unexpected format on page $pageNumber: $result");
//             continue;
//           }
//
//           for (var item in pageList) {
//             final fullname = item['fullName']?.toString() ?? 'Unknown';
//             final age = item['age']?.toString() ?? 'Unknown';
//             final gender = item['gender']?.toString() ?? 'Unknown';
//
//             await SQLHelper.save(fullname, age, gender);
//
//             allResults.add({
//               'fullName': fullname,
//               'age': age,
//               'gender': gender,
//             });
//           }
//
//           //  Progress update based on page count
//           setState(() {
//             progress = pageNumber / totalPages;
//           });
//         } else {
//           print(" Error in response at page $pageNumber");
//         }
//       }
//
//       print("All pages done. Total items: ${allResults.length}");
//
//       setState(() {
//         resultList = allResults;
//         isDownloading = false;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content:
//               Text('Download Complete! ${allResults.length} records saved'),
//         ),
//       );
//     } catch (e) {
//       setState(() {
//         errorMessage = "Download failed: ${e.toString()}";
//         isDownloading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Download Progress")),
//       body: Center(
//         child: isDownloading
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   AnimatedBuilder(
//                     animation: _controller,
//                     builder: (context, child) {
//                       return Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Container(
//                             width: 220 + (_controller.value * 60),
//                             height: 320 + (_controller.value * 60),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.rectangle,
//                               borderRadius: BorderRadius.circular(
//                                   30 + (_controller.value * 20)),
//                               color: Colors.grey
//                                   .withOpacity(0.2 * (1 - _controller.value)),
//                             ),
//                           ),
//                           Container(
//                             width: 220,
//                             height: 320,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey
//                                       .withOpacity(progress.clamp(0.3, 0.9)),
//                                   blurRadius: 40 * progress,
//                                   spreadRadius: 20 * progress,
//                                 ),
//                               ],
//                             ),
//                             child: SquareProgressIndicator(
//                               value: progress,
//                               width: 200,
//                               height: 300,
//                               borderRadius: 20,
//                               startPosition: StartPosition.topLeft,
//                               strokeCap: StrokeCap.square,
//                               clockwise: true,
//                               color: Colors.grey,
//                               emptyStrokeColor: Colors.grey.withOpacity(.5),
//                               strokeWidth: 10,
//                               emptyStrokeWidth: 10,
//                               strokeAlign: SquareStrokeAlign.center,
//                               child: Text(
//                                 "${(progress * 100).toStringAsFixed(0)}%",
//                                 style: TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               )
//             : errorMessage.isNotEmpty
//                 ? Text(errorMessage, style: TextStyle(color: Colors.red))
//                 : resultList.isEmpty
//                     ? Text("No data available",
//                         style: TextStyle(color: Colors.grey))
//                     : ListView.builder(
//                         padding: EdgeInsets.all(16),
//                         itemCount: resultList.length,
//                         itemBuilder: (context, index) {
//                           final item = resultList[index];
//                           final name = item['fullName'];
//                           final age = item['age'];
//                           final gender = item['gender'];
//
//                           return Card(
//                             margin: EdgeInsets.symmetric(vertical: 4),
//                             child: ListTile(
//                               title: Text(name),
//                               subtitle: Text("Age: $age | Gender: $gender"),
//                             ),
//                           );
//                         },
//                       ),
//       ),
//     );
//   }
// }
////////////////////////////////////////////////////////////////////////////////////////

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
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

  late AnimationController _glowController;

  final int totalPages = 50;
  final int pageSize = 50;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

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
            continue;
          }

          for (var item in pageList) {
            final fullname = item['fullName']?.toString() ?? 'Unknown';
            final age = item['age']?.toString() ?? 'Unknown';
            final gender = item['gender']?.toString() ?? 'Unknown';

            await SQLHelper.save(fullname, age, gender);

            allResults
                .add({'fullName': fullname, 'age': age, 'gender': gender});
          }

          setState(() {
            progress = pageNumber / totalPages;
          });
        }
      }

      setState(() {
        resultList = allResults;
        isDownloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Download Complete! ${allResults.length} records saved')),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Download failed: ${e.toString()}";
        isDownloading = false;
      });
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Download Progress",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.white,
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.purple.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isDownloading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _glowController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: RadiationPainter(
                            progress: progress,
                            glowValue: _glowController.value,
                          ),
                          child: Container(
                            width: 250,
                            height: 250,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.3),
                                  blurRadius: 12,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${(progress * 100).toStringAsFixed(0)}%",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Downloading data...",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Page ${(progress * totalPages).toInt()} / $totalPages",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                )
              : errorMessage.isNotEmpty
                  ? Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    )
                  : resultList.isEmpty
                      ? Text("No data available",
                          style: TextStyle(color: Colors.grey))
                      : TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: Duration(milliseconds: 600),
                          builder: (context, value, child) => Opacity(
                            opacity: value,
                            child: child,
                          ),
                          child: ListView.builder(
                            itemCount: resultList.length,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            itemBuilder: (context, index) {
                              final item = resultList[index];
                              return Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 8),
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.deepPurple.shade100,
                                    child: Text(
                                      item['fullName']
                                          .toString()
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  title: Text(
                                    item['fullName'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Age: ${item['age']} | Gender: ${item['gender']}",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
        ),
      ),
    );
  }
}

class RadiationPainter extends CustomPainter {
  final double progress;
  final double glowValue;

  RadiationPainter({required this.progress, required this.glowValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = Colors.white.withOpacity(0.2);
    canvas.drawCircle(center, radius, basePaint);

    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -pi / 2,
      endAngle: 3 * pi / 2,
      colors: [
        Colors.deepPurple,
        Colors.grey,
        Colors.blueGrey,
        Colors.deepPurple
      ],
      stops: [0.0, 0.4, 0.6, 1.0],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.square;

    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * progress, //if -pi circle starts from bottom right
      false,
      progressPaint,
    );

    int ringCount = 4;
    for (int i = 0; i < ringCount; i++) {
      double ringProgress = ((glowValue + i * i * i * i / ringCount) % 1.0);
      double ringRadius = radius + 20 + (ringProgress * 40);
      double opacity = (1 - ringProgress).clamp(0.0, 1.0);

      final ringPaint = Paint()
        ..color = Colors.orange.withOpacity(0.15 * opacity)
        ..style = PaintingStyle.stroke
        //..strokeWidth = 3 + ringProgress * 2;
        ..strokeWidth = 3 + ringRadius * ringProgress * 2;

      canvas.drawCircle(center, ringRadius, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant RadiationPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.glowValue != glowValue;
}
