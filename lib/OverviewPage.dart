import 'package:flutter/material.dart';

class OverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Office Overview',
          style: TextStyle(
            color: Colors.white, // Set title text color to white
          ),
        ),
        backgroundColor: Color.fromARGB(255, 18, 31, 93),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white, // Set back button color to white
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 18, 31, 93),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                // VP's Room and Conference Room Area
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // VP's Room
                    _buildRoom('VP\'s Room', Colors.blueGrey),
                    SizedBox(width: 30), // Increase the SizedBox width
                    // Conference Room
                    _buildRoom('Conference Room', Colors.purple, height: 150), // Adjust the height
                  ],
                ),
                SizedBox(height: 20),
                // Workstation Area
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Workstation 1
                    _buildWorkstation('Kingdom'),
                    SizedBox(width: 20),
                    // Workstation 2
                    _buildWorkstation('Sakura'),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Workstation 3
                    _buildWorkstation('Bali'),
                    SizedBox(width: 20),
                    // Workstation 4
                    _buildWorkstation('LionCity'),
                  ],
                ),
                SizedBox(height: 20),
                // Telebooth Area
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Telebooth 1
                    _buildTelebooth(),
                    SizedBox(width: 20),
                    // Telebooth 2
                    _buildTelebooth(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoom(String name, Color color, {double height = 120}) {
    return Container(
      width: 120,
      height: height,
      color: color,
      alignment: Alignment.center,
      child: Text(
        name,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildWorkstation(String name) {
    return Container(
      width: 120,
      height: 180,
      color: Colors.green,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Workstation',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelebooth() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.blue,
      alignment: Alignment.center,
      child: Text(
        'Telebooth ',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
