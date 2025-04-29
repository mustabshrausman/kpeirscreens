import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/displaydatafromdatabasegetx.dart';

class DisplayDataScreen extends StatelessWidget {
  final List<Map<String, dynamic>> dataList;

  const DisplayDataScreen({Key? key, required this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<DisplayDataController>(
      init: DisplayDataController(dataList), // Initialize controller with data
      builder: (controller) {
        double _w = MediaQuery.of(context).size.width;
        return Scaffold(
          appBar: AppBar(
            title: Text('All Data'),
            centerTitle: true,
          ),
          body: AnimatedOpacity(
            opacity: controller.isFirstLoad ? 0 : 1, // Fade in after first load
            duration: Duration(milliseconds: 300),
            child: ListView.builder(
              controller: controller.scrollController,
              padding: EdgeInsets.all(_w / 30),
              physics: controller.isFirstLoad
                  ? NeverScrollableScrollPhysics()
                  : BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
              itemCount: controller.allData.length +
                  (controller.isLoadingMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                // Show a loading spinner when more data is being loaded
                if (index == controller.allData.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                // Get the current data item
                final item = controller.allData[index];
                final animation = index < controller.slideAnimations.length
                    ? controller.slideAnimations[index]
                    : null;

                return animation != null
                    ? SlideTransition(
                        position:
                            animation, // Apply slide animation for each item
                        child: GestureDetector(
                          onTap: () {
                            // Show bottom sheet on tap
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.all(20),
                                height: 300,
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Details',
                                        style: TextStyle(
                                            color: Colors.purple,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 20),
                                    Text(item['name'],
                                        style: TextStyle(color: Colors.purple)),
                                    Text('Age: ${item['age']}',
                                        style: TextStyle(color: Colors.purple)),
                                    Text(
                                        'Father: ${item['name'].toString().split(' ').last}',
                                        style: TextStyle(color: Colors.purple)),
                                    SizedBox(height: 50),
                                    Row(
                                      children: [
                                        _bottomButton(
                                            'assests/images/women_registration.png',
                                            'Adverse Event'),
                                        SizedBox(width: 20),
                                        _bottomButton(
                                            'assests/images/zero_dose.png',
                                            'Follow-up'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
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
                            child: Row(
                              children: [
                                Icon(Icons.male, color: Colors.blue, size: 30),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['name'],
                                        style: TextStyle(color: Colors.white)),
                                    Text('Age: ${item['age']}',
                                        style: TextStyle(color: Colors.white)),
                                    Text(
                                        'Father: ${item['name'].toString().split(' ').last}',
                                        style: TextStyle(color: Colors.white)),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        'Tap to view details',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox
                        .shrink(); // Ensure that no item is built if no animation is available
              },
            ),
          ),
        );
      },
    );
  }

  Widget _bottomButton(String imagePath, String label) {
    return Container(
      width: 150,
      height: 100,
      padding: EdgeInsets.only(right: 20, left: 20, bottom: 20, top: 15),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Image.asset(imagePath, width: 40, height: 40),
          Text(label,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              )),
        ],
      ),
    );
  }
}
