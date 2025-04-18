import 'package:flutter/material.dart';

class DisplayDataScreen extends StatefulWidget {
  final List<Map<String, dynamic>> dataList;

  const DisplayDataScreen({super.key, required this.dataList});

  @override
  State<DisplayDataScreen> createState() => _DisplayDataScreenState();
}

class _DisplayDataScreenState extends State<DisplayDataScreen>
    with TickerProviderStateMixin {
  late List<Map<String, dynamic>> _allData;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int _nextBatchStartIndex = 0;
  final int _batchSize = 10;
  bool _isFirstLoad = true;

  List<AnimationController> _controllers = [];
  List<Animation<Offset>> _slideAnimations = [];
  List<Animation<double>> _fadeAnimations = [];

  @override
  void initState() {
    super.initState();
    _allData = [];
    _loadMoreData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isLoadingMore) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(Duration(seconds: 1)); // Simulate delay

    final nextBatch =
        widget.dataList.skip(_nextBatchStartIndex).take(_batchSize).toList();
    _nextBatchStartIndex += nextBatch.length;

    // Create controllers and animations for new items
    for (int i = 0; i < nextBatch.length; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 800),
      );

      _slideAnimations = _controllers.map((controller) {
        return Tween<Offset>(
          begin: Offset(0, 1), // start from right
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
      }).toList();

      final animation = Tween<Offset>(
        begin: Offset(0.0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

      _controllers.add(controller);
      _slideAnimations.add(animation);

      controller.forward();
    }

    setState(() {
      _allData.addAll(nextBatch);
      _isLoadingMore = false;
    });

    if (_isFirstLoad) {
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          _isFirstLoad = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('All Data'),
        centerTitle: true,
      ),
      body: AnimatedOpacity(
        opacity: _isFirstLoad ? 0 : 1,
        duration: Duration(milliseconds: 300),
        child: ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.all(_w / 30),
          physics: _isFirstLoad
              ? NeverScrollableScrollPhysics()
              : BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: _allData.length + (_isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _allData.length) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final item = _allData[index];
            print(item);
            final animation = index < _slideAnimations.length
                ? _slideAnimations[index]
                : null;

            return animation != null
                ? SlideTransition(
                    position: animation,
                    child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  padding: const EdgeInsets.all(20),
                                  height: 300,
                                  width: double.infinity,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Details',
                                          style: TextStyle(
                                              color: Colors.purple,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          item['name'],
                                          style:
                                              TextStyle(color: Colors.purple),
                                        ),
                                        Text(
                                          'Age: ${item['age']}',
                                          style:
                                              TextStyle(color: Colors.purple),
                                        ),
                                        Text(
                                          'Father: ${item['name'].toString().split(' ').last}',
                                          style:
                                              TextStyle(color: Colors.purple),
                                        ),
                                        SizedBox(height: 50),
                                        Row(children: [
                                          Container(
                                              width: 150,
                                              height: 100,
                                              padding: EdgeInsets.only(
                                                  right: 20,
                                                  left: 20,
                                                  bottom: 20,
                                                  top: 15),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Column(children: [
                                                Image.asset(
                                                  'assests/images/women_registration.png',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                                Text('Adverse Event',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ))
                                              ])),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Container(
                                              width: 150,
                                              height: 100,
                                              padding: EdgeInsets.only(
                                                  right: 20,
                                                  left: 20,
                                                  bottom: 20,
                                                  top: 15),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Column(children: [
                                                Image.asset(
                                                  'assests/images/zero_dose.png',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                                Text('Follow-up',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ))
                                              ]))
                                        ])
                                      ])));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: _w / 20),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.1),
                                blurRadius: 40,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Row(children: [
                            Icon(
                              Icons.male,
                              color: Colors.blue,
                              size: 30, // You can adjust the size
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Age: ${item['age']}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Father: ${item['name'].toString().split(' ').last}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      'Tap to view details',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ])
                          ]),
                        )))
                : SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
