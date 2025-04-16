import 'package:flutter/material.dart';

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  final GlobalKey _contentKey = GlobalKey();
  bool _isScrollable = false;

  @override
  void initState() {
    super.initState();
    // Wait for the layout to finish before checking height
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfScrollable();
    });
  }

  void _checkIfScrollable() {
    final RenderBox? renderBox =
        _contentKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      final contentHeight = renderBox.size.height;
      final screenHeight = MediaQuery.of(context).size.height;
      const headerHeight = 300; // approx height of red part

      if (contentHeight > (screenHeight - headerHeight)) {
        setState(() {
          _isScrollable = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: Text("Attendance", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.red,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assests/images/epilogo.png'),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Expanded Programme",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Poppins')),
                          Text("on Immunization",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Poppins')),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Mark Attendance",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Poppins')),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Check-In"),
                        style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 13, vertical: 0),
                          minimumSize: Size(0, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    "Username: ",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      "Username: Vac. Bushra Perveen Asghar HaneenhhdqiUHWCIUSHCDLOIqhcfnlihsc",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: SingleChildScrollView(
                      child: Container(
                        key: _contentKey,
                        width: double.infinity,
                        child: buildContent(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        Padding(
          padding:
              const EdgeInsets.only(top: 1, right: 10, left: 10, bottom: 5),
          child: Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
              child: Text("Routine Forms",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              buildClickableBox(
                  context,
                  'assests/images/childinj.png',
                  'Child Registration/Vaccination',
                  'You clicked Child Registration',
                  null,
                  false),
              buildClickableBox(
                  context,
                  'assests/images/womenninj.png',
                  'Women Registration/Vaccination',
                  'You clicked Women Registration',
                  null,
                  false),
              buildClickableBox(
                  context,
                  'assests/images/childd.png',
                  'Child \n Registry',
                  'you clicked child registry',
                  null,
                  false),
              buildClickableBox(context, 'assests/images/childd.png',
                  'Child \n Follow-up', 'you clicked Follow-up', null, false),
              buildClickableBox(
                  context,
                  'assests/images/womenn.png',
                  'Women \n Follow-up',
                  'you clicked women Follow-up',
                  null,
                  false),
              buildClickableBox(
                  context,
                  'assests/images/adverseeffect.png',
                  'Adverse \n Events',
                  ' you clicked adverse Effects',
                  Colors.indigo,
                  true),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10, right: 10, left: 7, bottom: 5),
          child: Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text("Extras",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              buildClickableBox(context, 'assests/images/defaulter.png',
                  'Calender', ' you clicked calender', Colors.indigo, true),
              buildClickableBox(context, 'assests/images/search00.png',
                  'Search', ' you clicked search', Colors.indigo, true),
              buildClickableBox(
                  context,
                  'assests/images/savedform.png',
                  'Saved Forms',
                  ' you clicked saved forms',
                  Colors.indigo,
                  true),
              buildClickableBox(
                  context,
                  'assests/images/due_defaulter.png',
                  'Due/Defaulter',
                  ' you clicked due defaulter',
                  Colors.indigo,
                  true),
              buildClickableBox(context, 'assests/images/vaccinestock.png',
                  'Stocks', ' you clicked stocks', Colors.indigo, true),
              buildClickableBox(context, 'assests/images/datashare.png',
                  'Data Share', ' you clicked data share', null, false),
            ],
          ),
        ),
        if (_isScrollable == true)
          SizedBox(height: 10), // ✅ only when scrollable
      ],
    );
  }

  Widget buildClickableBox(BuildContext context, String imagePath, String text1,
      String alertMessage, Color? imageColor, bool changeColor) {
    return InkWell(
      onTap: () {
        if (alertMessage.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Alert"),
                content: Text(alertMessage),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("OK"),
                  )
                ],
              );
            },
          );
        }
      },
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.blueAccent.withOpacity(0.4),
      highlightColor: Colors.white24,
      child: Container(
        width: (MediaQuery.of(context).size.width - 72) / 3,
        height: 108,
        decoration: BoxDecoration(
          color: Color(0xFFEBE9FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              changeColor
                  ? ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        imageColor!,
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(
                        imagePath,
                        width: 45,
                        height: 45,
                      ),
                    )
                  : Image.asset(
                      imagePath,
                      width: 45,
                      height: 45,
                    ),
              if (text1.isNotEmpty)
                Text(
                  text1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
