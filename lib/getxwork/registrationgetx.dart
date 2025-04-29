import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/regitrationcontrollergetx.dart';
import '../Form2Screen.dart';
import '../bottomscreen.dart';

class Registrationn extends StatelessWidget {
  final RegistrationnController controller = Get.put(RegistrationnController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Registration"),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.indigo, size: 30),
            onPressed: () => controller.saveData(context),
          ),
        ],
      ),
      body: GetBuilder<RegistrationnController>(
        builder: (controller) {
          return controller.selectedIndex == 0
              ? buildForm1(context)
              : Form2Screen();
        },
      ),
      bottomNavigationBar: GetBuilder<RegistrationnController>(
        builder: (controller) {
          return BottomNavigationBar(
            currentIndex: controller.selectedIndex,
            onTap: (index) => controller.changeTab(index, context),
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Form 1'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.edit_document), label: 'Form 2'),
            ],
          );
        },
      ),
    );
  }

  Widget buildForm1(BuildContext context) {
    return SingleChildScrollView(
        controller: controller.scrollController,
        padding: EdgeInsets.all(20),
        child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Registration",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Name
                TextFormField(
                  controller: controller.nameController,
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

                // Date
                TextFormField(
                  controller: controller.dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Select Date",
                    suffixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () => controller.selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a date";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Age
                TextFormField(
                  controller: controller.ageController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Age",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                // Email
                TextFormField(
                  controller: controller.emailController,
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

                // Phone
                TextFormField(
                  controller: controller.phoneController,
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

                // Gender Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Select Gender",
                    border: OutlineInputBorder(),
                  ),
                  value: controller.selectedGender,
                  items: ["Male", "Female"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    controller.selectedGender = newValue!;
                    controller.update();
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Please select a gender";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),

                // Buttons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () => controller.saveData(context),
                      child: Text("Submit"),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: controller.showData,
                      child: Text("Display All Data"),
                    ),
                    SizedBox(height: 20),

                    // Data List
                    GetBuilder<RegistrationnController>(
                      builder: (controller) {
                        return controller.dataList.isEmpty
                            ? Text("No Data Found")
                            : Container(
                                height:
                                    300, // <-- important fix to avoid Expanded in ScrollView
                                child: ListView.builder(
                                  itemCount: controller.dataList.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.dataList[index];
                                    return Card(
                                      margin: EdgeInsets.all(10),
                                      child: ListTile(
                                        title: Text(item['name']),
                                        subtitle: Text(
                                            "Age: ${item['age']} - Gender: ${item['gender']}"),
                                      ),
                                    );
                                  },
                                ),
                              );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () => controller.showDataonnextpage(),
                      child: Text("Display All Data on next page"),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => controller.updatedata(),
                  child: Text("Update Data "),
                ),
                SizedBox(height: 20),
              ],
            )));
  }
}
