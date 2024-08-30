import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/data/event_class.dart';
import 'package:lookout_dev/screen/info_screen/event_edit.dart';

import '../../data/account_class.dart';

class EventScreen extends StatefulWidget {
  final EventClass myEvent;
  const EventScreen({super.key, required this.myEvent});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool isSubscribed = false;
  DateTime startDate = DateTime.now();
  final List<String> _urls = <String>["", "", ""];
  bool isStudent = false;
  String _urlPFP = "";
  String _hostedClub = "";
  AccountController accountController = AccountController();

  Future _loadPFP() async {
    String? path = await accountController.getImageFromUser(widget.myEvent.hostID, "profilePicture");
    if (path != ''){
      final firebaseStorage = FirebaseStorage.instance.ref().child(path);
      final url = await firebaseStorage.getDownloadURL();
      setState(() {
        _urlPFP = url;
      });
    }
  }

  Future _loadImage(String inputURL, int index) async {
    final firebaseStorage = FirebaseStorage.instance.ref().child(inputURL);
    final url = await firebaseStorage.getDownloadURL();
    setState(() {
      _urls[index] = url;
    });
  }

  void _toggleSubscription() async {
    setState(() {
      isSubscribed = !isSubscribed; // Toggle state
    });
    if (isSubscribed) {
      await accountController.appendEvents(widget.myEvent.eventID);
    } else {
      await accountController.removeEvents(widget.myEvent.eventID);
    }
  }

  void _getSubscription() async {
      AppUser? currentUser = (await accountController.getCurrentUser());
      if (currentUser is Student){
        setState(() {
          isSubscribed = currentUser.attendedEventIds!.contains(widget.myEvent.eventID);
          isStudent = true;
        });
      }

      Club? hostClub = await accountController.getClub(clubID: widget.myEvent.hostID);
      if (hostClub != null){
        setState(() {
          _hostedClub = hostClub.name;
        });
      }

  }

  @override
  void initState() {
    super.initState();

    if (widget.myEvent.eventImage1 != '') {
      setState(() {
        _loadImage(widget.myEvent.eventImage1, 0);
      });
    }
    if (widget.myEvent.eventImage2 != '') {
      setState(() {
        _loadImage(widget.myEvent.eventImage2, 1);
      });
    }
    if (widget.myEvent.eventImage3 != '') {
      setState(() {
        _loadImage(widget.myEvent.eventImage3, 2);
      });
    }
    _getSubscription();
    _loadPFP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Background image
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            end: Alignment.topCenter,
                            begin: Alignment.bottomCenter,
                            colors : <Color>[
                              Theme.of(context).primaryColor,
                              Colors.white,
                            ]
                        ),
                      )
                    ),
                    // Back button
                    Positioned(
                      left: 10,
                      top: 40,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    // Avatar and club name
                    Positioned(
                      top: 205, // Adjust this value for the elevation of the avatar overlapping background image
                      left: 20, 
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _urlPFP != "" ?
                            Image.network(_urlPFP).image :
                            const Image(image: AssetImage('assets/images/avatar_default.png')).image,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            children: [
                              const SizedBox(height: 50),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 140,
                                child: Text(
                                  widget.myEvent.eventName,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                  ],
                ),
                // Event details
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event title
                      Text(
                        "Hosted by $_hostedClub",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Event datetime
                      Text(
                        widget.myEvent.eventTime.toString().split(' ')[0],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Event location
                      Text(
                        'Location: ${widget.myEvent.eventLocation}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Subscribers: ${widget.myEvent.subscribers}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description section
                      const Divider(),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.myEvent.eventLongDescription,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Pictures section
                      const Divider(),
                      const Text(
                        'Pictures',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _urls.where((url) => (url != "")).map((url) => _buildPhoto(url)).toList(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.myEvent.eventShortDescription,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Subscribe button
      bottomNavigationBar: Visibility(
        visible: isStudent,
        child: GestureDetector(
          onTap: _toggleSubscription, // Toggle subscription on tap
          child: Container(
            decoration: BoxDecoration(
              color: isSubscribed ? Colors.grey : Colors.blue, // Change color based on state
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: 60,
            child: Center(
              child: Text(
                isSubscribed ? 'Unsubscribe' : 'Subscribe', // Change text based on state
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

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
}
