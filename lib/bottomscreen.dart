import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class HepatitisBottomSheet extends StatefulWidget {
  final BuildContext parentContext;
  const HepatitisBottomSheet({super.key, required this.parentContext});

  @override
  State<HepatitisBottomSheet> createState() => _HepatitisBottomSheetState();
}

class _HepatitisBottomSheetState extends State<HepatitisBottomSheet> {
  int selectedImageIndex = -1;
  String? dropdownValue;
  bool dropdownSelected = false;

  List<String> imagePaths = [
    'assests/images/due_defaulter.png',
    'assests/images/due_defaulter.png',
    'assests/images/due_defaulter.png',
    'assests/images/injections-fluid.png',
  ];

  List<String> imageLabels = [
    'Schedule\n',
    'Retro\n',
    'Retro Date\n Missing',
    'Vaccinate\n',
  ];

  DateTime selectedDate = DateTime.now();
  String get formattedDate => DateFormat('dd/MM/yyyy').format(selectedDate);

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime pickedDate = DateTime(picked.year, picked.month, picked.day);
      print("$pickedDate $today");

      // ✅ Retro selected & dropdown selected
      if (selectedImageIndex == 1 && dropdownSelected) {
        if (pickedDate != today) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(Navigator.of(context).context).showSnackBar(
              SnackBar(
                content: Text(
                  "براہِ مہربانی آج ہی کی تاریخ کا انتخاب کریں",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.black,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(bottom: 70, left: 40, right: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                duration: Duration(seconds: 2),
              ),
            );
          });
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF9bd4de),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              "Hepatitis B0",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4DB4D7),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 20),

          // Image Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(imagePaths.length, (index) {
              bool isSelected = selectedImageIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedImageIndex = index;
                    dropdownValue = null;
                    dropdownSelected = false;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  padding: EdgeInsets.all(6),
                  height: 110,
                  width: 86,
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF4DB4D7) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        imagePaths[index],
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                        color: isSelected ? Colors.white : Color(0xFF4DB4D7),
                        colorBlendMode: BlendMode.srcIn,
                      ),
                      SizedBox(height: 5),
                      Text(
                        imageLabels[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: 20),

          // Retro selected — show dropdown
          if (selectedImageIndex == 1 || selectedImageIndex == 2)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Select Option:",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    hint: Text("Choose"),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        dropdownSelected = true;
                      });
                    },
                    items: ['Option 1', 'Option 2', 'Option 3']
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),

          SizedBox(height: 10),

          // Date and Done button row (Always visible)
          if (selectedImageIndex == 1 || selectedImageIndex == 0)
            // Date and Done button row (Always visible)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (selectedImageIndex == 0 || selectedImageIndex == 1)
                      GestureDetector(
                        onTap: _selectDate,
                        child: Row(
                          children: [
                            Text(
                              'Date: ',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xFF4DB4D7)),
                            ),
                          ],
                        ),
                      ),
                    if (selectedImageIndex == 0 || selectedImageIndex == 1)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4DB4D7),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        onPressed: () {
                          print(
                              "Button pressed with index: $selectedImageIndex");
                          Navigator.pop(context);
                        },
                        child:
                            Text("DONE", style: TextStyle(color: Colors.white)),
                      ),
                  ]),
            ),

          if (selectedImageIndex == 2 || selectedImageIndex == 3)
            Container(
                margin: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4DB4D7),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    onPressed: () {
                      print("Button pressed with index: $selectedImageIndex");
                      Navigator.pop(context);
                    },
                    child: Text("DONE", style: TextStyle(color: Colors.white)),
                  ),
                ))
        ],
      ),
    );
  }
}
