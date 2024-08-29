import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  List<PlatformFile?> _pickedImage = <PlatformFile?>[null, null, null];
  final List<String> _urls = <String>["", "", ""];
  PlatformFile? _clubPFP = null;
  String _urlPFP = "";

  Future _selectPicture(int picIndex) async {
    final res = await FilePicker.platform.pickFiles();

    if (res == null) return;

    setState(() {
      _pickedImage[picIndex] = res.files.first;
    });
  }

  Future _selectProfilePicture() async {
    final res = await FilePicker.platform.pickFiles();

    if (res == null) return;

    setState(() {
      _clubPFP = res.files.first;
    });
  }

  Future _unselectPicture(int picIndex) async {
    setState(() {
      if (_pickedImage[picIndex] != null) {
        _pickedImage[picIndex] = null;
      }
      else {
        _urls[0] = "";
      }
    });
  }

  Future _unselectProfilePicture() async {
    setState(() {
      if (_clubPFP != null) {
        _clubPFP = null;
      }
      else {
        _urlPFP = "";
      }
    });
  }

  Future _loadImage(String inputURL, int index) async {
    final firebaseStorage = FirebaseStorage.instance.ref().child(inputURL);
    final url = await firebaseStorage.getDownloadURL();
    setState(() {
      _urls[index] = url;
    });
  }

  Future _loadPFP(String inputURL) async {
    final firebaseStorage = FirebaseStorage.instance.ref().child(inputURL);
    final url = await firebaseStorage.getDownloadURL();
    setState(() {
      _urlPFP = url;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.myClub.profileImage1 != '') {
      setState(() {
        _loadImage(widget.myClub.profileImage1, 0);
      });
    }
    if (widget.myClub.profileImage2 != '') {
      setState(() {
        _loadImage(widget.myClub.profileImage2, 0);
      });
    }
    if (widget.myClub.profileImage3 != '') {
      setState(() {
        _loadImage(widget.myClub.profileImage3, 0);
      });
    }

    if (widget.myClub.profilePicture != '') {
      setState(() {
        _loadPFP(widget.myClub.profilePicture);
      });
    }

    setState(() {
      _clubName = widget.myClub.name;
      _clubIntro = widget.myClub.description!;
      _clubEmail = widget.myClub.email;
    });
  }


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
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                          _clubPFP != null ? Image.file(File(_clubPFP!.path!)) as ImageProvider
                          : _urlPFP != "" ? Image.network(_urlPFP) as ImageProvider :
                          const AssetImage('images/avatar_default.png'),
                        ),
                        IconButton(
                          onPressed: (){_selectProfilePicture();},
                          icon: const Icon(Icons.change_circle_outlined),
                        ),
                      ]
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
                      initialValue: _clubName,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value){
                        setState(() {
                          _clubName = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Email field
                    TextFormField(
                      initialValue: _clubEmail,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value){
                        setState(() {
                          _clubEmail = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Introduction field
                    TextFormField(
                      initialValue: _clubIntro,
                      decoration: const InputDecoration(
                        labelText: 'Intro',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onSaved: (value){
                        setState(() {
                          _clubIntro = value!;
                        });
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
                          _formKey.currentState!.save();
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
                  description: desc,
                  profilePicture: widget.myClub.profilePicture,
                  profileImage1: widget.myClub.profileImage1,
                  profileImage2: widget.myClub.profileImage2,
                  profileImage3: widget.myClub.profileImage3,
              );
              Navigator.of(context).pop();
              Navigator.of(context).pop();
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