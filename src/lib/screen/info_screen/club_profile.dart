import 'package:flutter/material.dart';
import 'package:lookout_dev/screen/editprofile.dart';
void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
  ));
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Background image
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/avatar_default.png'), 
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Back button
                Positioned(
                  left: 10,
                  top: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // White background
                      shape: BoxShape.circle, // Circular shape
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black), // Black icon
                      onPressed: () {
                        Navigator.pop(context); // Pops out of the current screen
                      },
                    ),
                  ),
                ),
                // Avatar
                Positioned(
                  top: 150, // Adjust the overlap by changing the top value
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('images/avatar_default.png'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60), // Space to account for avatar overlap
            // Club name
            Text(
              'SAB Entertainment & Arts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Email with icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email, color: Colors.grey),
                SizedBox(width: 8),
                Text('sab@fit.hcmus.edu.vn'),
              ],
            ),
            SizedBox(height: 10),
            // Location with icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                SizedBox(width: 8),
                Text('sab@fit.hcmus.edu.vn'),
              ],
            ),
            SizedBox(height: 20),
            // Introduction section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Introduction',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Fanpage chính thức của Ban Entertainment & Arts trực thuộc SAB.📌 Follow fanpage SAB: fb.com/sab.ctda',
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            // Photos section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Photos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildPhoto('images/avatar_default.png'), 
                        _buildPhoto('images/avatar_default.png'),
                        _buildPhoto('images/avatar_default.png'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
              child: Text('Edit Profile', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto(String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imagePath,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}