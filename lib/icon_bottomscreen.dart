import 'package:flutter/material.dart';

class IconBottomScreen extends StatefulWidget {
  const IconBottomScreen({super.key});

  @override
  State<IconBottomScreen> createState() => _IconBottomScreenState();
}

class _IconBottomScreenState extends State<IconBottomScreen> {
  bool drop_down = true; // 🔹 Always show dropdown
  int indexxx = -1;

  final List<IconData> _icons = [
    Icons.cancel,
    Icons.settings,
    Icons.home,
    Icons.star,
    Icons.access_alarm,
    Icons.ac_unit,
    Icons.airline_seat_individual_suite,
    Icons.airplanemode_active,
    Icons.accessibility,
    Icons.account_balance,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ❌ Removed "Toggle Dropdown" button

          // ✅ Always visible dropdown section
          if (drop_down)
            Container(
              height: MediaQuery.of(context).size.height / 3,
              padding: EdgeInsets.only(bottom: 10),
              color: Colors.grey[200],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icons row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_icons.length, (index) {
                        bool isSelected = index == indexxx;
                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                indexxx = isSelected ? -1 : index;
                              });
                            },
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Transform.scale(
                                  scale: isSelected ? 1.3 : 1.1,
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    padding: EdgeInsets.all(10),
                                    // width: isSelected ? 70 : 60, // Animate size
                                    // height: isSelected ? 70 : 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? Colors.grey
                                          : Colors.grey.withOpacity(0.1),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.grey
                                            : Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: Transform.scale(
                                      scale: isSelected ? 1.5 : 1.0,
                                      child: Icon(
                                        _icons[index],
                                        size: 30,
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                )));
                      }),
                    ),
                  ),

                  // OK Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        if (indexxx == -1) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('No Icon Selected'),
                                content: Text(
                                    'Please select an icon before clicking OK.'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          print('Icon already selected: ${_icons[indexxx]}');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Click OK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
