import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lookout_dev/screen/info_screen/user_screen.dart';
import 'package:lookout_dev/screen/login.dart';
import 'package:lookout_dev/template/event_tile.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Profile',
          ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ),
      body: Container(
        // padding: EdgeInsets.all(5),
        // child: gestureDetector,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: <Widget>[
              buildTop(),
              textField('Name', 'High jump audience'),
              textField('Email', 'grailmaster01@gmail.com'),
              textField('Location', 'Fuyuki'),
              textField('Intro', '', maxLines: 3),
            ],
          )
        )
      ),
    );
  }

  Widget buildTop() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 70),
          child: buildCoverImage(),
        ),
        Positioned(
          top: 70,
          child: buildProfileImage()
        )
      ],
    );
  }

  Widget buildCoverImage() {
    return Container(
      child: Image.network(
        'https://cdn.discordapp.com/attachments/633274408554856461/1274320862237036595/shirou_hcmus.jpg?ex=66c1d349&is=66c081c9&hm=c7632f1b70a8933614a2a9b18dd017be1e8394e5cd15732f843c4f6e13cea5a7&',
        width: double.infinity,
        height: 140,
        fit: BoxFit.cover
      ),
    );
  }

  Widget buildProfileImage() {
    return CircleAvatar(
      radius: 70,
      backgroundColor: Colors.black,
      child: CircleAvatar(
        radius: 69,
        backgroundImage: NetworkImage('https://pbs.twimg.com/media/GUL20KWXkAAqo4c?format=jpg&name=medium'),
      ),
    );
  }

  Widget textField(String sectionName, String content, {int maxLines=1}) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        // onChanged: ,
        minLines: 1,
        maxLines: maxLines,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: 15
        ),
        decoration: InputDecoration(
          labelText: content != '' ? content : sectionName,
          hintText: content,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          )
        ),
      ),
    );
  }
}