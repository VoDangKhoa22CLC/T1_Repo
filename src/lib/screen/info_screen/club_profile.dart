import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/data/account_class.dart';
import 'package:lookout_dev/screen/info_screen/profile_edit.dart';

// void main() async{
//   AppUser? curU = await AccountController().getCurrentUser();
//   runApp(MaterialApp(
//     home: ProfileScreen(currentClub: curU as Club),
//   ));
// }

class ProfileScreen extends StatefulWidget {
  final Club myClub;
  const ProfileScreen({super.key, required this.myClub});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<String> _urls = ["", "", ""];
  String _urlPFP = "";
  String _clubName = "";
  String _clubEmail = "";
  String _clubDescription = "";
  int _createdEvents = 0;

  Widget _buildPhoto(String imageUrl) {
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

  Future _loadPFP(String inputURL) async {
    final firebaseStorage = FirebaseStorage.instance.ref().child(inputURL);
    final url = await firebaseStorage.getDownloadURL();
    setState(() {
      _urlPFP = url;
    });
  }

  Future _loadImage(String inputURL, int index) async {
    final firebaseStorage = FirebaseStorage.instance.ref().child(inputURL);
    final url = await firebaseStorage.getDownloadURL();
    setState(() {
      _urls[index] = url;
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
        _loadImage(widget.myClub.profileImage2, 1);
      });
    }
    if (widget.myClub.profileImage3 != '') {
      setState(() {
        _loadImage(widget.myClub.profileImage3, 2);
      });
    }

    if (widget.myClub.profilePicture != '') {
      setState(() {
        _loadPFP(widget.myClub.profilePicture);
      });
    }

    if (widget.myClub.hostedEventIds != null) {
      _createdEvents = widget.myClub.hostedEventIds!.length;
    }
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        end: Alignment.topCenter,
                        begin: Alignment.bottomCenter,
                        colors : <Color>[
                          Theme.of(context).primaryColor,
                          Colors.white,
                        ]
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
                        backgroundImage: _urlPFP != "" ? Image.network(_urlPFP).image : const Image(image: AssetImage("assets/images/avatar_default.png")).image,
                      ),
                      // Add a check mark if the club is verified
                      if (widget.myClub.verified == 'true')
                        Positioned(
                          bottom: 0,
                          right: -5,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
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
            const SizedBox(height: 75), // Space to account for avatar overlap
            // Club name
            Text(
              widget.myClub.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Email with icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.email, color: Colors.grey),
                const SizedBox(width: 8),
                Text(widget.myClub.email),
              ],
            ),
            const SizedBox(height: 10),
            // Number of events created
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.event, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                 '$_createdEvents events created'
                )
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
                    widget.myClub.description!,
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
                      children: _urls.where((url) => (url != "")).map((url) => _buildPhoto(url)).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                label: Text('Manage Profile', style: TextStyle(color: Theme.of(context).primaryColor)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  textStyle: const TextStyle(fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(myClub: widget.myClub),
                    ),
                  );
                },
              ),
            )
          ],
          
        ),
      ),
    );
  }
}