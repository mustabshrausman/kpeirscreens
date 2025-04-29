import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller/SQLHelper.dart';
import '../../Form2Screen.dart';
import '../../bottomscreen.dart';
import '../../download_data.dart';
import '../displaydatafromdatabasegetxUI.dart';

class RegistrationnController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  List<Map<String, dynamic>> dataList = [];
  String? selectedGender;
  RxBool isForm1Completed = false.obs;
  int selectedIndex = 0;

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(() => formKey.currentState?.validate());
    dateController.addListener(() => formKey.currentState?.validate());
    ageController.addListener(() => formKey.currentState?.validate());
    emailController.addListener(() => formKey.currentState?.validate());
    phoneController.addListener(() => formKey.currentState?.validate());
  }

  Future<void> saveData(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      scrollToFirstError();
      return;
    }

    int id = await SQLHelper.save(
      nameController.text,
      ageController.text,
      selectedGender!,
    );

    if (id > 0) {
      isForm1Completed = true.obs;
      selectedIndex = 1;
      update(); //  ye setState ka alternative hai GetX mein

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Form 1 Saved!")),
      );
    } else {
      print("Error saving data");
    }
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      ageController.text = calculateAge(pickedDate);
      update();
    }
  }

  String calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age.toString();
  }

  Future<void> showData() async {
    final data = await SQLHelper.getItems();
    dataList = data;
    print(dataList);
    //Get.to(DisplayDataScreen(dataList: data));
    update();
  }

  Future<void> updatedata() async {
    try {
      final a = int.tryParse(ageController.text) ?? 0;

      // Update
      final result =
          await SQLHelper.updateItem(1, 'newupdatedname', 'newupdatedgender');

      if (result > 0) {
        // Fetch updated record
        final updatedRecord = await SQLHelper.getItem(1);

        if (updatedRecord != null) {
          dataList = updatedRecord;
          update(); // for GetBuilder or GetX
          Get.snackbar("Success", "Data updated successfully",
              snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.snackbar("Error", "Failed to fetch updated data",
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar("Error", "No rows were updated",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
      print("Update error: $e");
    }
  }

  Future<void> showDataonnextpage() async {
    final data = await SQLHelper.getItems();
    dataList = data;
    print(dataList);
    Get.to(DisplayDataScreen(dataList: data));
    //update();
  }

  void scrollToFirstError() {
    Future.delayed(Duration(milliseconds: 300), () {
      scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void downloadData(BuildContext context) {
    Get.to(DownloadScreen());
  }

  void changeTab(int index, BuildContext context) {
    if (index == 1 && !isForm1Completed.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill Form 1 first!"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    selectedIndex = index;
    update();
  }
}
