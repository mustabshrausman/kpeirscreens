import 'package:flutter/material.dart'; // Flutter UI toolkit
import 'package:intl/intl.dart'; // Date formatting ke liye

class HepatitisBottomSheet extends StatefulWidget {
  const HepatitisBottomSheet({super.key});

  @override
  State<HepatitisBottomSheet> createState() => _HepatitisBottomSheetState();
}

class _HepatitisBottomSheetState extends State<HepatitisBottomSheet> {
  int selectedImageIndex = -1; // Image selection track karne ke liye
  String? dropdownValue; // Dropdown se selected value
  bool dropdownSelected = false; // Dropdown select hua ya nahi
  bool showWarning = false; // Custom Urdu warning show karne ke liye

  // Image assets list
  List<String> imagePaths = [
    'assests/images/due_defaulter.png',
    'assests/images/due_defaulter.png',
    'assests/images/due_defaulter.png',
    'assests/images/injections-fluid.png',
  ];

  // Image labels
  List<String> imageLabels = [
    'Schedule\n',
    'Retro\n',
    'Retro Date\n Missing',
    'Vaccinate\n',
  ];

  DateTime selectedDate = DateTime.now(); // Default selected date

  // Formatted date text
  String get formattedDate => DateFormat('dd/MM/yyyy').format(selectedDate);

  // Date picker function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Default date
      firstDate: DateTime(2000), // Earliest date
      lastDate: DateTime(2100), // Latest date
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked; // Date update
      });

      // Current date comparison
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day);
      final DateTime pickedDate =
          DateTime(picked.year, picked.month, picked.day);

      // Agar Retro selected ho aur dropdown bhi selected ho
      if (selectedImageIndex == 1 && dropdownSelected) {
        if (pickedDate != today) {
          setState(() {
            showWarning = true; // Urdu warning dikhao
          });

          // 2 seconds baad warning hide karo
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                showWarning = false;
              });
            }
          });
          return; // Exit function
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Keyboard padding
      ),
      child: Stack(
        //Used Stack for warning
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF9bd4de), // Header background color
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: const Text(
                  "Hepatitis B0", // Title
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4DB4D7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // Horizontal image row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(imagePaths.length, (index) {
                    bool isSelected = selectedImageIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImageIndex = index; // Image select
                          dropdownValue = null;
                          dropdownSelected = false;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.all(6),
                        height: 100,
                        width: 86,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF4DB4D7) // Select highlight
                              : Colors.transparent,
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
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF4DB4D7),
                              colorBlendMode: BlendMode.srcIn,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              imageLabels[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 20),

              // Dropdown for Retro options
              if (selectedImageIndex == 1 || selectedImageIndex == 2)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Select Option:",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),

                      // Dropdown wrapped in styled container
                      Expanded(
                        flex: 2, // You can adjust width ratio here
                        child: DropdownButtonHideUnderline(
                          child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10), // Inner padding
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded border
                                borderSide: const BorderSide(
                                    color: Colors.grey), // Grey border
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true, // Full width dropdown
                              value: dropdownValue,
                              hint: const Text(
                                "CHC Attariwal",
                                style: TextStyle(
                                    color: Colors.grey), // Hint text style
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                  dropdownSelected = true;
                                });
                              },
                              items: [
                                'CHC Attariwal',
                                'BHU Akhurwal',
                                'BHU Ara Khel',
                                'BHU Bosti Khel',
                                'BHU Paya',
                                'CHC Ghareba',
                                'BHU sheen dand',
                                'BHU Turki ismailkhel',
                                'BHU Sheraki',
                                'BHU Tor Chapar',
                                'CD Naseem ( bazar )',
                                'CH Zarghun khel'
                              ]
                                  .map((String value) =>
                                      DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (selectedImageIndex == 3)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Select Option:",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),

                      // Dropdown wrapped in styled container
                      Expanded(
                        flex: 2, // You can adjust width ratio here
                        child: DropdownButtonHideUnderline(
                          child: InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10), // Inner padding
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded border
                                borderSide: const BorderSide(
                                    color: Colors.grey), // Grey border
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true, // Full width dropdown
                              value: dropdownValue,
                              hint: const Text(
                                "Vaccinate 1",
                                style: TextStyle(
                                    color: Colors.grey), // Hint text style
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                  dropdownSelected = true;
                                });
                              },
                              items: [
                                'Vaccinate 1',
                                'Vaccinate 2',
                                'Vaccinate 3',
                                'Vaccinate 4',
                                'Vaccinate 5',
                                'Vaccinate 6',
                                'Vaccinate 7',
                                'Vaccinate 8',
                                'Vaccinate 9',
                                'Vaccinate 10',
                                'Vaccinate 11',
                                'Vaccinate 12'
                              ]
                                  .map((String value) =>
                                      DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 10),

              // Date and Done button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (selectedImageIndex == 0 || selectedImageIndex == 1)
                      GestureDetector(
                        onTap: () => _selectDate(context), // Open date picker
                        child: Row(
                          children: [
                            const Text(
                              'Date: ',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                  fontSize: 15, color: Color(0xFF4DB4D7)),
                            ),
                          ],
                        ),
                      ),
                    if (selectedImageIndex == 0 || selectedImageIndex == 1)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4DB4D7),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Bottom sheet close
                        },
                        child: const Text("DONE",
                            style: TextStyle(color: Colors.white)),
                      ),
                    if (selectedImageIndex == 2 || selectedImageIndex == 3)
                      Container(
                        padding: const EdgeInsets.only(left: 285),
                        // margin: const EdgeInsets.symmetric(horizontal: 3),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4DB4D7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context); // Bottom sheet close
                          },
                          child: const Text("DONE",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Custom Urdu warning when wrong date selected
          if (showWarning)
            Positioned(
              left: 20,
              right: 20,
              bottom: 160, // Bottom se distance
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(8),
                color: Colors.black, // Background color
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: Text(
                    "براہِ مہربانی آج ہی کی تاریخ کا انتخاب کریں", // Urdu warning
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
