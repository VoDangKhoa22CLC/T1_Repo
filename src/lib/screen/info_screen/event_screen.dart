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
  bool isSubscribed  = false;
  DateTime startDate = DateTime.now();
  final List<String> _urls = <String>["", "", ""];

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
      await AccountController().appendEvents(widget.myEvent.eventID);
    } else {
      await AccountController().removeEvents(widget.myEvent.eventID);
    }
  }

  void _getSubscription() async {
      Student? currentUser = (await AccountController().getCurrentUser()) as Student?;
      setState(() {
        isSubscribed = currentUser!.attendedEventIds!.contains(widget.myEvent.eventID);
      });
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
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
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
                            backgroundImage: AssetImage('images/avatar_default.png'),
                          ),
                          SizedBox(width: 16),
                          Column(
                            children: [
                              SizedBox(height: 50), 
                              Container(
                                width: MediaQuery.of(context).size.width - 140,
                                child: Text(
                                  '${widget.myEvent.hostID}',
                                  style: TextStyle(
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
                SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event title
                      Text(
                        widget.myEvent.eventName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Event datetime
                      Text(
                        '${widget.myEvent.eventTime}',
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
                        widget.myEvent.eventShortDescription,
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
                          children: _urls.map((url) => _buildPhoto(url)).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Subscribe button
      bottomNavigationBar: GestureDetector(
        onTap: _toggleSubscription, // Toggle subscription on tap
        child: Container(
          decoration: BoxDecoration(
            color: isSubscribed ? Colors.grey : Colors.blue, // Change color based on state
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: 60,
          child: Center(
            child: Text(
              isSubscribed ? 'Unsubscribe' : 'Subscribe', // Change text based on state
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