//
// class DisplayDataScreen extends StatefulWidget {
//   final List<Map<String, dynamic>> dataList;
//
//   const DisplayDataScreen({super.key, required this.dataList});
//
//   @override
//   State<DisplayDataScreen> createState() => _DisplayDataScreenState();
// }
//
// class _DisplayDataScreenState extends State<DisplayDataScreen>
//     with TickerProviderStateMixin {
//   late List<Map<String, dynamic>> _data; // actual data shown
//   late List<AnimationController> _controllers;
//   late List<Animation<Offset>> _slideAnimations;
//   late List<Animation<double>> _fadeAnimations;
//
//   final ScrollController _scrollController = ScrollController();
//   bool _isLoadingMore = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _data = widget.dataList.take(10).toList(); // initially load only first 10
//     _initAnimations();
//     _startAnimations();
//
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//               _scrollController.position.maxScrollExtent - 100 &&
//           !_isLoadingMore) {
//         _loadMore();
//       }
//     });
//   }
//
//   void _initAnimations() {
//     _controllers = List.generate(_data.length, (index) {
//       return AnimationController(
//         duration: Duration(milliseconds: 500),
//         vsync: this,
//       );
//     });
//
//     _slideAnimations = _controllers.map((controller) {
//       return Tween<Offset>(
//         begin: Offset(0, 0.2), // slight slide from bottom
//         end: Offset.zero,
//       ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
//     }).toList();
//
//     _fadeAnimations = _controllers.map((controller) {
//       return Tween<double>(
//         begin: 0.0,
//         end: 1.0,
//       ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
//     }).toList();
//   }
//
//   void _startAnimations() async {
//     for (int i = 0; i < _controllers.length; i++) {
//       await Future.delayed(Duration(milliseconds: 80));
//       _controllers[i].forward();
//     }
//   }
//
//   Future<void> _loadMore() async {
//     setState(() {
//       _isLoadingMore = true;
//     });
//
//     await Future.delayed(Duration(seconds: 2)); // simulate delay
//
//     final currentLength = _data.length;
//     final newItems = widget.dataList
//         .skip(currentLength)
//         .take(10)
//         .toList(); // load 10 more items
//
//     if (newItems.isEmpty) {
//       setState(() {
//         _isLoadingMore = false;
//       });
//       return;
//     }
//
//     // Add controllers and animations for new items
//     for (var i = 0; i < newItems.length; i++) {
//       final controller = AnimationController(
//         duration: Duration(milliseconds: 500),
//         vsync: this,
//       );
//
//       final slide = Tween<Offset>(
//         begin: Offset(0, 0.2),
//         end: Offset.zero,
//       ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
//
//       final fade = Tween<double>(
//         begin: 0.0,
//         end: 1.0,
//       ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
//
//       _controllers.add(controller);
//       _slideAnimations.add(slide);
//       _fadeAnimations.add(fade);
//     }
//
//     setState(() {
//       _data.addAll(newItems);
//     });
//
//     // Start new animations
//     for (int i = currentLength; i < _data.length; i++) {
//       await Future.delayed(Duration(milliseconds: 80));
//       _controllers[i].forward();
//     }
//
//     setState(() {
//       _isLoadingMore = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     _scrollController.dispose(); // dispose scroll controller too
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('All Data')),
//       body: ListView.builder(
//         controller: _scrollController,
//         itemCount: _data.length + (_isLoadingMore ? 1 : 0), // extra for loader
//         itemBuilder: (context, index) {
//           if (index == _data.length) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: Center(
//                 child: SizedBox(
//                   width: 30,
//                   height: 30,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 ),
//               ),
//             );
//           }
//
//           final item = _data[index];
//           return SlideTransition(
//             position: _slideAnimations[index],
//             child: FadeTransition(
//               opacity: _fadeAnimations[index],
//               child: Card(
//                 margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 child: ListTile(
//                   title: Text(item.toString()),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// //
