import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'controller/SQLHelper.dart';
import 'Form2Screen.dart';
import 'package:dio/dio.dart';
import 'package:projectscreen/download_data.dart';
import 'bottomscreen.dart';

class Registration extends StatefulWidget {
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  List<Map<String, dynamic>> _dataList = [];
  String? selectedGender;
  bool isForm1Completed = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _nameController.addListener(() => _formKey.currentState?.validate());
    _dateController.addListener(() => _formKey.currentState?.validate());
    _ageController.addListener(() => _formKey.currentState?.validate());
    _emailController.addListener(() => _formKey.currentState?.validate());
    _phoneController.addListener(() => _formKey.currentState?.validate());
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) {
      _scrollToFirstError();
      return;
    }

    int id = await SQLHelper.save(
      _nameController.text,
      _ageController.text,
      selectedGender!,
    );

    if (id > 0) {
      print("Data saved successfully to database");
      setState(() {
        isForm1Completed = true;
        selectedIndex = 1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Form 1 Saved!")),
      );
    } else {
      print("Error saving data");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        _ageController.text = _calculateAge(pickedDate);
      });
    }
  }

  String _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age.toString();
  }

  Future<void> _showData() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _dataList = data;
    });
  }

  void _scrollToFirstError() {
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> download_data() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DownloadScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Registration"), actions: [
        IconButton(
          icon: Icon(Icons.save, color: Colors.indigo, size: 30),
          onPressed: _saveData,
        ),
      ]),
      body: selectedIndex == 0 ? _buildForm1() : Form2Screen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == 1 && !isForm1Completed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please fill Form 1 first!"),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Form 1'),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            label: 'Form 2',
          ),
        ],
      ),
    );
  }

  Widget _buildForm1() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Registration",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().length < 3) {
                  return "Name must be at least 3 characters";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Select Date",
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              onTap: () => _selectDate(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please select a date";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _ageController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value)) {
                  return "Please enter a valid email";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: 'Enter Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.length < 10 ||
                    value.contains(',')) {
                  return "Please enter a valid phone number";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Gender",
                border: OutlineInputBorder(),
              ),
              value: selectedGender,
              items: ["Male", "Female"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue!;
                });
              },
              validator: (value) {
                if (value == null) {
                  return "Please select a gender";
                }
                return null;
              },
            ),
            SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _saveData,
                  child: Text("Submit"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _showData,
                  child: Text("Display All Data"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => download_data(),
                  child: Text("Download All Data"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    final parentContext = context;
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (bottomSheetContext) {
                        return HepatitisBottomSheet(); // 👈 yeh pass krna hai
                      },
                    );
                  },
                  child: Text("Open Hepatitis Sheet"),
                ),
              ],
            ),
            SizedBox(height: 20),
            _dataList.isEmpty
                ? Center(child: Text("No Data Found"))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _dataList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(_dataList[index]['name']),
                          subtitle: Text(
                            "Age: ${_dataList[index]['age']} - Gender: ${_dataList[index]['gender']}",
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
