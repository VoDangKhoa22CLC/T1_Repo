import 'package:flutter/material.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/data/event_class.dart';

import '../../data/account_class.dart';

class EditProfileScreen extends StatefulWidget {
  final Club myClub;
  const EditProfileScreen({super.key, required this.myClub});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _clubName = "";
  String _clubEmail = "";
  String _clubIntro = "";
  // // Controllers to manage the state of text fields
  // final TextEditingController nameController = TextEditingController(text: 'SAB Entertainment & Arts');
  // final TextEditingController emailController = TextEditingController(text: 'sab@fit.hcmus.edu.vn');
  // final TextEditingController locationController = TextEditingController(text: 'sab@fit.hcmus.edu.vn');
  // final TextEditingController introController = TextEditingController(text: 'Fanpage chính thức của Ban Entertainment & Arts trực thuộc SAB.\n📌 Follow fanpage SAB: fb.com/sab.ctda');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background image placeholder
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

                  // Avatar placeholder
                  Positioned(
                    top: 150,
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: const AssetImage('images/avatar_default.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              // Profile information fields
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name field
                    TextFormField(
                      initialValue: widget.myClub.name,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value){
                        _clubName = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Email field
                    TextFormField(
                      initialValue: widget.myClub.email,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value){
                        _clubEmail = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Introduction field
                    TextFormField(
                      initialValue: widget.myClub.description,
                      decoration: const InputDecoration(
                        labelText: 'Intro',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onSaved: (value){
                        _clubIntro = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Photos section
                    const Text(
                      'Photos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: [
                    //       _buildPhoto('images/avatar_default.png'),
                    //       _buildPhoto('images/avatar_default.png'),
                    //       _buildPhoto('images/avatar_default.png'),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                    // Save Changes Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _showConfirmationDialog(context,
                          'Save Changes',
                          'Do you want to save changes to the profile?', _clubName, _clubEmail, _clubIntro);
                        },
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// General method to show a confirmation dialog with customizable title and description
// Should put this somewhere, like utility 
void _showConfirmationDialog(BuildContext context, String title, String description, String name, String email, String desc) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without saving
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // do some saving action here
              AccountController().editClubProfile(
                  uid: widget.myClub.uid,
                  email: email,
                  name: name,
                  userType: widget.myClub.userType,
                  description: desc,
                  hostedEventIds: widget.myClub.hostedEventIds ?? [],
                  profilePicture: widget.myClub.profilePicture,
                  profileImage1: widget.myClub.profileImage1,
                  profileImage2: widget.myClub.profileImage2,
                  profileImage3: widget.myClub.profileImage3,
                  verified: widget.myClub.verified
              );
              Navigator.of(context).pop(); // Close the dialog
              Navigator.pop(context); // Return to the previous screen
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
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