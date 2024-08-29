import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/data/account_class.dart';
import 'package:lookout_dev/screen/info_screen/profile_edit.dart';

void main() async{
  AppUser? curU = await AccountController().getCurrentUser();
  runApp(MaterialApp(
    home: ProfileScreen(currentClub: curU as Club),
  ));
}

class ProfileScreen extends StatelessWidget {

  final Club currentClub;
  const ProfileScreen({super.key, required this.currentClub});


  Widget _buildNetworkPhoto(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

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
                  decoration: const BoxDecoration(
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
                    decoration: const BoxDecoration(
                      color: Colors.white, // White background
                      shape: BoxShape.circle, // Circular shape
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black), // Black icon
                      onPressed: () {
                        Navigator.pop(context); // Pops out of the current screen
                      },
                    ),
                  ),
                ),

                // Avatar
                Positioned(
                  top: 150, // Adjust the overlap by changing the top value
                  left: 0,
                  right: 0, 
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                      CircleAvatar (
                        radius: 60,
                        backgroundImage: currentClub.profilePicture != "" ? _buildNetworkPhoto(currentClub.profilePicture) as ImageProvider : const AssetImage("images/avatar_default.png") as ImageProvider,
                      ),
                      // Add a check mark if the club is verified
                      if (currentClub.verified == 'true') 
                            Positioned(
                              bottom: 0,
                              right: -5,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 30,
                                ),
                              ),
                            ),
                      ]
                    )
                  )
                ),
              ],
            ),
            const SizedBox(height: 60), // Space to account for avatar overlap
            // Club name
            Text(
              currentClub.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Email with icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.email, color: Colors.grey),
                const SizedBox(width: 8),
                Text(currentClub.email),
              ],
            ),
            const SizedBox(height: 10),
            // Number of events created
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.event, color: Colors.grey),
                const SizedBox(width: 8),
                Text(' events created.'), 
              ],
            ),
            const SizedBox(height: 20),
            // Introduction section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Introduction',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentClub.description!,
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
                  const Text(
                    'Photos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <String>[
                        currentClub.profileImage1,currentClub.profileImage2,currentClub.profileImage3,
                      ].where((url) => (url != "")).map((url) => _buildNetworkPhoto(url)).toList(),
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const EditProfileScreen()),
            //     );
            //   },
            //   child: const Text('Edit Profile', style: TextStyle(fontSize: 16)),
            // ),
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