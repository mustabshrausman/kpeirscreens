import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ilrtemp extends StatefulWidget {
  const ilrtemp({super.key});

  @override
  State<ilrtemp> createState() => _ilrtempState();
}

class _ilrtempState extends State<ilrtemp> {
  int selectedchipindex = -1;
  int alarmlistindex = -1;
  int yesOptionIndex = -1;
  int Ilrindex = -1;
  int tempindex = -1;
  bool showWarning = false; // Changed to be part of State class

  bool isChecked = false; // checkbox state
  final List<String> yesOptions = ['Freeze(+)', 'Heat(-)'];
  final List<String> alarmlist = ['Yes', 'No'];
  final List<String> chipLabels = [
    'Working Well',
    'Working but needs more maintenance'
  ];
  final List<String> Ilr = ['Non Functional', 'Non Working', 'Not Available'];
  final List<String> temperature = [
    'Monitor not available',
    'Device not functional\n',
    'Device not available'
  ];
  final TextEditingController tempController = TextEditingController();

  void checkalloptions() {
    if (selectedchipindex == -1 &&
        alarmlistindex == -1 &&
        Ilrindex == -1 &&
        tempindex == -1) {
      setState(() {
        showWarning = true;

        // Update showWarning in setState
      });
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            showWarning = false;
          });
        }
      });
    } else {
      setState(() {
        showWarning = false; // Hide warning if valid options are selected
      });
    }
  }

  @override
  void initState() {
    super.initState();

    tempController.addListener(() {
      final text = tempController.text;
      if (text.isNotEmpty) {
        final value = int.tryParse(text);
        if (value != null && value > 10) {
          setState(() {
            showWarning = true;
          });
          Future.delayed(Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                showWarning = false;
              });
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // back action
          },
          child: Row(
            children: [
              SizedBox(height: 8),
              Icon(Icons.arrow_back, color: Colors.white),
              SizedBox(width: 4),
            ],
          ),
        ),
        title: Text(
          'ILR Temperature',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              checkalloptions();
            },
            child: Text('DONE',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
        backgroundColor: Colors.indigo,
      ),
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Visibility(
                visible:
                    !isChecked, // Content visible only if checkbox is not checked
                child: Container(
                  child: Column(
                    children: [
                      TextField(
                        controller: tempController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                              2), // limits to 2 characters
                          FilteringTextInputFormatter
                              .digitsOnly, // allows only digits
                        ],
                        decoration: InputDecoration(
                          hintText: 'Temperature of ILR()', // Placeholder text
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'ILR Status:',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          spacing: 10,
                          children: List.generate(
                            chipLabels.length,
                            (index) => ChoiceChip(
                              label: Text(chipLabels[index]),
                              selected: selectedchipindex == index,
                              selectedColor: Colors.indigo,
                              showCheckmark: false,
                              backgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedchipindex = index;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Alarm:',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          spacing: 10,
                          children: List.generate(
                            alarmlist.length,
                            (index) => ChoiceChip(
                              label: Text(alarmlist[index]),
                              selected: alarmlistindex == index,
                              selectedColor: Colors.indigo,
                              showCheckmark: false,
                              backgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              onSelected: (bool selected) {
                                setState(() {
                                  alarmlistindex = index;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      if (alarmlistindex == 0)
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Wrap(
                              spacing: 10,
                              children: List.generate(
                                yesOptions.length,
                                (index) => ChoiceChip(
                                  label: Text(yesOptions[index]),
                                  selected: yesOptionIndex == index,
                                  selectedColor: Colors.indigo,
                                  showCheckmark: false,
                                  backgroundColor: Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: Colors.transparent),
                                  ),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      yesOptionIndex = index;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                                if (isChecked) {
                                  selectedchipindex = -1;
                                  alarmlistindex = -1;
                                  yesOptionIndex = -1;
                                  tempController.clear();
                                }
                                if (!isChecked) {
                                  Ilrindex = -1;
                                  yesOptionIndex = -1;
                                  tempindex = -1;
                                }
                              });
                            },
                          ),
                          Text("Unable to record Temperature?"),
                        ],
                      ),
                      Visibility(
                          visible: isChecked,
                          child: Container(
                              padding: EdgeInsets.only(left: 18),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Ilr:',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: Wrap(
                                        spacing: 5,
                                        children: List.generate(
                                          Ilr.length,
                                          (index) => ChoiceChip(
                                            label: Text(Ilr[index]),
                                            selected: Ilrindex == index,
                                            selectedColor: Colors.indigo,
                                            showCheckmark: false,
                                            backgroundColor: Colors.grey[300],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              side: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            onSelected: (bool selected) {
                                              setState(() {
                                                Ilrindex = index;
                                              });
                                            },
                                          ),
                                        ),
                                      )),
                                  SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Temperature:',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: Wrap(
                                        spacing: 5,
                                        children: List.generate(
                                          temperature.length,
                                          (index) => ChoiceChip(
                                            label: Text(temperature[index]),
                                            selected: tempindex == index,
                                            selectedColor: Colors.indigo,
                                            showCheckmark: false,
                                            backgroundColor: Colors.grey[300],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              side: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            onSelected: (bool selected) {
                                              setState(() {
                                                tempindex = index;
                                              });
                                            },
                                          ),
                                        ),
                                      ))
                                ],
                              ))),
                    ],
                  )),
            ],
          ),
        ),
        if (showWarning)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Temperature darj kren',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
      ]),
    );
  }
}
