import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/data/account_class.dart';
import 'package:lookout_dev/data/event_class.dart';
import 'package:lookout_dev/screen/info_screen/event_screen.dart';  
// import 'package:test_backend/models/school_events.dart';

class EventTile extends StatefulWidget {
  final EventClass myEvent;
  const EventTile({super.key, required this.myEvent});

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  String _urlPFP = "";
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

  @override
  void initState() {
    super.initState();
    _loadPFP();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventScreen(myEvent: widget.myEvent),
              ),
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: _urlPFP != "" ?
              Image.network(_urlPFP).image :
              const Image(image: AssetImage('assets/images/avatar_default.png')).image,
            ),
            title: Text(
              widget.myEvent.eventName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.myEvent.eventLocation,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.myEvent.eventTime.toString().split(' ')[0],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

