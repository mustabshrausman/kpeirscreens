import 'package:flutter/material.dart';
import 'package:projectscreen/download_data.dart';
import 'package:projectscreen/home_screen.dart';
import 'package:projectscreen/loginscreen.dart';
import 'controller/SQLHelper.dart';
import 'displaydatafromdatabase.dart';
import 'bottomscreen.dart';
import 'icon_bottomscreen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  Future<void> _showData() async {
    final data = await SQLHelper.getItems();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayDataScreen(dataList: data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Choose an Option',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildOptionButton(
              icon: Icons.home,
              label: 'Home Page',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => homescreen()),
                );
              },
            ),
            _buildOptionButton(
              icon: Icons.login,
              label: 'Login Page',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Registration()),
                );
              },
            ),
            _buildOptionButton(
              icon: Icons.download,
              label: 'Download Page',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DownloadScreen()),
                );
              },
            ),
            _buildOptionButton(
              icon: Icons.data_usage,
              label: 'Display All Data From DB',
              onTap: _showData,
            ),
            _buildOptionButton(
              icon: Icons.medical_services,
              label: 'Open Hepatitis Sheet',
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => const HepatitisBottomSheet(),
                );
              },
            ),
            _buildOptionButton(
              icon: Icons.insert_emoticon,
              label: 'Icon Bottom Sheet',
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => const IconBottomScreen(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Reusable button widget with icon and label
  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple.shade400,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        icon: Icon(icon, size: 26, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        onPressed: onTap,
      ),
    );
  }
}
